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
    case classDefines(classes:String,variables:String)
    case variableDeclare(String)
}


class TPClassParser{
    class func parse(classInfo:TPClassInfo,classParseKind:TPClassParserKind ,ignoreVar:Bool = false, layersOfNested:Int = 0 ) -> TPClassParserString{ //ignoreVar 用于 数组需要忽略 定义 类型 ，如 忽略 var array:ARRAY
        //缩进
        let indentation = String.init(repeating: "\t", count: layersOfNested)
        //换行
        let lineFeed = "\n" + indentation
        //类型
        var classDefines = ""
        //变量声明
        var variableDeclare:String = "" //"var \(classInfo.name ?? classInfo.id)"
        
        switch classInfo {
            
        }

        //类名
//        let type:String = {
//            switch classInfo {
//            case .bool:
//                return "Bool"
//            case .double:
//                return "Double"
//            case .int:
//                return "Int"
//            case .string:
//                return "String"
//            case .recombinationClassKind(let recombination): //复合类型
//                let classInfoName = "\(classInfo.name?.capitalized ?? classInfo.id)"
//                var typeString = ""
//
//                switch recombination{
//                case .customClass(let classes): //自定义类型
//                    switch classParseKind{
//                    case .default:
//                        classDefines += "class \(classInfoName){\(lineFeed)"
//                    case .HandyJson:
//                        classDefines += "class \(classInfoName) : HandyJSON {\(lineFeed)"
//                    }
//                    var subClassDefines = ""
//                    var subVariableDeclares = ""
//                    for classInfoIn in classes {
//                        let subJsonParserString = parse(classInfo: classInfoIn ,classParseKind:classParseKind, layersOfNested: layersOfNested + 1 )
//                        switch subJsonParserString{
//                        case .classDefines(let subClassDefine,let subVariables):
//                            subClassDefines += subClassDefine
//                            subVariableDeclares += subVariables
//                        case .variableDeclare(let subVariableDeclare):
//                            subVariableDeclares += subVariableDeclare
//                        }
//                    }
//                    classDefines += ( subClassDefines + subVariableDeclares)
//                    switch classParseKind {
//                    case .default:
//                        classDefines += "}\(lineFeed + indentation)"
//                    case .HandyJson:
//                        classDefines += ("required init(){}\(lineFeed)}" + lineFeed)
//                    }
//                    typeString = classInfoName
//                case .array(let arrayClass): //数组类型
//                    if let arrayClass = arrayClass{
//                        let subJsonParserString = parse(classInfo: arrayClass , classParseKind: classParseKind, layersOfNested: layersOfNested )
//                        switch subJsonParserString{
//                        case .classDefines(let subClassDefines , let subVariables): //数组就没有 subVariables
//                            classDefines += subClassDefines
//                            variableDeclare += subVariables
//                        case .variableDeclare(let subVariableDeclares):
//                            variableDeclare += subVariableDeclares
//                        }
//                    }else{
//                        switch classParseKind{
//                        case .default:
//                            classDefines += "class \(classInfoName) {\(lineFeed)}\(lineFeed)"
//                        case .HandyJson:
//                            classDefines += "class \(classInfoName) : HandyJSON {\(lineFeed + indentation)required init(){}\(lineFeed)}\(lineFeed)"
//                        }
//                    }
//                    typeString = "[\(classInfoName)]"
//                }
//                return typeString
//            }
//
//
//        }()
        
        //set isOptional
        if let isOptional = classInfo.isOptional, !isOptional{
            variableDeclare  += " = " + type +  "()" + lineFeed
        }else{
            variableDeclare  += " : " + type + "?" + lineFeed
        }
        //return result
        if classDefines.count > 0{
            return TPClassParserString.classDefines(classes: lineFeed + classDefines,variables:  (ignoreVar ? "" : variableDeclare))
        }else{
            return TPClassParserString.variableDeclare(variableDeclare)
        }
    }
}



