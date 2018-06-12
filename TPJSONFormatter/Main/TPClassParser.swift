//
//  TPHandyJsonParser.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/11.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Foundation
///解析类型 如 简单类型 ，HandyJSON
enum TPClassParserKind {
    case `default`
    case HandyJson
}

//解析的类型 类,属性变量
enum TPClassParserString{
    case classDefines(String)
    case variableDeclare(String)
}


class TPClassParser{
    class func parse(classInfo:TPClassInfo,classParseKind:TPClassParserKind ,ignoreVar:Bool = false) -> TPClassParserString{ //ignoreVar 用于 数组需要忽略 定义 类型 ，如 忽略 var array:ARRAY
        
        var classDefines = ""
        var variableDeclare:String = ""
        
         variableDeclare.append("var \(classInfo.name ?? classInfo.id)")
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
                        let subJsonParserString = parse(classInfo: arrayClass , classParseKind: classParseKind,ignoreVar : true)
                        switch subJsonParserString{
                            
                        case .classDefines(let subClassDefines):
                            classDefines += subClassDefines
                        case .variableDeclare(let subVariableDeclares):
                            variableDeclare += subVariableDeclares
                            
                            
                        }
                        
                        
                    }else{
                        switch classParseKind{
                            
                        case .default:
                            classDefines += "class \(classInfoName) {\n}\n"
                        case .HandyJson:
                            classDefines += "class \(classInfoName) : HandyJSON {\nrequired init(){}\n}\n"
                        }
                        
                    }
                    
                    typeString = "[\(classInfoName)]"
                    
                case .customClass(let classes):
                    switch classParseKind{
                        
                    case .default:
                        classDefines += "class \(classInfoName){ \n"
                    case .HandyJson:
                        classDefines += "class \(classInfoName) : HandyJSON { \n"
                    }
                    
                    var subClassDefines = ""
                    var subVariableDeclares = ""
                    for classInfoIn in classes {
                        let subJsonParserString = parse(classInfo: classInfoIn ,classParseKind:classParseKind )
                        switch subJsonParserString{
                            
                        case .classDefines(let subClassDefine):
                            subClassDefines += subClassDefine
                        case .variableDeclare(let subVariableDeclare):
                            subVariableDeclares += subVariableDeclare
                        }
                        
//                        classDefines += parse(classInfo: classInfoIn ,jsonParseKind:jsonParseKind )

                    }
                    classDefines += ( subClassDefines + subVariableDeclares)
                    switch classParseKind {
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
        

//        let isOptionalString:String  = {
            if let isOptional = classInfo.isOptional, !isOptional{
                variableDeclare  += " = " + type +  "()"
            }else{
                variableDeclare  += " : " + type + "?"
            }

//        }()
        //        return classDefines + (ignoreVar ? "" : head + type + isOptionalString) + "\n" //这里 数组需要忽略 定义 类型
        
        if classDefines.count > 0{
            return TPClassParserString.classDefines(classDefines + (ignoreVar ? "" : variableDeclare) + "\n")
        }else{
            return TPClassParserString.variableDeclare(variableDeclare  + "\n")
        }


    }
    
}


