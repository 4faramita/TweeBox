//
//  StringExtension.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/16.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var isAlpha: Bool {
        for scalar in self.unicodeScalars {
            let value = scalar.value
            guard (value >= 65 && value <= 90) || (value >= 97 && value <= 122) else {
                return false
            }
        }
        return true
    }
    
    var isDigit: Bool {
        for scalar in self.unicodeScalars {
            let value = scalar.value
            guard (value >= 48 && value <= 57) else {
                return false
            }
        }
        return true
    }

    
    // HTML to attributed string
    func attributedStringFromHTML(completionBlock: @escaping (NSAttributedString?) ->()) {
        guard let data = data(using: String.Encoding.utf8) else {
            print("Unable to decode data from html string: \(self)")
            return completionBlock(nil)
        }
        
        let options: [String : Any] = [
            NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSNumber(value:String.Encoding.utf8.rawValue),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue
        ]
        
        DispatchQueue.main.async() {
            if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
            {
                completionBlock(attributedString)
            } else {
                print("Unable to create attributed string from html string: \(self)")
                completionBlock(nil)
            }
        }
    }
    
    func rstrip(_ string: String?) -> String {
        return self.substring(to: self.range(of: (string ?? " "))!.lowerBound)
    }
    
    func split(_ string: String?) -> [String] {
        return self.components(separatedBy: (string ?? " "))
    }
    
    
    func stringByURLEncoding() -> String? {
        
        let characters = NSCharacterSet.urlQueryAllowed as! NSMutableCharacterSet
        
        characters.removeCharacters(in: "&")
        
        guard let encodedString = (self as NSString).addingPercentEncoding(withAllowedCharacters: characters as CharacterSet) else {
            return nil
        }
        
        return encodedString
        
    }

}
