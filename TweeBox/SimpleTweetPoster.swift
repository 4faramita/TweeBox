//
//  SimpleTweetPoster.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON


class SimpleTweetPoster {
    
    public var resourceURL: (String, String)
    public var params: SimplePostParams
    
    init(params: SimplePostParams, resourceURL: (String, String)) {
        self.resourceURL = resourceURL
        self.params = params
    }

    
    public func postData(_ handler: @escaping (Tweet?) -> Void) {
        if Constants.selfID != "-1" {
            let client = RESTfulClientWithID(resource: resourceURL, params: params.getParams())
            
            print(">>> composer >> \(params.getParams())")
            
            client.getData() { data in
                if let data = data {
                    let json = JSON(data: data)
                    if json.null == nil {
                        let tweet = Tweet(with: json)
                        handler(tweet)
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
