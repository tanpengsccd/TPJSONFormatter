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
            case array(arrayClass:TPClassInfo?)
            case customClass(classes:[TPClassInfo])
        }
        case bool 
        case double
        case int
        case string
        case recombinationClassKind(recombination:RecombinationClassKind)
    }
    var name: String?
    var id:String
    var isOptional:Bool?
    var properties: ClassKind
    
    static func  result(id:String  , name:String?, jsonValue:TPJsonModel? ) throws -> TPClassInfo? {
        if let jsonValue = jsonValue {
            var childId = 0
            switch jsonValue {
                
            case .simpleValue(let value):
                switch value{
                case .bool:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: nil, properties: TPClassInfo.ClassKind.bool)
                case .double:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: nil, properties: TPClassInfo.ClassKind.double)
                case .int:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: nil, properties: TPClassInfo.ClassKind.int)
                case .string:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: nil, properties: TPClassInfo.ClassKind.string)
                    
                }
            case .properties(let properties):
                let classInfos = try properties.map({ (jsonObject) -> TPClassInfo in
                    
                    let classInfo = try result(id: "\(id)_\(childId)", name: jsonObject.key, jsonValue: jsonObject.value)
                    childId += 1
                    return classInfo!
                })
                return TPClassInfo.init(name: name, id: id, isOptional: nil, properties: TPClassInfo.ClassKind.recombinationClassKind(recombination: TPClassInfo.ClassKind.RecombinationClassKind.customClass(classes: classInfos)))
            case .arrays(let jsonModel):
                let classInfo = try result(id: "\(id)_\(childId)", name: name, jsonValue: jsonModel  )
                return TPClassInfo.init(name: name, id: id, isOptional: nil, properties: TPClassInfo.ClassKind.recombinationClassKind(recombination: TPClassInfo.ClassKind.RecombinationClassKind.array(arrayClass: classInfo)))
                
            }
        }else{
            return nil
        }
    }
}

