//
//  IntegerExtension.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/21.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

extension Int {
    
    var shortExpression: String {
        
        let shortenExpression: String
        
        if self > 10000 {
            shortenExpression = "\(Int(Float(self) / 1000))k"
        } else {
            shortenExpression = "\(self)"
        }
        
        return shortenExpression
    }
}
