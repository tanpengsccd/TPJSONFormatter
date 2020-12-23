//
//  TPClassInfo.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/4.
//  Copyright © 2018年 谭鹏. All rights reserved.
//
//JOSN 模型
import Foundation
indirect enum TPJSONModel{
   
    
    //json 值有三种类型
    case simpleModel(TPJSONSimpleValue) //简单类型：string，bool，number
    case objectModel (name:String,dictionary:[String:TPJSONModel]) //属性类型 {}
    case arrayModel  (name:String,model     :TPJSONModel) //数组类型 []
    case null
    
    ///将2个Model合并
    func merging(other:TPJSONModel)->TPJSONModel{
        switch (self,other){
        case (.null,_)://又一个为空类型 自然 取 另一个other的类型
            return other
        case let (.simpleModel(selfSimple), .simpleModel(otherSimple)):
            //简单类型合并时，需要都相同，否则就是string类型，因为string能保留值的所有细节
            return selfSimple == otherSimple ? self : .simpleModel(.string)
        case let (.objectModel(selfName,selfDict),.objectModel(_,otherDict)):
            //object合并 其实就是字典合并
            //思路：将 2个字典 合并，但是字典元素可能又是 相同的，所以这里就用递归再次处理 合并 字典
            let newDict = selfDict.merging(otherDict, uniquingKeysWith: { this,that in
                return this.merging(other:that)
            })
            return .objectModel(name: selfName, dictionary: newDict)
        case let (.arrayModel(selfName,selfModel),.arrayModel(_,otherModel)):
            //数组合并 直接递归处理
            return .arrayModel(name: selfName, model: selfModel.merging(other: otherModel))
        default:
            //剩余不匹配的情况都用String 接收所有值
            return .simpleModel(.string)
        }
    }
    
    var classTypeName:String {
        switch self {
        
        case .simpleModel(let value):
            return value.classTypeName
        case .objectModel(let name, let model):
            return name.capitalized
        case .arrayModel(name: let name, let model):
            return "Array<\(name)>"
        case .null:
            return "Any?"
        }
    }
    ///嵌套的子 类型
    var subClassDefine:String{
        switch self{
        
        case .simpleModel,.null://简单类型没有子类型
            return ""
            //MARK:TODO 待完善
        case .objectModel(name: let name,dictionary: let value):
            return ""
        case .arrayModel(name: let name, model: let value):
            return ""
        }
    }
}

extension TPJSONModel:Comparable{ //可比较
    //判断节点类型是否相同
    static func ==(lhs: TPJSONModel, rhs: TPJSONModel) -> Bool {
        switch (lhs , rhs) {
        case ( .simpleModel , .simpleModel):
            return true
        case (.objectModel(_,let lhsProperties) ,.objectModel(_,let rhsProperties)): //这里需要递归判断子properties 的类型
//            lhsProperties.forEach({ (lhsProperty) in
//                rhsProperties.forEach({ (rhsProperty) in
//                    return lhsProperty == rhsProperty
//                })
//            }) //这样玩不动 返回的值不能传递 ，下面才能玩得动
            for lhsProperty in lhsProperties{ //可能有问题
                for rhsProperty in rhsProperties{
                    if lhsProperty.key == rhsProperty.key { //当属性名相同，类型也必须相同，否则 返回不同结果
                        return lhsProperty.value == rhsProperty.value
                    }
                }
            }
            return true
        case (.arrayModel ,.arrayModel):
            return true
        default:
            return false
        }
    }
    static func <(lhs: TPJSONModel, rhs: TPJSONModel) -> Bool { //其实用不到
        switch (lhs , rhs) {

        case (.objectModel(_,let lhs) ,.objectModel(_,let rhs)):
            return lhs.count < rhs.count
   
        default:
            return false
        }

    }
}

enum TPJSONSimpleValue:String {
    case boolean
    case number
    case string
    var classTypeName:String{
        switch self {
        
        case .boolean:
            return "Bool"
        case .number:
            return "Double"
        case .string:
            return "String"
        }
    }
}
//JSON 定义
//https://www.json.org/json-zh.html
//APPLE 文档
//https://developer.apple.com/swift/blog/?id=37
