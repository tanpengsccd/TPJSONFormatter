//
//  ToolBarTabViewController.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2019/6/27.
//  Copyright © 2019 谭鹏. All rights reserved.
//

import Cocoa

class ToolBarTabViewController: NSTabViewController {

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.tabStyle = .segmentedControlOnTop
        let genenal =  NSTabViewItem.init(viewController:  GeneralVC.initFromDefaultNib())
        genenal.image = NSImage.init(named: NSImage.preferencesGeneralName)
//        genenal.viewController =
        self.tabViewItems = [genenal]
//        self.tabs
        
        
    }
    
}
