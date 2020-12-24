//
//  TPJsonProcessor.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/5.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Cocoa
//JSON处理器
class TPJsonProcessor {
    enum TPProcessError:Error{
        case arrayValueTypeNotSame(last:TPJSONModel ,this:TPJSONModel)
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
    //MARK:- json 转换成模型 ⭐️⭐️⭐️⭐️
    
    /// 处理JSON为Model
    /// - Parameters:
    ///   - name: 对象的名
    ///   - value: 处理的对象即JSON
    /// - Throws: 抛出的错误
    /// - Returns: 模型
    class func processJson(name:String,value:Any) throws -> TPJSONModel  {
        ///尝试将value 变换为各种类型的值:
        
        //如果能变换为双精度
        if let _ = value as? Double {
            return .simpleModel(.number)
//            if floor(double) == double {
//                return TPJSONModel.simpleValue(.int)
//            }else{
//                return TPJSONModel.simpleValue(.double)
//            }
            
        //如果能变换为boolean
        }else if let _ = value as? Bool{
                return TPJSONModel.simpleModel(.boolean)
        // 如果能转为字典类型
        }else if let object = value as? Dictionary<String, Any>{
            //处理value 中的子类型
            let tuples = try object.map({($0.key,try processJson(name: $0.key, value: $0.value))})
            return .objectModel(name:name,dictionary: .init(uniqueKeysWithValues:tuples))
        //如果能转成 数组类型
        }else if let array = value as? Array<Any>{
            
            let model = try array.reduce(TPJSONModel.null) { (result, element) -> TPJSONModel in
                let model =  try processJson(name: name,value: element)
                return result.merging(other: model)
            }
            
            return TPJSONModel.arrayModel(name: name, model: model)
        }else{
            if  let _ = value as? String {//一般都能转换为String，所以要放在最后处理
                return TPJSONModel.simpleModel(.string)
//                //还可以再处理 bool ， int ， double
//                if ["true","false"] .contains(string){
//                    return  TPJSONModel.simpleValue(.boolean)
//                }else if let double = Double(string){
//                    if floor(double) == double {
//                        return TPJSONModel.simpleValue(.int)
//                    }else{
//                        return TPJSONModel.simpleValue(.double)
//                    }
//
//                }else{
//                    return TPJSONModel.simpleValue(.string)
//                }
            }else{
                return TPJSONModel.null
            }
        }
    }
}


