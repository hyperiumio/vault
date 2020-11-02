import Combine
import Foundation

// is currently not thread save

// items should reload after configuration change

private let operationQueue = DispatchQueue(label: "VaultOperationQueue")

public class Vault<Key, Header, Message> where Key: KeyRepresentable, Header: HeaderRepresentable, Message: MessageRepresentable, Key == Header.Key, Key == Message.Key {
    
    public var id: UUID { configuration.id }
    public var directory: URL { configuration.resourceLocator.rootDirectory }
    
    private var configuration: Configuration
    private let indexSubject: CurrentValueSubject<VaultIndex, Error>
    
    init(id: UUID, masterKey: Key, resourceLocator: VaultResourceLocator, initialElements: [Vault.Element]) {
        let configuration = Configuration(id: id, masterKey: masterKey, resourceLocator: resourceLocator)
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
            let newItemURL = configuration.resourceLocator.itemFile()
            let secondaryTypes = vaultItem.secondarySecureItems.map(\.value.type)
            let info = VaultItemInfo(id: vaultItem.id, name: vaultItem.name, description: vaultItem.description, primaryType: vaultItem.primarySecureItem.value.type, secondaryTypes: secondaryTypes, created: vaultItem.created, modified: vaultItem.modified)
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
    
    public func validatePassword(_ password: String) -> AnyPublisher<Bool, Error> {
        operationQueue.future { [configuration] in
            let keyContainer = try Data(contentsOf: configuration.resourceLocator.keyFile)
            let loadedKey = try Key(from: keyContainer, using: password)
            return configuration.masterKey == loadedKey
        }
        .eraseToAnyPublisher()
    }
    
    public func changeMasterPassword(from currentPassword: String, to newPassword: String) -> AnyPublisher<UUID, Error> {
        operationQueue.future { [self, configuration] in
            let keyContainer = try Data(contentsOf: configuration.resourceLocator.keyFile)
            let loadedKey = try Key(from: keyContainer, using: currentPassword)
            guard configuration.masterKey == loadedKey else {
                throw StoreError.invalidPassword
            }
            
            let vaultName = UUID().uuidString
            let vaultDirectory = configuration.resourceLocator.container.appendingPathComponent(vaultName, isDirectory: true)
            let resourceLocator = VaultResourceLocator(vaultDirectory)
            let vaultInfo = VaultInfo()
            let masterKey = Key()
            try FileManager.default.createDirectory(at: resourceLocator.rootDirectory, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: resourceLocator.itemsDirectory, withIntermediateDirectories: false)
            try vaultInfo.encoded().write(to: resourceLocator.infoFile)
            try masterKey.encryptedContainer(using: newPassword).write(to: resourceLocator.keyFile)
            
            for itemURL in try FileManager.default.urls(in: configuration.resourceLocator.itemsDirectory) {
                let itemData = try Data(contentsOf: itemURL)
                let messages = try Message.decryptMessages(from: itemData, using: configuration.masterKey)
                let newItemURL = resourceLocator.itemFile()
                try Message.encryptContainer(from: messages, using: masterKey).write(to: newItemURL)
            }
            
            
            
            self.configuration = Configuration(id: vaultInfo.id, masterKey: masterKey, resourceLocator: resourceLocator)
            
            try FileManager.default.removeItem(at: configuration.resourceLocator.rootDirectory)
            
            return vaultInfo.id
        }
        .eraseToAnyPublisher()
    }
    
}

extension Vault {
    
    typealias VaultIndex = [UUID: Element]
    
    public typealias VaultContainer = Store.VaultContainer<Key, Header, Message>
    
    struct Element {
        
        let url: URL
        let header: Header
        let info: VaultItemInfo
        
    }
    
    struct Configuration {
        
        let id: UUID
        let masterKey: Key
        let resourceLocator: VaultResourceLocator
        
    }
    
}

extension Vault {
    
    public static func directory(in vaultContainerDirectory: URL, with vaultID: UUID) -> AnyPublisher<URL?, Error> {
        operationQueue.future {
            for vaultDirectory in try FileManager.default.urls(in: vaultContainerDirectory) {
                let resourceLocator = VaultResourceLocator(vaultDirectory)
                let infoData = try Data(contentsOf: resourceLocator.infoFile)
                let info = try VaultInfo(from: infoData)
                
                if info.id == vaultID {
                    return vaultDirectory
                }
            }
            
            return nil
        }
        .eraseToAnyPublisher()
    }
    
    public static func create(in vaultContainerDirectory: URL, using password: String) -> AnyPublisher<URL, Error> {
        operationQueue.future {
            let vaultID = UUID().uuidString
            let vaultDirectory = vaultContainerDirectory.appendingPathComponent(vaultID, isDirectory: true)
            let resourceLocator = VaultResourceLocator(vaultDirectory)
            
            try FileManager.default.createDirectory(at: resourceLocator.rootDirectory, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: resourceLocator.itemsDirectory, withIntermediateDirectories: false)
            try VaultInfo().encoded().write(to: resourceLocator.infoFile)
            try Key().encryptedContainer(using: password).write(to: resourceLocator.keyFile)
            
            return vaultDirectory
        }
        .eraseToAnyPublisher()
    }
    
    public static func load(from vaultDirectory: URL) -> AnyPublisher<VaultContainer, Error> {
        operationQueue.future {
            let resourceLocator = VaultResourceLocator(vaultDirectory)
            let infoData = try Data(contentsOf: resourceLocator.infoFile)
            let info = try VaultInfo(from: infoData)
            let keyContainer = try Data(contentsOf: resourceLocator.keyFile)
            
            let elements = try FileManager.default.urls(in: resourceLocator.itemsDirectory).map { itemURL in
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
            
            return VaultContainer(vaultID: info.id, resourceLocator: resourceLocator, keyContainer: keyContainer, elements: elements)
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
