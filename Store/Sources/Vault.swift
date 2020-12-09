import Combine
import Foundation

// TODO: is currently not thread save
// TODO: items should reload after configuration change

private let operationQueue = DispatchQueue(label: "VaultOperationQueue")

public class Vault<CryptoKey, Header, Message> where CryptoKey: CryptoKeyRepresentable, Header: HeaderRepresentable, Message: MessageRepresentable, Header.CryptoKey == CryptoKey, Message.CryptoKey == CryptoKey {
    
    public var id: UUID { configuration.id }
    public var directory: URL { configuration.resourceLocator.rootDirectory }
    public var derivedKey: CryptoKey { configuration.derivedKey }
    
    private var configuration: Configuration
    private let indexSubject: CurrentValueSubject<VaultIndex, Error>
    
    init(id: UUID, derivedKey: CryptoKey, masterKey: CryptoKey, resourceLocator: VaultResourceLocator, initialElements: [Vault.Element]) {
        let configuration = Configuration(id: id, derivedKey: derivedKey, masterKey: masterKey, resourceLocator: resourceLocator)
        let ids = initialElements.map(\.info.id)
        let keysWithValues = zip(ids, initialElements)
        let index = Dictionary(uniqueKeysWithValues: keysWithValues)
        
        self.configuration = configuration
        self.indexSubject = CurrentValueSubject(index)
    }
    
    public var vaultItemInfos: [VaultItemInfo] {
        indexSubject.value.values.map(\.info)
    }
    
    public var vaultItemInfosDidChange: AnyPublisher<[VaultItemInfo], Error> {
        indexSubject
            .map { index in
                index.values.map(\.info)
            }
            .eraseToAnyPublisher()
    }
    
    public func save(_ vaultItem: VaultItem) -> AnyPublisher<Void, Error> {
        operationQueue.future { [configuration, indexSubject] in
            let newItemURL = configuration.resourceLocator.item()
            let secondaryTypes = vaultItem.secondarySecureItems.map(\.value.secureItemType)
            let info = VaultItemInfo(id: vaultItem.id, name: vaultItem.name, description: vaultItem.description, primaryType: vaultItem.primarySecureItem.value.secureItemType, secondaryTypes: secondaryTypes, created: vaultItem.created, modified: vaultItem.modified)
            let encodedInfo = try info.encoded()
            let encodedPrimarySecureItem = try vaultItem.primarySecureItem.value.encoded()
            let encodedSecondarySecureItems = try vaultItem.secondarySecureItems.map { secureItem in
                try secureItem.value.encoded()
            }
            let messages = [encodedInfo, encodedPrimarySecureItem] + encodedSecondarySecureItems
            let secureDataContainer = try Message.encryptContainer(from: messages, using: configuration.masterKey)
            let header = try Header(data: secureDataContainer)
            let indexElement = Vault.Element(url: newItemURL, header: header, info: info)
            
            try secureDataContainer.write(to: newItemURL)
            
            if let oldItemURL = indexSubject.value[vaultItem.id]?.url {
                try FileManager.default.removeItem(at: oldItemURL)
            }
            
            indexSubject.value[indexElement.info.id] = indexElement
        }
        .eraseToAnyPublisher()
    }
    
    public func loadVaultItem(with itemID: UUID) -> AnyPublisher<VaultItem, Error> {
        operationQueue.future { [configuration, indexSubject] in
            guard let element = indexSubject.value[itemID] else {
                throw NSError()
            }
            let itemKey = try element.header.unwrapKey(with: configuration.masterKey)
            let primaryNonceRange = element.header.elements[.primarySecureItemIndex].nonceRange
            let primaryCiphertextRange = element.header.elements[.primarySecureItemIndex].ciphertextRange
            let data = try Data(contentsOf: element.url)
            
            let primaryNonce = data[primaryNonceRange]
            let primaryCiphertext = data[primaryCiphertextRange]
            let primaryTag = element.header.elements[.primarySecureItemIndex].tag
            let primaryItemData = try Message(nonce: primaryNonce, ciphertext: primaryCiphertext, tag: primaryTag).decrypt(using: itemKey)
            let primaryItem = try SecureItem(from: primaryItemData, as: element.info.primaryType)
            
            return VaultItem(id: element.info.id, name: element.info.name, primarySecureItem: primaryItem, secondarySecureItems: [], created: element.info.created, modified: element.info.modified)
        }
        .eraseToAnyPublisher()
    }
    
