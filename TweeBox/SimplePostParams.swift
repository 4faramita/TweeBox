//
//  SimplePostParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class SimplePostParams: ParamsProtocol {
    
    public var id: String
    
//    var trim_user = true
    
    
    init(id: String) {
        self.id = id
    }
    
    
    func getParams() -> [String : Any] {
        
        var params = [String: String]()
        
        params["id"] = id
        
        return params
    }
}
