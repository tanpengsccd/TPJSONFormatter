//
//  NSViewController.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2019/6/27.
//  Copyright © 2019 谭鹏. All rights reserved.
//

import Cocoa
extension NSViewController {
    ///TP 从默认xib中初始化NSViewController
    public class func initFromDefaultNib() -> Self {
        let name = String.init(describing: self)
        return self.init(nibName: name, bundle: Bundle.init(for: self))
    }
}
