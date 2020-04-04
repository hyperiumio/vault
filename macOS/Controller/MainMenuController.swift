import AppKit

class MainMenuController {
    
    let mainMenu: NSMenu
    
    init() {
        let aboutItem = NSMenuItem()
        aboutItem.title = .aboutApp
        aboutItem.action = #selector(NSApplication.orderFrontStandardAboutPanel(_:))
        
        let preferencesItem = NSMenuItem()
        preferencesItem.title = .preferences
        preferencesItem.action = #selector(ApplicationController.showPreferences)
        preferencesItem.keyEquivalent = ","
        preferencesItem.keyEquivalentModifierMask = [.command]
        
        let hideItem = NSMenuItem()
        hideItem.title = .hideApp
        hideItem.action = #selector(NSApplication.hide)
        hideItem.keyEquivalent = "h"
        
        let hideOthersItem = NSMenuItem()
        hideOthersItem.title = .hideOthers
        hideOthersItem.action = #selector(NSApplication.hideOtherApplications)
        hideOthersItem.keyEquivalent = "h"
        hideOthersItem.keyEquivalentModifierMask = [.option, .command]
        
        let showAllItem = NSMenuItem()
        showAllItem.title = .showAll
        showAllItem.action = #selector(NSApplication.unhideAllApplications)
        
        let lockItem = NSMenuItem()
        lockItem.title = .lock
        lockItem.action = #selector(ApplicationController.lock)
        
        let quitItem = NSMenuItem()
        quitItem.title = .quitApp
        quitItem.action = #selector(NSApplication.terminate)
        quitItem.keyEquivalent = "q"
        
        let appMenu = NSMenu()
        appMenu.addItem(aboutItem)
        appMenu.addSeparator()
        appMenu.addItem(preferencesItem)
        appMenu.addSeparator()
        appMenu.addItem(hideItem)
        appMenu.addItem(hideOthersItem)
        appMenu.addItem(showAllItem)
        appMenu.addSeparator()
        appMenu.addItem(lockItem)
        appMenu.addSeparator()
        appMenu.addItem(quitItem)
        
        let mainMenu = NSMenu()
        mainMenu.addSubmenu(menu: appMenu)
        
        self.mainMenu = mainMenu
    }
    
}

