//
//  ViewController.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/4.
//  Copyright © 2018年 谭鹏. All rights reserved.
// 1 json 转换为 dictionary
// 2 递归获取dictionary 的key value

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
            
            onProccess(nil)
        
    
        
    }
   
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var onProccess: NSButton!
    
    @IBAction func onProccess(_ sender: Any?) {
        let text = textView.string
        
        //check valid
        
        
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                print(dict)
                
                if let  json = try TPJsonProcessor.processJson(value: dict){
                    print("---json---")
                    print(json)
                    
                    let classInfo = try self.result(id: "a", name: "root", jsonValue: json)
                    print("---classInfo---")
                    print(classInfo)
                    let handyJson = TPHandyJsonParser.parse(classInfo: classInfo!)
                    print("---handyJson---")
                    print(handyJson)
                    //输出 文本
                }
               
                
                
            }catch let error{
                print(error)
            }
            
        }
    }
    func result(id:String  , name:String?, jsonValue:TPJsonModel? ) throws -> TPClassInfo? {
        if let jsonValue = jsonValue {
            var childId = 0
            switch jsonValue {
                
            case .simpleValue(let value):
                switch value{
                case .bool:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: nil, properties: TPClassInfo.ClassKind.bool)
                case .double:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: nil, properties: TPClassInfo.ClassKind.double)
                case .int:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: nil, properties: TPClassInfo.ClassKind.int)
                case .string:
                    return  TPClassInfo.init(name: name, id: "\(id)_\(childId)", isOptional: nil, properties: TPClassInfo.ClassKind.string)
                    
                }
            case .properties(let properties):
                let classInfos = try properties.map({ (jsonObject) -> TPClassInfo in
                    
                    let classInfo = try result(id: "\(id)_\(childId)", name: jsonObject.key, jsonValue: jsonObject.value)
                    childId += 1
                    return classInfo!
                })
                return TPClassInfo.init(name: name, id: id, isOptional: nil, properties: TPClassInfo.ClassKind.recombinationClassKind(recombination: TPClassInfo.ClassKind.RecombinationClassKind.customClass(classes: classInfos)))
            case .arrays(let jsonModel):
                let classInfo = try result(id: "\(id)_\(childId)", name: name, jsonValue: jsonModel  )
                return TPClassInfo.init(name: name, id: id, isOptional: nil, properties: TPClassInfo.ClassKind.recombinationClassKind(recombination: TPClassInfo.ClassKind.RecombinationClassKind.array(arrayClass: classInfo)))
                
            }
        }else{
            return nil
        }
    }
}

