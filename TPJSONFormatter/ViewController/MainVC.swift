//
//  MainVC.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2019/6/27.
//  Copyright © 2019 谭鹏. All rights reserved.
//

import Cocoa
import SnapKit
class MainVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let toolBarVC = ToolBarTabViewController.initFromDefaultNib()
        self.view.addSubview(toolBarVC.view)
        toolBarVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalTo(NSSize.init(width: 400, height: 400))
        }
    }
    
}
