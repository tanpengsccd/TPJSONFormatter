//
//  StatusBarController.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2019/6/25.
//  Copyright © 2019 谭鹏. All rights reserved.
//

import Cocoa

class StatusBarController: NSObject {
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength) //声明后就会存在
    override init() {
        super.init()
        statusBarItem.title = "{TP}"
        statusBarItem.menu = self.mainMenu
        statusBarItem.doubleAction = #selector(onMain)
        statusBarItem.target = self
    }
    
    var mainMenu:NSMenu {
        let quitItem = NSMenuItem.init(title: "Quit TPJSONFormatter", action: #selector(self.onQuit), keyEquivalent: "q");quitItem.keyEquivalentModifierMask = NSEvent.ModifierFlags.command
        let mainItem = NSMenuItem.init(title: "Main", action: #selector(self.onMain), keyEquivalent: "");
        
        let menu = NSMenu.init()
        menu.items = [mainItem,quitItem]
        menu.items.forEach{$0.target = self}
        return menu
    }
    
    @objc func onQuit(){
        NSApplication.shared.terminate(self)
    }
    
    @objc func onMain(){
        
    }
    
    
}

