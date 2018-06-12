//
//  TPClassInfo.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/4.
//  Copyright © 2018年 谭鹏. All rights reserved.
//
//JOSN 模型
import Foundation
indirect enum TPJsonModel:Comparable{
   
    
    static func ==(lhs: TPJsonModel, rhs: TPJsonModel) -> Bool {
        switch (lhs , rhs) {
        case ( .simpleValue , .simpleValue):
            return true
        case (.properties(let lhsProperties) ,.properties(let rhsProperties)): //这里需要递归判断子properties 的类型
//            lhsProperties.forEach({ (lhsProperty) in
//                rhsProperties.forEach({ (rhsProperty) in
//                    return lhsProperty == rhsProperty
//                })
//            }) //这样玩不动 返回的值不能传递 ，下面才能玩得动
            for lhsProperty in lhsProperties{
                for rhsProperty in rhsProperties{
                    return rhsProperty == lhsProperty
                }
            }
            return false
        case (.arrays ,.arrays):
            return true
        default:
            return false
        }
    }
    static func <(lhs: TPJsonModel, rhs: TPJsonModel) -> Bool { //其实用不到
        switch (lhs , rhs) {

        case (.properties(let lhs) ,.properties(let rhs)):
            return lhs.count < rhs.count
   
        default:
            return false
        }

    }
    //json 值有三种类型
    case simpleValue(_:TPJsonSimpleValue) //单纯的值，string，bool，double 等
    case properties( _:[TPJsonObject]) //嵌套类型
    case arrays(_:TPJsonModel?) //数组类型
//    case none
}
enum TPJsonSimpleValue: String {
    case bool = "Bool"
    case double = "Double"
    case int = "Int"
    case string = "String"
}
struct TPJsonObject:Comparable{
    static func <(lhs: TPJsonObject, rhs: TPJsonObject) -> Bool {
        return false //
    }
    
    static func ==(lhs: TPJsonObject, rhs: TPJsonObject) -> Bool {
        if lhs.key == rhs.key{
            return lhs.value == rhs.value
        }
        return false
    }
    
    var key:String
    
    var value:TPJsonModel
}
