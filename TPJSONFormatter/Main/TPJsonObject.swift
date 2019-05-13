//
//  TPClassInfo.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/4.
//  Copyright © 2018年 谭鹏. All rights reserved.
//
//JOSN 模型
import Foundation
public indirect enum TPJsonModel:Comparable{
   
    //判断节点类型是否相同
    public static func ==(lhs: TPJsonModel, rhs: TPJsonModel) -> Bool {
        switch (lhs , rhs) {
        case ( .simpleValue , .simpleValue):
            return true
        case (.properties(let lhsProperties) ,.properties(let rhsProperties)): //这里需要递归判断子properties 的类型
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
        case (.arrays ,.arrays):
            return true
        default:
            return false
        }
    }
    public static func <(lhs: TPJsonModel, rhs: TPJsonModel) -> Bool { //其实用不到
        switch (lhs , rhs) {

        case (.properties(let lhs) ,.properties(let rhs)):
            return lhs.count < rhs.count
   
        default:
            return false
        }

    }
    //json 值有三种类型
    case simpleValue(TPJsonSimpleValue) //单纯的值，string，bool，double 等
    case properties([String:TPJsonModel]) //属性类型 {}
    case arrays(TPJsonModel) //数组类型 []
    case null 
}
public enum TPJsonSimpleValue:String {
    case bool
    case double
    case int 
    case string
}

