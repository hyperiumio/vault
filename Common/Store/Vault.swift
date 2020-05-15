import Combine
import Crypto
import Foundation

class Vault {
    
    let didChange = PassthroughSubject<Void, Never>()
    
    private let directoryUrl: URL
    private let masterKey: MasterKey
    private let fileOperationQueue = DispatchQueue(label: "VaultFileOperationQueue")
    
    init(url: URL, masterKey: MasterKey) {
        self.directoryUrl = url
        self.masterKey = masterKey
    }
    
    func loadVaultItemInfoCollection() -> Future<[VaultItem.Info], Error> {
        return Future { [directoryUrl, masterKey, fileOperationQueue] promise in
            fileOperationQueue.async {
                let result = LoadVaultItemInfoCollectionOperation(directoryUrl: directoryUrl, masterKey: masterKey)
                promise(result)
            }
        }
    }
    
    func loadVaultItem(itemId: UUID) -> Future<VaultItem, Error> {
        return Future { [directoryUrl, masterKey, fileOperationQueue] promise in
            fileOperationQueue.async {
                let itemUrl = VaultItemLocation(directoryUrl: directoryUrl, itemId: itemId)
                let result = LoadVaultItemOperation(itemUrl: itemUrl, masterKey: masterKey)
                promise(result)
            }
        }
    }
    
    func saveVaultItem(_ vaultItem: VaultItem) -> Future<Void, Error> {
        return Future { [didChange, directoryUrl, masterKey, fileOperationQueue] promise in
            fileOperationQueue.async {
                let itemUrl = VaultItemLocation(directoryUrl: directoryUrl, itemId: vaultItem.id)
                let result = SaveVaultItemOperation(vaultItem: vaultItem, itemUrl: itemUrl, masterKey: masterKey)
                promise(result)
                
                didChange.send()
            }
        }
    }
    
    func deleteVaultItem(itemId: UUID) -> Future<Void, Error> {
        return Future { [didChange, directoryUrl, fileOperationQueue] promise in
            fileOperationQueue.async {
                let itemUrl = VaultItemLocation(directoryUrl: directoryUrl, itemId: itemId)
                let result = DeleteVaultItemOperation(itemUrl: itemUrl)
                promise(result)
                
                didChange.send()
            }
        }
    }
    
}

extension Vault {
    
    static func createMasterKey(masterKeyUrl: URL, password: String) -> Future<MasterKey, Error> {
        return Future { promise in
            DispatchQueue.global().async {
                let result = CreateMasterKey(masterKeyUrl: masterKeyUrl, password: password)
                promise(result)
            }
        }
    }
    
    static func loadMasterKey(masterKeyUrl: URL, password: String) -> Future<MasterKey, Error> {
        return Future { promise in
            DispatchQueue.global().async {
                let result = LoadMasterKey(masterKeyUrl: masterKeyUrl, password: password)
                promise(result)
            }
        }
    }
    
    static func loadMasterKeyUsingBiometrics(masterKeyUrl: URL) -> Future<MasterKey, Error> {
        return Future { promise in
            DispatchQueue.global().async {
                let result = LoadMasterKey(masterKeyUrl: masterKeyUrl)
                promise(result)
            }
        }
    }
    
}
