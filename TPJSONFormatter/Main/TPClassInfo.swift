//
//  TPClassInfo.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/7.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Foundation
//代码类型模型 如HandyJson
indirect enum TPClassInfo { //
    
     enum TPSimpleClassKind{
        case bool
        case double
        case int
        case string
    }
    case simple(TPSimpleClassKind) //简单类型
    case recombination(id:String,name:String?,subClasses:[TPClassInfo]) //复合类型
    case array(id:String,name:String?,elementClass:TPClassInfo) //数组类型
//    var name: String? //数组可能无名字
//    var id:String //唯一id
//    var properties: TPClassKind
//    var typealiasValue: String?
    
    /// 生成结果
    ///
    /// - Parameters:
    ///   - id: 节点id
    ///   - name: 名字
    ///   - jsonValue: json 模型
    ///   - isOptional: 属性是否是设置为optional
    ///   - isArrayInitial: 数组节点是否初始化
    /// - Returns: 返回
    /// - Throws: 返回异常
    static func  result(id:String  , name:String?, jsonValue:TPJsonModel   ) throws -> TPClassInfo {
        
            var childId = 0
            switch jsonValue {
                
            case .simpleValue(let value):
                switch value{
                case .bool:
                    return  TPClassInfo.simple(.bool)
                case .double:
                    return  TPClassInfo.simple(.double)
                case .int:
                    return  TPClassInfo.simple(.int)
                case .string:
                    return  TPClassInfo.simple(.string)
                    
                }
            case .properties(let properties):
                let classInfos = try properties.map({ (jsonObject) -> TPClassInfo in
                    
                    let classInfo = try result(id: "\(id)_\(childId)", name: jsonObject.key, jsonValue: jsonObject.value)
                    childId += 1
                    return classInfo
                })
                return TPClassInfo.recombination(id: id, name: name, subClasses: classInfos)
                    //TPClassInfo.init(name: name, id: id, isOptional: nil, properties: TPClassInfo.TPClassKind.recombinationClassKind(recombination: TPClassInfo.TPClassKind.RecombinationClassKind.customClass(classes: classInfos)))
            case .arrays(let jsonModel):
                let classInfo = try result(id: "\(id)_\(childId)", name: name, jsonValue: jsonModel )
                return TPClassInfo.array(id: id, name: name, elementClass: classInfo)
                    //TPClassInfo.init(name: name, id: id, isOptional: !isArrayInitial, properties: TPClassInfo.TPClassKind.recombinationClassKind(recombination: TPClassInfo.TPClassKind.RecombinationClassKind.array(arrayClass: classInfo)))
                
            }
        
    }
}

