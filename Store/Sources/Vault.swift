import Combine
import Foundation

private let operationQueue = DispatchQueue(label: "VaultOperationQueue")

public class Vault<Key, Header, Message> where Key: KeyRepresentable, Header: HeaderRepresentable, Message: MessageRepresentable, Key == Header.Key, Key == Message.Key {
    
    public let id: UUID
    
    private let masterKey: Key
    private let resourceLocator: VaultResourceLocator
    private let indexSubject: CurrentValueSubject<VaultIndex, Error>
    
    init(id: UUID, masterKey: Key, resourceLocator: VaultResourceLocator, initialIndex: VaultIndex) {
        self.id = id
        self.masterKey = masterKey
        self.resourceLocator = resourceLocator
        self.indexSubject = CurrentValueSubject(initialIndex)
    }
    
    public var vaultItemInfos: [VaultItem.Info] { indexSubject.value.infos }
    
    public var vaultItemInfosDidChange: AnyPublisher<[VaultItem.Info], Error> {
        indexSubject
            .map(\.infos)
            .eraseToAnyPublisher()
    }
    
    public func save(_ vaultItem: VaultItem) -> AnyPublisher<Void, Error> {
        operationQueue.future { [resourceLocator, indexSubject, masterKey] in
            let newItemURL = resourceLocator.itemFile()
            let encodedVaultItemInfo = try vaultItem.info.encoded()
            let encodedPrimarySecureItem = try vaultItem.primarySecureItem.encoded()
            let encodedSecondarySecureItems = try vaultItem.secondarySecureItems.map { secureItem in
                try secureItem.encoded()
            }
            let messages = [encodedVaultItemInfo, encodedPrimarySecureItem] + encodedSecondarySecureItems
            let secureDataContainer = try Message.encryptContainer(from: messages, using: masterKey)
            let header = try Header(data: secureDataContainer)
            let indexElement = VaultIndex.Element(url: newItemURL, header: header, info: vaultItem.info)
            
            try secureDataContainer.write(to: newItemURL)
            
            if let oldItemURL = try? indexSubject.value.element(for: vaultItem.id).url {
                try FileManager.default.removeItem(at: oldItemURL)
            }
            
            indexSubject.value = indexSubject.value.add(indexElement)
            
            for url in try! FileManager.default.urls(in: self.resourceLocator.itemsDirectory) {
                print(url)
            }
            
            print("***")
        }
        .eraseToAnyPublisher()
    }
    
    public func loadVaultItem(with itemID: UUID) -> AnyPublisher<VaultItem, Error> {
        operationQueue.future { [indexSubject, masterKey] in
            let element = try indexSubject.value.element(for: itemID)
            let itemKey = try element.header.unwrapKey(with: masterKey)
            let primaryNonceRange = element.header.nonceRanges[.primarySecureItemIndex]
            let primaryCiphertextRange = element.header.ciphertextRange[.primarySecureItemIndex]
            let data = try Data(contentsOf: element.url)
            
            let primaryNonce = data[primaryNonceRange]
            let primaryCiphertext = data[primaryCiphertextRange]
            let primaryTag = element.header.tags[.primarySecureItemIndex]
            let primaryItemData = try Message(nonce: primaryNonce, ciphertext: primaryCiphertext, tag: primaryTag).decrypt(using: itemKey)
            let primaryItem = try SecureItem(from: primaryItemData, asTypeMatching: element.info.primaryTypeIdentifier)
            
            return VaultItem(id: element.info.id, name: element.info.name, primarySecureItem: primaryItem, secondarySecureItems: [], created: element.info.created, modified: element.info.modified)
        }
        .eraseToAnyPublisher()
    }
    
    public func deleteVaultItem(with itemID: UUID) -> AnyPublisher<Void, Error> {
        operationQueue.future { [indexSubject] in
            let itemURL = try indexSubject.value.element(for: itemID).url
            try FileManager.default.removeItem(at: itemURL)
            
            indexSubject.value = indexSubject.value.delete(itemID)
            
            for url in try! FileManager.default.urls(in: self.resourceLocator.itemsDirectory) {
                print(url)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func validatePassword(_ password: String) -> AnyPublisher<Bool, Error> {
        operationQueue.future { [resourceLocator, masterKey] in
            let keyContainer = try Data(contentsOf: resourceLocator.keyFile)
            let loadedKey = try Key(from: keyContainer, using: password)
            return masterKey == loadedKey
        }
        .eraseToAnyPublisher()
    }
    
}

extension Vault {
    
    typealias VaultIndex = Store.VaultIndex<Header>
    public typealias LockedVault = Store.LockedVault<Key, Header, Message>
    
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
    
    public static func create(in vaultContainerDirectory: URL, keyContainer: Data) -> AnyPublisher<URL, Error> {
        operationQueue.future {
            let vaultID = UUID().uuidString
            let vaultDirectory = vaultContainerDirectory.appendingPathComponent(vaultID, isDirectory: true)
            let resourceLocator = VaultResourceLocator(vaultDirectory)
            
            try FileManager.default.createDirectory(at: resourceLocator.rootDirectory, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: resourceLocator.itemsDirectory, withIntermediateDirectories: false)
            try VaultInfo().encoded().write(to: resourceLocator.infoFile)
            try keyContainer.write(to: resourceLocator.keyFile)
            
            return vaultDirectory
        }
        .eraseToAnyPublisher()
    }
    
    public static func load(from vaultDirectory: URL) -> AnyPublisher<LockedVault, Error> {
        operationQueue.future {
            let resourceLocator = VaultResourceLocator(vaultDirectory)
            let infoData = try Data(contentsOf: resourceLocator.infoFile)
            let info = try VaultInfo(from: infoData)
            let keyContainer = try Data(contentsOf: resourceLocator.keyFile)
            
            let elements = try FileManager.default.urls(in: resourceLocator.itemsDirectory).map { itemURL in
                try FileReader.read(url: itemURL) { fileReader in
                    let header = try Header(from: fileReader.bytes)
                    let nonceDataRange = header.nonceRanges[.infoIndex]
                    let ciphertextRange = header.ciphertextRange[.infoIndex]
                    let nonce = try fileReader.bytes(in: nonceDataRange)
                    let ciphertext = try fileReader.bytes(in: ciphertextRange)
                    let tag = header.tags[.infoIndex]
                    let message = Message(nonce: nonce, ciphertext: ciphertext, tag: tag)
                    return LockedVault.Element(url: itemURL, header: header, message: message)
                }
            } as [LockedVault.Element]
            
            return LockedVault(vaultID: info.id, resourceLocator: resourceLocator, keyContainer: keyContainer, elements: elements)
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
