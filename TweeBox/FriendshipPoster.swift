//
//  FriendshipPoster.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/29.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class FriendshipPoster {
    
    public var resourceURL: (String, String)
    public var userParams: SimpleUserParams
    
    init(userParams: SimpleUserParams, resourceURL: (String, String)) {
        self.resourceURL = resourceURL
        self.userParams = userParams
    }
    
    
    func postData(_ handler: @escaping (TwitterUser?) -> Void) {
        
        if Constants.selfID != "-1" {
            
            let client = RESTfulClient(resource: resourceURL, params: userParams.getParams())
            
            print(">>> FavoritePoster >> \(userParams.getParams())")
            
            client.getData() { data in
                if let data = data {
                    let json = JSON(data: data)
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
