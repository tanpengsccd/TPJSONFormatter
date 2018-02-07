//
//  TPClassInfo.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/7.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Foundation
struct TPClassInfo {
    
    indirect enum ClassKind{
        enum RecombinationClassKind {
            case array(class:TPClassInfo)
            case customClass(customClass:[TPClassInfo])
        }
        case bool 
        case double
        case int
        case string
        case recombinationClassKind(recombination:RecombinationClassKind)
    }
    var name: String?
    var id:String
    var properties: ClassKind
}
