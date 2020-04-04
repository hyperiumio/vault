import AppKit

let applicationController = ApplicationController()
let mainMenuController = MainMenuController()
NSApplication.shared.delegate = applicationController
NSApplication.shared.mainMenu = mainMenuController.mainMenu
NSApplication.shared.run()
