//
//  SourceEditorCommand.swift
//  TPJSONFormatter_Extension
//
//  Created by 谭鹏 on 2019/5/13.
//  Copyright © 2019 谭鹏. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        completionHandler(nil)
    }
    
}
