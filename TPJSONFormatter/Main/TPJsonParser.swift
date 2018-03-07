//
//  TPHandyJsonParser.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/11.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Foundation
enum TPJsonParserKind {
    case `default`
    case HandyJson
}
class TPJsonParser{
    class func parse(classInfo:TPClassInfo,jsonParseKind:TPJsonParserKind ,ignoreVar:Bool = false) -> String{ // 数组需要忽略 定义 类型
        
        var classDefines = ""
        let head = "var \(classInfo.name ?? classInfo.id) :"
        let type:String = {
            switch classInfo.properties {
            case .bool:
                return "Bool"
            case .double:
                return "Double"
            case .int:
                return "Int"
            case .string:
                return "String"
            case .recombinationClassKind(let recombination):
                let classInfoName = "\(classInfo.name?.capitalized ?? classInfo.id)"
                var typeString = ""
                
                switch recombination{
                case .array(let arrayClass):
                    if let arrayClass = arrayClass{
                    
                        classDefines +=  parse(classInfo: arrayClass , jsonParseKind: jsonParseKind,ignoreVar : true)
                        
                    }else{
                        switch jsonParseKind{
                            
                        case .default:
                            classDefines += "class \(classInfoName) {\n}\n"
                        case .HandyJson:
                            classDefines += "class \(classInfoName) : HandyJSON {\nrequired init(){}\n}\n"
                        }
                        
                    }
                    
                    typeString = "[\(classInfoName)]"
                    
                case .customClass(let classes):
                    switch jsonParseKind{
                        
                    case .default:
                        classDefines += "class \(classInfoName){ \n"
                    case .HandyJson:
                        classDefines += "class \(classInfoName) : HandyJSON { \n"
                    }
                    

                    for classInfoIn in classes {

                        classDefines += parse(classInfo: classInfoIn ,jsonParseKind:jsonParseKind )

                    }
                    
                    switch jsonParseKind {
                    case .default:
                        classDefines += "}\n"
                    case .HandyJson:
                        classDefines += "required init(){}\n}\n"
                    }
                    
                    typeString = classInfoName
                    
                }
                
                return typeString
            }

        }()
        

        let isOptionalString:String  = {
            if let isOptional = classInfo.isOptional, !isOptional{
                return "!"
            }else{
                return "?"
            }

        }()
        
        
        return classDefines + (ignoreVar ? "" : head + type + isOptionalString) + "\n" //这里 数组需要忽略 定义 类型

    }
    
}

