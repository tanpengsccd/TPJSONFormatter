//
//  TPJSONGFormatterApplication.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2019/6/27.
//  Copyright © 2019 谭鹏. All rights reserved.
//

import Cocoa

class TPJSONGFormatterApplication: NSApplication {

    let strongDelegate = AppDelegate.init()
    override init() {
        super.init()
        self.delegate = strongDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
