//
//  string_extension.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/11.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Foundation
extension String{
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
