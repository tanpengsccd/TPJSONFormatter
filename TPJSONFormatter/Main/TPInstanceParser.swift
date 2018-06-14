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
    
    func classDefinesSuffix() -> String{
        switch self {

        case .default:
            return ""
        case .HandyJson:
            return ": HandyJSON"
        }
    }
}

//解析的类型 类,属性变量
struct TPInstanceParserStrings{
//    case classDefines(classes:String,variables:String)
//    case variableDeclare(String)
    var classDefines:String?// class Student
    var variableDeclare:String //var student
    var function:String?
    
    func resultSring() -> String{
        return (classDefines ?? "") + variableDeclare + (function ?? "")
    }
}


class TPInstanceParser{
    class func parse(instanceInfo:TPInstanceInfo ,isVariableOptional:Bool = true ,classParserKind:TPClassParserKind, layersOfNested:Int = 0 ) -> TPInstanceParserStrings{ //ignoreVar 用于 数组需要忽略 定义 类型 ，如 忽略 var array:ARRAY
        //缩进
        let indentation = String.init(repeating: "\t", count: layersOfNested)
        //换行
        let lineFeed = "\n" + indentation

        switch instanceInfo {


        case .simple(let identifier, let name, let simpleInstance):
            let variableDeclare = "\(lineFeed)var \((name ?? identifier)) : \(simpleInstance.rawValue.capitalizingFirstLetter())\(isVariableOptional ? "?" : "()")"
            return TPInstanceParserStrings.init(classDefines: nil, variableDeclare: variableDeclare, function: nil)
        case .recombination(let identifier, let name, let subInstances):
            let classDefines:String = {
                let str = lineFeed + "class " + (name ?? identifier).capitalizingFirstLetter() + classParserKind.classDefinesSuffix()
                var subClassDefines = ""
                var subVariableDeclare = ""
                var subFunction = lineFeed + "\t" + "required init(){}"
                for instance in subInstances {
                    let parseStrings = TPInstanceParser.parse(instanceInfo: instance, isVariableOptional: isVariableOptional, classParserKind: classParserKind, layersOfNested: layersOfNested + 1)
                    subClassDefines += ( parseStrings.classDefines ?? "" )
                    subVariableDeclare  += parseStrings.variableDeclare
                    subFunction += (parseStrings.function ?? "")
                }
                
                return str + "{" + subClassDefines + subVariableDeclare + subFunction + lineFeed + "}"
            }()
            let variableDeclare = "\(lineFeed)var \((name ?? identifier)) : \((name ?? identifier).capitalizingFirstLetter())\(isVariableOptional ? "?" : "()")"
            let function = ""//lineFeed + "required init(){}"
            
            
            return TPInstanceParserStrings.init(classDefines: classDefines, variableDeclare: variableDeclare, function: function)
        case .array(let identifier, let name, let elementInstance):
            let classDefines:String = {
                
                let str = lineFeed + "typealias " + (name ?? identifier).capitalizingFirstLetter() + "s = [\(elementInstance.type())]"

                var subClassDefines = ""
                var subVariableDeclare = ""
                var subFunction = ""

                switch elementInstance {
                case .simple:
                    break
                case .recombination , .array:
                    let parseStrings = TPInstanceParser.parse(instanceInfo: elementInstance, isVariableOptional: isVariableOptional, classParserKind: classParserKind, layersOfNested: layersOfNested + 1)
                    subClassDefines += ( parseStrings.classDefines ?? "" )
//                    subVariableDeclare  += parseStrings.variableDeclare
                    subFunction += (parseStrings.function ?? "")
                case .null(let id, let name):
                    break
                }
                return str + subClassDefines + subVariableDeclare + subFunction
            }()
            let variableDeclare = "\(lineFeed)var \((name ?? identifier)) : \((name ?? identifier).capitalizingFirstLetter())s\(isVariableOptional ? "?" : "()")"
            
            return TPInstanceParserStrings.init(classDefines: classDefines, variableDeclare: variableDeclare, function: nil)
        case .null(let identifier, let name): //null处理为 optinal String 类型
            let variableDeclare = "\(lineFeed)var \((name ?? identifier)) : String?"
            return TPInstanceParserStrings.init(classDefines: nil, variableDeclare: variableDeclare, function: nil)
        }

    }
}



