
import AppKit

extension NSMenu {

    func addSubmenu(menu: NSMenu) {
        let menuItem = NSMenuItem()
        menuItem.submenu = menu
        addItem(menuItem)
    }
    
    func addSeparator() {
        let item = NSMenuItem.separator()
        addItem(item)
    }
    
}
