import Crypto
import Combine
import Foundation
import Store

class Vault {
    
    let id: UUID
    
    private let store: VaultItemStore
    private let masterKey: CryptoKey
    private let indexSubject: CurrentValueSubject<Index, Error>
    
    init(id: UUID, store: VaultItemStore, masterKey: CryptoKey, initialIndex: Index) {
        self.id = id
        self.store = store
//        self.info = info
//        self.resourceLocator = resourceLocator
        self.masterKey = masterKey
        self.indexSubject = CurrentValueSubject(initialIndex)
    }
    
    var vaultItemInfos: [VaultItem.Info] { indexSubject.value.infos }
    
    var vaultItemInfosDidChange: AnyPublisher<[VaultItem.Info], Error> {
        indexSubject
            .map(\.infos)
            .eraseToAnyPublisher()
    }
    
    func save(_ vaultItem: VaultItem) -> AnyPublisher<Void, Error> {
        Self.operationQueue.future { [masterKey] in
            let encodedVaultItemInfo = try vaultItem.info.jsonEncoded()
            let encodedPrimarySecureItem = try SecureItem.encoded(vaultItem.primarySecureItem)
            let encodedSecondarySecureItems = try vaultItem.secondarySecureItems.map { secureItem in
                try SecureItem.encoded(secureItem)
            }
            let messages = [encodedVaultItemInfo, encodedPrimarySecureItem] + encodedSecondarySecureItems
            
            return try SecureDataMessage.encryptContainer(from: messages, using: masterKey)
        }
        .flatMap { [store] data in
            store.saveVaultItem(data, for: vaultItem.id)
        }
        .eraseToAnyPublisher()
    }
    
    func loadVaultItem(with itemID: UUID) -> AnyPublisher<VaultItem, Error> {
        store.loadVaultItemData(with: itemID)
            .receive(on: Self.operationQueue)
            .tryMap { [indexSubject, masterKey] data in
                let header = try indexSubject.value.header(for: itemID)
                let info = try indexSubject.value.info(for: itemID)
                let itemKey = try header.unwrapKey(with: masterKey)
                let primaryNonceRange = header.nonceRanges[.primarySecureItemIndex]
                let primaryCiphertextRange = header.ciphertextRange[.primarySecureItemIndex]
                
                let primaryNonce = data[primaryNonceRange]
                let primaryCiphertext = data[primaryCiphertextRange]
                let primaryTag = header.tags[.primarySecureItemIndex]
                let primaryItemData = try SecureDataMessage(nonce: primaryNonce, ciphertext: primaryCiphertext, tag: primaryTag).decrypt(using: itemKey)
                let primaryItem = try SecureItem.decoded(primaryItemData, asTypeMatching: info.primaryTypeIdentifier)
                
                return VaultItem(id: info.id, name: info.name, primarySecureItem: primaryItem, secondarySecureItems: [], created: info.created, modified: info.modified)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteVaultItem(with itemID: UUID) -> AnyPublisher<Void, Error> {
        store.deleteVaultItem(with: itemID)
    }
    
}

extension Vault {
    
    private static let operationQueue = DispatchQueue(label: "VaultOperationQueue")
    
}

extension Vault {
    
    struct Index {
        
        private let values: [UUID: Element]
        
        init() {
            values = [:]
        }
        
        init(_ elements: [Element]) {
            var values = [UUID: Element]()
            
            for element in elements {
                values[element.info.id] = element
            }
            
            self.values = values
        }
        
        func header(for id: UUID) throws -> SecureDataHeader {
            guard let value = values[id] else {
                throw NSError()
            }
            
            return value.header
        }
        
        func info(for id: UUID) throws -> VaultItem.Info {
            guard let value = values[id] else {
                throw NSError()
            }
            
            return value.info
        }
        
        var infos: [VaultItem.Info] {
            values.values.map(\.info)
        }
        
    }
    
}

extension Vault.Index {
    
    struct Element {
        
        let header: SecureDataHeader
        let info: VaultItem.Info
        
    }
    
}

private extension Int {
    
    static let versionIndex = 0
    static let infoIndex = 0
    static let primarySecureItemIndex = 1
    static let secondarySecureItemIndex = 2
    
}
