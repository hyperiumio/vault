import Combine
import Foundation

public class VaultItemStore<Cryptor> where Cryptor: MultiMessageCryptor {
    
    public let didChange = PassthroughSubject<Void, Never>()
    
    private let directoryUrl: URL
    private let cryptoKey: Cryptor.Key
    private let fileOperationQueue = DispatchQueue(label: "VaultFileOperationQueue")
    
    public init(directoryUrl: URL, cryptoKey: Cryptor.Key) {
        self.directoryUrl = directoryUrl
        self.cryptoKey = cryptoKey
    }
    
    public func loadItemInfos() -> Future<[ItemInfo], Error> {
        return Future { [directoryUrl, cryptoKey, fileOperationQueue] promise in
            fileOperationQueue.async {
                let result = Result<[ItemInfo], Error> {
                    guard FileManager.default.fileExists(atPath: directoryUrl.path) else {
                        return []
                    }
                    
                    return try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles).map { url in
                        return try FileReader.read(url: url) { fileReader in
                            return try ItemInfo(cryptoKey: cryptoKey, from: fileReader)
                        }
                    }
                }
                promise(result)
            }
        }
    }
    
    public func loadVaultItem(for itemInfo: ItemInfo) -> Future<VaultItem, Error> {
        return Future { [directoryUrl, cryptoKey, fileOperationQueue] promise in
            fileOperationQueue.async {
                let result = Result<VaultItem, Error> {
                    let itemUrl = directoryUrl.appendingPathComponent(itemInfo.id.uuidString, isDirectory: false)
                    return try FileReader.read(url: itemUrl) { fileReader in
                        return try itemInfo.decryptedVaultItem(using: cryptoKey, from: fileReader)
                    }
                }
                promise(result)
            }
        }
    }
    
    public func saveVaultItem(_ vaultItem: VaultItem) -> Future<Void, Error> {
        return Future { [didChange, directoryUrl, cryptoKey, fileOperationQueue] promise in
            fileOperationQueue.async {
                let result = Result {
                    let itemUrl = directoryUrl.appendingPathComponent(vaultItem.id.uuidString, isDirectory: false)
                    try VaultItemCryptor<Cryptor>.encrypted(vaultItem, using: cryptoKey).write(to: itemUrl, options: .atomic)
                }
                promise(result)
                
                didChange.send()
            }
        }
    }
    
    public func deleteVaultItem(id: UUID) -> Future<Void, Error> {
        return Future { [didChange, directoryUrl, fileOperationQueue] promise in
            fileOperationQueue.async {
                let result = Result {
                    let itemUrl = directoryUrl.appendingPathComponent(id.uuidString, isDirectory: false)
                    try FileManager.default.removeItem(at: itemUrl)
                }
                promise(result)
                
                didChange.send()
            }
        }
    }
    
}

extension VaultItemStore {
    
    public struct ItemInfo {
        
        public var id: UUID { itemInfo.id }
        public var title: String { itemInfo.title }
        
        private let itemInfo: VaultItem.Info
        private let cryptor: VaultItemCryptor<Cryptor>
        
        init(cryptoKey: Cryptor.Key, from reader: FileReader) throws {
            let cryptor = try VaultItemCryptor<Cryptor>(using: cryptoKey, from: reader)
            let itemInfo = try cryptor.decryptedItemInfo(using: cryptoKey, from: reader)
            
            self.itemInfo = itemInfo
            self.cryptor = cryptor
        }
        
        func decryptedVaultItem(using key: Cryptor.Key, from reader: FileReader) throws -> VaultItem {
            return try cryptor.decryptedVaultItem(for: itemInfo, using: key, from: reader)
        }
        
    }
    
}
