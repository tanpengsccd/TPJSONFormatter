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
enum TPJsonParserString{
    case classDefines(String)
    case variableDeclare(String)
}
class TPJsonParser{
    class func parse(classInfo:TPClassInfo,jsonParseKind:TPJsonParserKind ,ignoreVar:Bool = false) -> TPJsonParserString{ //ignoreVar 用于 数组需要忽略 定义 类型 ，如 忽略 var array:ARRAY
        
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
                        let subJsonParserString = parse(classInfo: arrayClass , jsonParseKind: jsonParseKind,ignoreVar : true)
                        switch subJsonParserString{
                            
                        case .classDefines(let subClassDefines):
                            classDefines += subClassDefines
                        case .variableDeclare(let subVariableDeclares):
                            variableDeclare += subVariableDeclares
                            
                            
                        }
                        
                        
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
                    
                    var subClassDefines = ""
                    var subVariableDeclares = ""
                    for classInfoIn in classes {
                        let subJsonParserString = parse(classInfo: classInfoIn ,jsonParseKind:jsonParseKind )
                        switch subJsonParserString{
                            
                        case .classDefines(let subClassDefine):
                            subClassDefines += subClassDefine
                        case .variableDeclare(let subVariableDeclare):
                            subVariableDeclares += subVariableDeclare
                        }
                        
//                        classDefines += parse(classInfo: classInfoIn ,jsonParseKind:jsonParseKind )

                    }
                    classDefines += ( subClassDefines + subVariableDeclares)
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
        

//        let isOptionalString:String  = {
            if let isOptional = classInfo.isOptional, !isOptional{
                variableDeclare  += " = " + type +  "()"
            }else{
                variableDeclare  += " : " + type + "?"
            }

//        }()
        //        return classDefines + (ignoreVar ? "" : head + type + isOptionalString) + "\n" //这里 数组需要忽略 定义 类型
        
        if classDefines.count > 0{
            return TPJsonParserString.classDefines(classDefines + (ignoreVar ? "" : variableDeclare) + "\n")
        }else{
            return TPJsonParserString.variableDeclare(variableDeclare  + "\n")
        }


    }
    
}


