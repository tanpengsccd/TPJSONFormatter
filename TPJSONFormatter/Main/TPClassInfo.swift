//
//  TPClassInfo.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/7.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Foundation
//代码类型模型 如HandyJson
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
    static func  result(id:String  , name:String?, jsonValue:TPJsonModel?,isOptional:Bool ,isArrayInitial :Bool ) throws -> TPClassInfo? {
        if let jsonValue = jsonValue {
            var childId = 0
            switch jsonValue {
                
            case .simpleValue(let value):
                switch value{
                case .bool:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: isOptional, properties: TPClassInfo.ClassKind.bool)
                case .double:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: isOptional, properties: TPClassInfo.ClassKind.double)
                case .int:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: isOptional, properties: TPClassInfo.ClassKind.int)
                case .string:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: isOptional, properties: TPClassInfo.ClassKind.string)
                    
                }
            case .properties(let properties):
                let classInfos = try properties.map({ (jsonObject) -> TPClassInfo in
                    
                    let classInfo = try result(id: "\(id)_\(childId)", name: jsonObject.key, jsonValue: jsonObject.value,isOptional: isOptional, isArrayInitial:isArrayInitial)
                    childId += 1
                    return classInfo!
                })
                return TPClassInfo.init(name: name, id: id, isOptional: nil, properties: TPClassInfo.ClassKind.recombinationClassKind(recombination: TPClassInfo.ClassKind.RecombinationClassKind.customClass(classes: classInfos)))
            case .arrays(let jsonModel):
                let classInfo = try result(id: "\(id)_\(childId)", name: name, jsonValue: jsonModel,isOptional: isOptional ,isArrayInitial:isArrayInitial )
                return TPClassInfo.init(name: name, id: id, isOptional: !isArrayInitial, properties: TPClassInfo.ClassKind.recombinationClassKind(recombination: TPClassInfo.ClassKind.RecombinationClassKind.array(arrayClass: classInfo)))
                
            }
        }else{
            return nil
        }
    }
}

