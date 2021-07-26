actor SecureItemService: SecureItemDependency {
    
    nonisolated func passwordDependency() -> PasswordItemDependency {
        PasswordService()
    }
    
    nonisolated func loginDependency() -> LoginItemDependency {
        PasswordService()
    }
    
    nonisolated func wifiDependency() -> WifiItemDependency {
        PasswordService()
    }
    
}

#if DEBUG
#endif
