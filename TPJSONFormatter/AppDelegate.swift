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

//    let statusBarController = StatusBarController.init()
//    var window = NSWindow.init(contentViewController: GenernalVC.initFromDefaultNib())
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
         print(NSApp.windows)
//        NSApp.mainWindow?.close()
//        NSApp.mainWindow?.isReleasedWhenClosed = true
        
        
//         Insert code here to initialize your application
//        NSApp.windowsMenu = NSMenu.init()
        let window = NSWindow.init(contentViewController: MainVC.initFromDefaultNib())
//        let window = NSWindow.init()
        window.title = "Genernal"
//        window.makeMain()
        window.setFrame( NSRect.init(x: 0, y: 0, width: 800, height: 400), display: true)
        window.center()
        window.makeKeyAndOrderFront(self)
//        window.makeMain() 
        
// NSWindow.init(contentRect: NSScreen.main?.frame ?? NSRect.init(), styleMask: NSWindow.StyleMask.closable, backing: NSWindow.BackingStoreType.buffered, defer: false)
//        window.title = "new"
//        window.isOpaque = false
//        window.center()
//        window.isMovableByWindowBackground = true
//        window.backgroundColor =  NSColor(calibratedHue: 0, saturation: 1.0, brightness: 0, alpha: 0.7)
//        window.makeKeyAndOrderFront(self)
//        let top = NSView.init(frame: NSRect.init(x: 0, y: 0, width: 200, height: 200));
//        let bottom = NSView.init(frame: NSRect.init(x: 0, y: 0, width: 200, height: 200));
//        window.contentViewController = NSViewController.init(nibName: NSNib.Name.init("NSViewController"), bundle: nil)
        
//        NSApp.mainWindow?.contentViewController = GenernalVC.initFromDefaultNib()
       
        print(NSApp.windows)
//        wc.window?.makeKeyAndOrderFront(nil)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

  

}

