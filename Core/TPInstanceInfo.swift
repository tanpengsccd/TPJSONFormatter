//
//  TPClassInfo.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/7.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Foundation
//代码类型模型 如HandyJson
indirect enum TPInstanceInfo { //
    
    typealias  TPSimpleClassKind = TPJSONSimpleValue

    
    case simple(id:String,name:String?,simpleInstance:TPSimpleClassKind) //简单类型
    case recombination(id:String,name:String?,subInstances:[TPInstanceInfo]) //复合类型
    case array(id:String,name:String?,elementInstance:TPInstanceInfo) //数组类型
    case null(id:String,name:String?) //空类型
    
    func nameOrId() -> String{
        switch self {

        case .simple(let id, let name, let simpleInstance):
            return name ?? id
        case .recombination(let id, let name, let subInstances):
            return name ?? id
        case .array(let id, let name, let elementInstance):
            return name ?? id
        case .null(let id, let name):
            return name ?? id
        }
    }
    var type:String {
        switch self {
            
        case .simple(let id, let name, let simpleInstance):
            return simpleInstance.rawValue.capitalized
        case .recombination(let id, let name, let subInstances):
            return (name ?? id).capitalized
        case .array(let id, let name, let elementInstance):
            return (name ?? id).capitalized
        case .null(let id, let name):
            return "String"
        }
    }
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
    static func  result(id:String  , name:String?, jsonValue:TPJSONModel   ) throws -> TPInstanceInfo {
        
            var childId = 0
            switch jsonValue {
                
            case .simpleModel(let value):
                
                return TPInstanceInfo.simple(id: id, name: name, simpleInstance: value)
//                switch value{
//                case .bool:
//
//                    return  TPInstanceInfo.simple(id: <#T##String#>, name: <#T##String?#>, simpleInstance: <#T##TPInstanceInfo.TPSimpleClassKind#>)
//                case .double:
//                    return  TPInstanceInfo.simple(.double)
//                case .int:
//                    return  TPInstanceInfo.simple(.int)
//                case .string:
//                    return  TPInstanceInfo.simple(.string)
//
//                }
            case .objectModel(_,let properties):
                let instanceInfos = try properties.map({ (jsonObject) -> TPInstanceInfo in
                    
                    let classInfo = try result(id: "\(id)_\(childId)", name: jsonObject.key, jsonValue: jsonObject.value)
                    childId += 1
                    return classInfo
                })
                return TPInstanceInfo.recombination(id: id, name: name, subInstances: instanceInfos)
                    //TPClassInfo.init(name: name, id: id, isOptional: nil, properties: TPClassInfo.TPClassKind.recombinationClassKind(recombination: TPClassInfo.TPClassKind.RecombinationClassKind.customClass(classes: classInfos)))
            case .arrayModel(_,let jsonModel):
                let instanceInfo = try result(id: "\(id)_\(childId)", name: name, jsonValue: jsonModel )
                return TPInstanceInfo.array(id: id, name: name, elementInstance: instanceInfo)
                    //TPClassInfo.init(name: name, id: id, isOptional: !isArrayInitial, properties: TPClassInfo.TPClassKind.recombinationClassKind(recombination: TPClassInfo.TPClassKind.RecombinationClassKind.array(arrayClass: classInfo)))
                
            case .null:
                return TPInstanceInfo.null(id: id, name: name)
        }
        
    }
}

