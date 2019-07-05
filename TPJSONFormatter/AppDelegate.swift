//
//  AppDelegate.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/4.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Cocoa
//import SnapKit
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusBarController = StatusBarController.init()
//    var window = NSWindow.init(contentViewController: GenernalVC.initFromDefaultNib())
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
         print(NSApp.windows)


//        let window = MainWindowController.init()
        
        let window = NSWindow.init(contentViewController: MainVC.initFromDefaultNib())
        window.title = "Genernal"
//        window.setFrame( NSRect.init(x: 0, y: 0, width: 1600, height: 800), display: true)
        window.center()
        window.makeKeyAndOrderFront(self)
 
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

  

}