    public func deleteVaultItem(with itemID: UUID) -> AnyPublisher<Void, Error> {
        operationQueue.future { [indexSubject] in
            guard let itemURL = indexSubject.value[itemID]?.url else {
                throw NSError()
            }
            try FileManager.default.removeItem(at: itemURL)
            
            indexSubject.value[itemID] = nil
        }
        .eraseToAnyPublisher()
    }
    
    public func changeMasterPassword(to newPassword: String) -> AnyPublisher<UUID, Error> {
        operationQueue.future { [self, configuration] in
            let vaultName = UUID().uuidString
            let vaultDirectory = configuration.resourceLocator.container.appendingPathComponent(vaultName, isDirectory: true)
            let resourceLocator = VaultResourceLocator(vaultDirectory)
            let vaultInfo = VaultInfo()
            let (derivedKeyContainer, derivedKey) = try CryptoKey.derive(from: newPassword)
            let masterKey = CryptoKey()
            let masterKeyContainer = try masterKey.encryptedKeyContainer(using: derivedKey)
            let keyContainer = derivedKeyContainer + masterKeyContainer
            
            try FileManager.default.createDirectory(at: resourceLocator.rootDirectory, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: resourceLocator.items, withIntermediateDirectories: false)
            try vaultInfo.encoded().write(to: resourceLocator.info)
            try keyContainer.write(to: resourceLocator.key)
            
            for itemURL in try FileManager.default.urls(in: configuration.resourceLocator.items) {
                let itemData = try Data(contentsOf: itemURL)
                let messages = try Message.decryptMessages(from: itemData, using: configuration.masterKey)
                let newItemURL = resourceLocator.item()
                try Message.encryptContainer(from: messages, using: masterKey).write(to: newItemURL)
            }
            
            self.configuration = Configuration(id: vaultInfo.id, derivedKey: derivedKey, masterKey: masterKey, resourceLocator: resourceLocator)
            
            try FileManager.default.removeItem(at: configuration.resourceLocator.rootDirectory)
            
            return vaultInfo.id
        }
        .eraseToAnyPublisher()
    }
    
}

extension Vault {
    
    typealias VaultIndex = [UUID: Element]
    
    public typealias VaultContainer = Store.VaultContainer<CryptoKey, Header, Message>
    
    struct Element {
        
        let url: URL
        let header: Header
        let info: VaultItemInfo
        
    }
    
    struct Configuration {
        
        let id: UUID
        let derivedKey: CryptoKey
        let masterKey: CryptoKey
        let resourceLocator: VaultResourceLocator
        
    }
    
}

extension Vault {
    
    public static func vaultExists(with vaultID: UUID, in vaultContainerDirectory: URL) -> AnyPublisher<Bool, Error> {
        operationQueue.future {
            for vaultDirectory in try FileManager.default.urls(in: vaultContainerDirectory) {
                let resourceLocator = VaultResourceLocator(vaultDirectory)
                let infoData = try Data(contentsOf: resourceLocator.info)
                let info = try VaultInfo(from: infoData)
                
                if info.id == vaultID {
                    return true
                }
            }
            
            return false
        }
        .eraseToAnyPublisher()
    }
    
