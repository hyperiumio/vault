import Combine
import Foundation

public class VaultItemStore<Cryptor> where Cryptor: MultiMessageCryptor {
    
    public let didChange = PassthroughSubject<Void, Never>()
    
    private let directoryUrl: URL
    private let masterKey: Cryptor.Key
    private let fileOperationQueue = DispatchQueue(label: "VaultFileOperationQueue")
    
    public init(url: URL, masterKey: Cryptor.Key) {
        self.directoryUrl = url
        self.masterKey = masterKey
    }
    
    public func loadItemInfos() -> Future<[ItemInfo], Error> {
        return Future { [directoryUrl, masterKey, fileOperationQueue] promise in
            fileOperationQueue.async {
                let result = Result<[ItemInfo], Error> {
                    guard FileManager.default.fileExists(atPath: directoryUrl.path) else {
                        return []
                    }
                    
                    return try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles).map { url in
                        return try FileReader.read(url: url) { fileReader in
                            return try ItemInfo(key: masterKey, from: fileReader)
                        }
                    }
                }
                promise(result)
            }
        }
    }
    
    public func loadVaultItem(for itemInfo: ItemInfo) -> Future<VaultItem, Error> {
        return Future { [directoryUrl, masterKey, fileOperationQueue] promise in
            fileOperationQueue.async {
                let result = Result<VaultItem, Error> {
                    let itemUrl = directoryUrl.appendingPathComponent(itemInfo.id.uuidString, isDirectory: false)
                    return try FileReader.read(url: itemUrl) { fileReader in
                        return try itemInfo.decryptedVaultItem(using: masterKey, from: fileReader)
                    }
                }
                promise(result)
            }
        }
    }
    
    public func saveVaultItem(_ vaultItem: VaultItem) -> Future<Void, Error> {
        return Future { [didChange, directoryUrl, masterKey, fileOperationQueue] promise in
            fileOperationQueue.async {
                let result = Result {
                    let itemUrl = directoryUrl.appendingPathComponent(vaultItem.id.uuidString, isDirectory: false)
                    let itemDirectory = itemUrl.deletingLastPathComponent()
                    try FileManager.default.createDirectory(at: itemDirectory, withIntermediateDirectories: true)
                    try VaultItemCryptor<Cryptor>.encrypted(vaultItem, using: masterKey).write(to: itemUrl, options: .atomic)
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
        
        init(key: Cryptor.Key, from reader: FileReader) throws {
            let cryptor = try VaultItemCryptor<Cryptor>(using: key, from: reader)
            let itemInfo = try cryptor.decryptedItemInfo(using: key, from: reader)
            
            self.itemInfo = itemInfo
            self.cryptor = cryptor
        }
        
        func decryptedVaultItem(using key: Cryptor.Key, from reader: FileReader) throws -> VaultItem {
            return try cryptor.decryptedVaultItem(for: itemInfo, using: key, from: reader)
        }
        
    }
    
}
