import Combine
import Foundation
import Preferences

struct LaunchState {
    
    let vaultExists: Bool
    let preferencesManager: PreferencesManager
    
}

extension LaunchState {
    
    static func publisher(masterKeyUrl: URL) -> AnyPublisher<LaunchState, Never> {
        let fileExistsPublisher = Future<Bool, Never> { promise in
            DispatchQueue.global().async {
                let fileExists = FileManager.default.fileExists(atPath: masterKeyUrl.path)
                let result = Result.success(value: fileExists)
                promise(result)
            }
        }
        
        let preferencesManagerPublisher = Future<PreferencesManager, Never> { promise in
            DispatchQueue.global().async {
                let preferencesManager = PreferencesManager(userDefaults: .standard)
                let result = Result.success(value: preferencesManager)
                promise(result)
            }
        }
        
        return Publishers.Zip(fileExistsPublisher, preferencesManagerPublisher)
            .map { fileExists, preferencesManager in
                return LaunchState(vaultExists: fileExists, preferencesManager: preferencesManager)
            }
            .eraseToAnyPublisher()
    }
    
}
