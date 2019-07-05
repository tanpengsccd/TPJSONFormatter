//
//  MainVC.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2019/6/27.
//  Copyright © 2019 谭鹏. All rights reserved.
//

import Cocoa
import SnapKit
class MainVC: NSViewController,NSTextViewDelegate{

    @IBOutlet weak var checkBtnCell_prettyJSON: NSButtonCell!
    @IBOutlet var inputTextView: NSTextView!
    @IBOutlet var outputTextView: NSTextView!

    @IBOutlet weak var settingContainer: NSView!
    @IBOutlet weak var tabView: NSTabView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Converter"
        self.setMainView()
        self.setTabView()
    }
    //MARK:-- action
    @IBAction func checkBoxChange(_ sender: NSButtonCell) {
        CheckOptions.isPrettyJSON.isCheck = (sender.state == NSControl.StateValue.on)
        self.textView(NSTextView.init(), shouldChangeTextIn: NSRange.init(location: 0, length: 0) ,replacementString: self.inputTextView.string)

    }
    
    
    //MARK: NSTextViewDelegate
    
    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {

      

        let oldText = textView.string
        
        let newText = (textView.string as NSString).replacingCharacters(in: affectedCharRange, with: replacementString!)
        
        if let data = newText.data(using: String.Encoding.utf8),let oldData = oldText.data(using: .utf8) {
                
                do {
                    //序列化为JOSN
                    let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    print(dict)
                    let oldDict = (try? JSONSerialization.jsonObject(with: oldData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary) ?? NSDictionary.init()

                    if dict.isEqual(to: oldDict){
                        return true
                    }
                    
                    let str = try parse(dict)
                    print(str)
                    self.outputTextView.string = str
                    //
                    if CheckOptions.isPrettyJSON.isCheck  {
                        
                        self.inputTextView.string = dict.json//String.init(data: data, encoding: .utf8)!
                        return false
                        
                    }else{
                        return true
                    }
                    
                }catch let error{
                    print(error)
                    self.outputTextView.string = ""
                }
            
        }
        
        return true
        
    }
    //MARK:  set/get
    fileprivate func setMainView(){
        self.checkBtnCell_prettyJSON.state = ( CheckOptions.isPrettyJSON.isCheck ? .on : .off)
        
        inputTextView.delegate = self
        if #available(OSX 10.14, *) {
            inputTextView.textColor = (NSApp.effectiveAppearance.name == NSAppearance.Name.darkAqua ? NSColor.white : NSColor.black)
        }
        #if DEBUG
        let demoString  = """
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
//        self.inputTextView.string = demoString //不触发
        self.textView(NSTextView.init(), shouldChangeTextIn: NSRange.init(location: 0, length: 0) ,replacementString: demoString)
        #endif

    }
    fileprivate func setTabView() {
        // Do view setup here.
        let general:NSTabViewItem = {
            let item = NSTabViewItem.init()
            item.label = "General"
            item.viewController = GeneralVC.initFromDefaultNib()
            return item
        }()
        tabView.tabViewItems = [general]
    }
    //MARK: private
    fileprivate func parse(_ dict: NSDictionary) throws -> String {
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
        return str
    }

}
