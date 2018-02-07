//
//  TPJsonProcessor.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/5.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Cocoa

class TPJsonProcessor {
    enum TPProcessError:Error{
        case arrayValueTypeNotSame(last:TPJsonModel ,this:TPJsonModel)
        
    }
    //json 转换成 模型 ⭐️⭐️⭐️⭐️⭐️
    class func processJson(value:Any) throws -> TPJsonModel?  {
        
        if let properties = value as? Dictionary<String, Any>{ // 如果能转为字典类型
            var classes : [TPJsonObject] = []
            try properties.forEach { (key , value) in
                if let jsonValue = try  processJson(value: value){
                    let classInfo = TPJsonObject.init(key: key, value: jsonValue)
                    classes.append(classInfo)
                }
                
            }
            return TPJsonModel.properties(classes)
        }else if let arrays = value as? Array<Any>{ //如果能转成 数组类型
            var lastJsonValue : TPJsonModel? // 保存上个 value，用来判断下个 value 的类型是否相同
            for value in arrays { // 理论数组 内 elemtnt 类型相同，不同需要报错
                if let thisValue = try processJson(value: value){
                    if let lastJsonValue = lastJsonValue{ //第二次开始比较类型
                        if thisValue == lastJsonValue{
                            switch (thisValue ,lastJsonValue  ){
                            case ( .properties(var thisProperties), .properties(let lastProperties )):
                                thisProperties.forEach({ (thisProperty) in
                                    if !lastProperties.contains(where: { (lastProperty) -> Bool in // 上个属性集合不包含这个属性时，需要添加这个属性
                                        return thisProperty == lastProperty
                                    }){
                                        thisProperties.append(thisProperty)
                                    }
                                })
                            default:
                                break
                            }
                            
                            
                        }else{
                            throw  TPProcessError.arrayValueTypeNotSame(last: lastJsonValue, this: thisValue)
                        }
                    }
                    lastJsonValue = thisValue
                }
                
                
                
            }
            return TPJsonModel.arrays(lastJsonValue!)
        }else if let _ = value as? Bool{
                return TPJsonModel.simpleValue(.bool)
            
        }else if let double = value as? Double {
            if floor(double) == double {
                return TPJsonModel.simpleValue(.int)
            }else{
                return TPJsonModel.simpleValue(.double)
            }
        }else if let string = value as? String{
            //还可以再处理 bool ， int ， double
            if ["true","false"] .contains(string){
                return  TPJsonModel.simpleValue(.bool)
            }else if let double = Double(string){
                if floor(double) == double {
                    return TPJsonModel.simpleValue(.int)
                }else{
                    return TPJsonModel.simpleValue(.double)
                }

            }else{
                 return TPJsonModel.simpleValue(.string)
            }
           
        }else{
            return nil
        }
    }
}
