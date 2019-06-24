//
//  SourceEditorCommand.swift
//  TPJSONFormatterExt
//
//  Created by 谭鹏 on 2019/6/23.
//  Copyright © 2019 谭鹏. All rights reserved.
//

import Foundation
import XcodeKit
import AppKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        guard
            let jsonData =  NSPasteboard.general.data(forType: .string) ,
            let currentRange = invocation.buffer.selections.firstObject as? XCSourceTextRange
            else{
                return
        }
        let allLines = invocation.buffer.lines
        let currentLine = currentRange.start.line
        var className:String?
        for i in 0..<allLines.count {
            guard let lineString = allLines[i] as? String else{ return }
            if lineString.contains(".swift"){
                let start = lineString.index(lineString.startIndex, offsetBy: 4)
                let end = lineString.index(lineString.endIndex, offsetBy: -7) //".swift\n"
                className = String(lineString[start..<end])
                break
            }
        }
        
        do {
            let code = try self.pasteboardToCode(jsonData: jsonData,className: className)
            
            allLines.insert(code, at: currentLine)
        }catch let error as TPJsonProcessor.TPProcessError {
            let msg = """
            /**
            TPJSONFormatterExt代码生成失败:
            \(error.msg)
            请提交问题并附上JSON示例：https://github.com/tanpengsccd/TPJSONFormatter/issues (⌘ + Click)
            **/
            """
            allLines.insert(msg, at: currentLine)
        }catch let error {
            let msg = "// TPJSONFormatterExt代码生成失败:\(error)"
            allLines.insert(msg, at: currentLine)
        }
        
        completionHandler(nil)
    }

    //粘贴板 转 代码
    func pasteboardToCode(jsonData:Data, className:String? = nil ) throws -> String {
        
        
            //序列化为JOSN
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableLeaves)
        
            #if DEBUG
            print(dict)
            #endif
            //转换成JSON模型(HandyJSON)
            
            let  json = try TPJsonProcessor.processJson(value: dict)
            #if DEBUG
            print("---json---")
            print(json)
            #endif
            //转成代码Code
            let classInfo = try TPInstanceInfo.result(id: "0", name: className ?? "root", jsonValue: json)
            #if DEBUG
            print("---classInfo---")
            print(classInfo)
            #endif
            let handyJson = TPInstanceParser.parse(instanceInfo: classInfo, classParserKind: .HandyJson, layersOfNested: 0, arrayLayersOfNested: 0)
            print("---handyJSON---")
            
            //输出 文本
            let str = handyJson.resultSring(isVariableDeclare: false)
            #if DEBUG
            print(str)
            #endif
            return str

        
    }
    
}
