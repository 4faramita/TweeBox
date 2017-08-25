//
//  SingleUser.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/20.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class SingleUser {
    
//    private var user: TwitterUser!
    
    public var resourceURL: (String, String)
    public var userParams: UserParams
    
    init(userParams: UserParams, resourceURL: (String, String)) {
        self.resourceURL = resourceURL
        self.userParams = userParams
    }
    
    public func fetchData(_ handler: @escaping (TwitterUser?) -> Void) {
        if Constants.selfID != "-1" {
            let client = RESTfulClient(resource: resourceURL, params: userParams.getParams())
            
            client.getData() { data in
                if let data = data {
                    let json = JSON(data: data)
                    print(json)
                    if json.null == nil {
                        let user = TwitterUser(with: json)
                        handler(user)
                    } else {
                        handler(nil)
                    }
                } else {
                    handler(nil)
                }
            }
        }
    }
}
