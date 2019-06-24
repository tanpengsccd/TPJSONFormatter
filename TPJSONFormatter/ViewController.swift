//
//  ViewController.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/4.
//  Copyright © 2018年 谭鹏. All rights reserved.
// JSON 转换成 JSON 抽象类，再转换成 Swift抽象模型，再转换成HandyJSON，WCDB等具体类型代码

import Cocoa

class ViewController: NSViewController,NSTextViewDelegate {

    @IBOutlet var inputTextView: NSTextView!
    
    @IBOutlet weak var outputTextView: NSTextView!
    
    @IBOutlet weak var checkBox_autoProccess: NSButton!
    
    @IBOutlet weak var checkBox_autoCopy: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Converter"
        onProccess(nil)
        inputTextView.delegate = self
        
        
        #if DEBUG
        inputTextView.string = """
        {
            "object": {
                "string": "string",
                "double": 22.22,
                "int": 20,
                "boolean": true,
                "sdouble": "22.22",
                "sint": "20",
                "sboolean": "true",
                "object": {
                    "nullArray":[],
                    "array": [
                    {
                        "stringA":"stringA"
                    },
                    {
        
                        "stringC":"string"
                    }
                    ],
                    "nestArray": [[[["sss"]]]]
                }
            }
        }
        """
        
        #endif

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
                 let classInfo = try TPInstanceInfo.result(id: "0", name: "root", jsonValue: json)
                    print("---classInfo---")
                    print(classInfo)
                let handyJson = TPInstanceParser.parse(instanceInfo: classInfo, classParserKind: .HandyJson, layersOfNested: 0, arrayLayersOfNested: 0)
                    print("---handyJSON---")

                //输出 文本
                let str = handyJson.resultSring()
                print(str)
                self.outputTextView.string = str
                
//                //自动 拷贝到 粘贴板
//                if self.checkBox_autoCopy.state == .on {
//                   copyOutputTextContent(content: str)
//                }
                
            }catch let error{
                print(error)
                 self.outputTextView.string = ""
            }
        }
    }
    
    //点击复制
    @IBAction func onBtn_copy(_ sender: NSButtonCell) {
       let content = self.outputTextView.string
        let pb = NSPasteboard.general
        pb.clearContents() //must clear first
        pb.setString(content, forType: NSPasteboard.PasteboardType.string)
    }
    
    //复制到粘贴板
    func copyOutputTextContent(content:String){
        let pb = NSPasteboard.general
        pb.clearContents() //must clear first
        pb.setString(content, forType: NSPasteboard.PasteboardType.string)

//        print(pb.string(forType: .string)!)
    }
    //response
    @IBAction func onBtn_autoProccess(_ sender: NSButton) {
        self.inputTextView.delegate =  ( sender.state == .on ? self : nil)
    }
    
    //delegate
    func textViewDidChangeTypingAttributes(_ notification: Notification) {
        self.onProccess(nil)
    }
}





