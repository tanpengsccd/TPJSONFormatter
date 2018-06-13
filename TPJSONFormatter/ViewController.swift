//
//  ViewController.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/4.
//  Copyright © 2018年 谭鹏. All rights reserved.
// JSON 转换成 JSON 抽象类，再转换成 Swift抽象模型，再转换成HandyJSON，WCDB等具体类型代码

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var inputTextView: NSTextView!
    
    @IBOutlet weak var outputTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Converter"
        onProccess(nil)
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var onProccess: NSButton!
    
    // onBtnProccess
    @IBAction func onProccess(_ sender: Any?) {
        let text = inputTextView.string

        if let data = text.data(using: String.Encoding.utf8) {
        
            do {
                //序列化为JOSN
                let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                print(dict)
                //转换成JSON模型
                
                let  json = try TPJsonProcessor.processJson(value: dict)
                print("---json---")
                print(json)
                //转成代码Code
                if let classInfo = try TPClassInfo.result(id: "a", name: "root", jsonValue: json, isOptional: true, isArrayInitial:true){
                    print("---classInfo---")
                    print(classInfo)
                    let handyJson = TPClassParser.parse(classInfo: classInfo , classParseKind: .HandyJson)
                    print("---handyJSON---")
                    switch handyJson{

                    case .classDefines(let classes , let variables):
                        print("class:")
                        print(classes + variables)
                        self.outputTextView.string = classes + variables
                        copyOutputTextContent(content: classes + variables)
                    case .variableDeclare(let str):
                        print("variable:")
                        print(str)
                        self.outputTextView.string = str
                        copyOutputTextContent(content: str)
                    }
                    //输出 文本
                }
                
            }catch let error{
                print(error)
            }
        }
    }
    
    //复制到粘贴板
    func copyOutputTextContent(content:String){
        let pb = NSPasteboard.general
        pb.clearContents() //must clear first
        pb.setString(content, forType: NSPasteboard.PasteboardType.string)

//        print(pb.string(forType: .string)!)
    }
}




