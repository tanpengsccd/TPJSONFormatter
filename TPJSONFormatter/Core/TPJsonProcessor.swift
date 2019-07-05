//
//  TPJsonProcessor.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/5.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Cocoa
//json处理器
class TPJsonProcessor {
    enum TPProcessError:Error{
        case arrayValueTypeNotSame(last:TPJsonModel ,this:TPJsonModel)
        case arrayValueCountZero
        case cantCastToString(Any)
        var msg:String{
            switch self {

            case .arrayValueTypeNotSame:
                return "数组元素不同"
            case .arrayValueCountZero:
                return "数组元素为空"
            case .cantCastToString:
                return "不能转为String"
        
            }
        }
    }
    //json 转换成 模型 ⭐️⭐️⭐️⭐️⭐️
    class func processJson(value:Any) throws -> TPJsonModel  {
        
        if let properties = value as? Dictionary<String, Any>{ // 如果能转为字典类型
            var classes : [String : TPJsonModel] = [:]
            try properties.forEach { (key , value) in
                let jsonValue = try  processJson(value: value)
//                    let classInfo = [key : jsonValue] //TPJsonObject.init(key: key, value: jsonValue)
//                    classes.append(classInfo)
                classes[key] = jsonValue
                
                
            }
            return TPJsonModel.properties(classes)
        }else if let arrays = value as? Array<Any>{ //如果能转成 数组类型
            var lastValue : TPJsonModel? // 保存上个 value，用来判断下个 value 的类型是否相同
            for value in arrays { // 理论数组 内 elemtnt 大类型（enum三种）相同，不同需要报错
                
                let thisValue = try processJson(value: value)
                if lastValue == nil{ //只是第一次触发
                    lastValue = thisValue
                }else{
                    if thisValue == lastValue{ //判断节点类型是否相同
                        switch (thisValue,lastValue){
                        case ( .properties(let thisProperties) , .properties(var lastProperties)?): //都是属性 类型时 还需继续添加不同属性
//                            thisProperties.forEach({ (thisProperty) in
//                                if !lastProperties.contains(where: { $0.key == thisProperty.key && $0.value == thisProperty.value}){ // 上个属性集合不包含这个属性时，需要添加这个属性
//                                    lastProperties[thisProperty.key] = thisProperty.value
//                                }
//                            })
                            lastProperties.merge(thisProperties) { (lastP, _) -> TPJsonModel in lastP} //将属性集合合并
//                            print(lastProperties)
//                            print(lastValue)
                            lastValue = TPJsonModel.properties(lastProperties)
                        default:
                            break
                        }
                        
                        
                    }else{
                        throw  TPProcessError.arrayValueTypeNotSame(last: lastValue!, this: thisValue)
                    }
                }
            }
            
            if let result = lastValue{ //数组里有类型
                return TPJsonModel.arrays(result)
            }else{ //lastValue 为nil 时，不确定类型时 默认定为string
                return TPJsonModel.arrays(TPJsonModel.simpleValue(.string))
                
            }
            
        }else if let double = value as? Double {
            if floor(double) == double {
                return TPJsonModel.simpleValue(.int)
            }else{
                return TPJsonModel.simpleValue(.double)
            }
        }else if let _ = value as? Bool{
                return TPJsonModel.simpleValue(.bool)
            
        }else{
            if  let string = value as? String {
                //还可以再处理 bool ， int ， double
                if ["true","false"] .contains(string) && CheckOptions.isStringToBool.isCheck {
                    return  TPJsonModel.simpleValue(.bool)
                }else if let double = Double(string){
                    if floor(double) == double && CheckOptions.isStringToInt.isCheck {
                        return TPJsonModel.simpleValue(.int)
                    }else if  CheckOptions.isStringToInt.isCheck{
                        return TPJsonModel.simpleValue(.double)
                    }else {
                        return TPJsonModel.simpleValue(.string)
                    }
                }else{
                    return TPJsonModel.simpleValue(.string)
                }
            }else{
                return TPJsonModel.null
            }
        }
    }
}