    public static func create(in vaultContainerDirectory: URL, using password: String) -> AnyPublisher<Vault, Error> {
        operationQueue.future {
            let vaultDirectoryID = UUID()
            let vaultDirectory = vaultContainerDirectory.appendingPathComponent(vaultDirectoryID.uuidString, isDirectory: true)
            let resourceLocator = VaultResourceLocator(vaultDirectory)
            let vaultInfo = VaultInfo()
            let (derivedKeyContainer, derivedKey) = try CryptoKey.derive(from: password)
            let masterKey = CryptoKey()
            let masterKeyContainer = try masterKey.encryptedKeyContainer(using: derivedKey)
            let keyContainer = derivedKeyContainer + masterKeyContainer
            
            try FileManager.default.createDirectory(at: resourceLocator.rootDirectory, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: resourceLocator.items, withIntermediateDirectories: false)
            try vaultInfo.encoded().write(to: resourceLocator.info)
            try keyContainer.write(to: resourceLocator.key)
            
            return Vault(id: vaultInfo.id, derivedKey: derivedKey, masterKey: masterKey, resourceLocator: resourceLocator, initialElements: [])
        }
        .eraseToAnyPublisher()
    }
    
    public static func load(vaultID: UUID, in vaultContainerDirectory: URL) -> AnyPublisher<VaultContainer, Error> {
        operationQueue.future {
            for vaultDirectory in try FileManager.default.urls(in: vaultContainerDirectory) {
                let resourceLocator = VaultResourceLocator(vaultDirectory)
                let infoData = try Data(contentsOf: resourceLocator.info)
                let info = try VaultInfo(from: infoData)
                
                if info.id == vaultID {
                    let resourceLocator = VaultResourceLocator(vaultDirectory)
                    let infoData = try Data(contentsOf: resourceLocator.info)
                    let info = try VaultInfo(from: infoData)
                    
                    let keyContainer = try Data(contentsOf: resourceLocator.key)
                    guard keyContainer.count == CryptoKey.derivedKeyContainerSize + CryptoKey.encryptedKeyContainerSize else {
                        throw NSError()
                    }
                    let derivedKeyContainer = keyContainer[keyContainer.startIndex ..< keyContainer.startIndex + CryptoKey.derivedKeyContainerSize]
                    let masterKeyContainer = keyContainer[keyContainer.startIndex + CryptoKey.derivedKeyContainerSize ..< keyContainer.startIndex + CryptoKey.derivedKeyContainerSize +  CryptoKey.encryptedKeyContainerSize]
                    
                    let elements = try FileManager.default.urls(in: resourceLocator.items).map { itemURL in
                        let fileHandle = try FileHandle(forReadingFrom: itemURL)
                        return try FileReader.read(from: fileHandle) { fileReader in
                            let header = try Header(from: fileReader.bytes)
                            let nonceDataRange = header.elements[.infoIndex].nonceRange
                            let ciphertextRange = header.elements[.infoIndex].ciphertextRange
                            let nonce = try fileReader.bytes(in: nonceDataRange)
                            let ciphertext = try fileReader.bytes(in: ciphertextRange)
                            let tag = header.elements[.infoIndex].tag
                            let message = Message(nonce: nonce, ciphertext: ciphertext, tag: tag)
                            return VaultContainer.Element(url: itemURL, header: header, message: message)
                        }
                    } as [VaultContainer.Element]
                    
                    return VaultContainer(vaultID: info.id, resourceLocator: resourceLocator, derivedKeyContainer: derivedKeyContainer, masterKeyContainer: masterKeyContainer, elements: elements)
                }
            }
            
            throw NSError()
        }
        .eraseToAnyPublisher()
    }
    
}

private extension Int {
    
    static let versionIndex = 0
    static let infoIndex = 0
    static let primarySecureItemIndex = 1
    static let secondarySecureItemIndex = 2
    
}

private extension FileManager {
    
    func urls(in directory: URL) throws -> [URL] {
        guard fileExists(atPath: directory.path) else {
            return []
        }
        
        return try contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    }
    
}

extension FileHandle: FileHandleRepresentable {}
