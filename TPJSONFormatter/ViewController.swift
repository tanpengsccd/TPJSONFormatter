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
                    
                    if let classInfo = try TPClassInfo.result(id: "a", name: "root", jsonValue: json){
                        print("---classInfo---")
                        print(classInfo)
                        let handyJson = TPJsonParser.parse(classInfo: classInfo , jsonParseKind: .HandyJson)
                        print("---handyJson---")
                        print(handyJson)
                        //输出 文本

                    }
                }
               
                
                
            }catch let error{
                print(error)
            }
            
        }
    }
    
}

