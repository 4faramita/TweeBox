//
//  MediaUploadInitParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/31.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation


class MediaUploadInitParams: ParamsProtocol {
    
    private let command = "INIT"
    
    var size: String  // total_bytes
    
    var type: String  // media_type
    
    var category: String  // media_category
    
//    additional_owners
    
    
    init(size: String, type: String, category: String) {
        
        self.size = size
        self.type = type
        self.category = category
    }
    
    
    func getParams() -> [String : Any] {
        
        var params = [String: String]()
        
        params["command"] = command
        
        params["total_bytes"] = size
        
        params["media_type"] = type
        
        params["media_category"] = category
        
        return params

    }
}
