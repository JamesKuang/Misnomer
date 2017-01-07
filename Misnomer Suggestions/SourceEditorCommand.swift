//
//  SourceEditorCommand.swift
//  Misnomer Suggestions
//
//  Created by James Kuang on 6/26/16.
//  Copyright © 2016 Incyc. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    /** Perform the action associated with the command using the information in \a invocation. Xcode will pass the code a completion handler that it must invoke to finish performing the command, passing nil on success or an error on failure.
     
     A canceled command must still call the completion handler, passing nil.
     
     \note Make no assumptions about the thread or queue on which this method will be invoked.
     */
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        guard let selectedRange = invocation.buffer.selections.firstObject as? XCSourceTextRange, invocation.buffer.selections.count == 1 else {
            completionHandler(NSError(domain: "Only 1 selection allowed.", code: 1, userInfo: nil))
            return
        }
        
        guard selectedRange.start.line == selectedRange.end.line else {
            completionHandler(NSError(domain: "Selection must be on same line.", code: 1, userInfo: nil))
            return
        }
        
        guard selectedRange.start.column != selectedRange.end.column else {
            completionHandler(NSError(domain: "Selection required.", code: 1, userInfo: nil))
            return
        }
        
        let selectionLine = invocation.buffer.lines[selectedRange.start.line] as! String
        
        let startIndex = selectionLine.index(selectionLine.startIndex, offsetBy: selectedRange.start.column)
        let endIndex = selectionLine.index(after: selectionLine.index(selectionLine.startIndex, offsetBy: selectedRange.end.column))
        
        let word = selectionLine.substring(with: startIndex..<endIndex)
        let query = WordQuery(word: word)
        WebService().load(query.synonyms) { result in
            guard let result = result else {
                completionHandler(NSError(domain: "Network error.", code: 1, userInfo: nil))
                return
            }
            
            let newName = result.anySynonym
            let newLine = selectionLine.replacingCharacters(in: startIndex..<endIndex, with: newName)
            
            invocation.buffer.lines[selectedRange.start.line] = newLine
            
            let newSelectedRange = XCSourceTextRange()
            newSelectedRange.start = selectedRange.start
            newSelectedRange.end = XCSourceTextPosition(line: selectedRange.start.line, column: selectedRange.start.column + newName.characters.count)
            invocation.buffer.selections[0] = newSelectedRange

            
            completionHandler(nil)
        }
    }
    
    fileprivate func findSynonyms(forWord word: String) {
        let query = WordQuery(word: word)
        WebService().load(query.synonyms, completion: { result in
            dump(result)
        })
    }
    
}
