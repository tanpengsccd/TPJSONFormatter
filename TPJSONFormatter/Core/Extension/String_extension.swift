//
//  string_extension.swift
//  TPJSONFormatter
//
//  Created by 谭鹏 on 2018/2/11.
//  Copyright © 2018年 谭鹏. All rights reserved.
//

import Foundation
extension String{
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension UserDefaults {
   static var sharedSuit:UserDefaults{
        return UserDefaults.init(suiteName: Bundle.productName)!
    }
    
}


enum CheckOptions:String{
    case isPrettyJSON
    case isStringToInt,isStringToDouble,isStringToBool

    var isCheck:Bool {
        get {
            return UserDefaults.sharedSuit.bool(forKey: self.rawValue)
        }
        nonmutating set {
            UserDefaults.sharedSuit.set(newValue, forKey: self.rawValue)
        }
    }
    
    
}

extension Bundle {
    static var productName:String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
}

extension NSDictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    
}
