//
//  FavoritePoster.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/29.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class FavoritePoster: SimpleTweetPoster {
    
    override var client: RESTfulClient {
        return RESTfulClient(resource: resourceURL, params: params.getParams())
    }
    
//    override func postData(_ handler: @escaping (Tweet?) -> Void) {
//        
//        if Constants.selfID != "-1" {
//            let client = RESTfulClient(resource: resourceURL, params: params.getParams())
//            
//            print(">>> FavoritePoster >> \(params.getParams())")
//            
//            client.getData() { data in
//                if let data = data {
//                    let json = JSON(data: data)
//                    if json.null == nil {
//                        let tweet = Tweet(with: json)
//                        handler(tweet)
//                    } else {
//                        handler(nil)
//                    }
//                } else {
//                    handler(nil)
//                }
//            }
//        }
//    }
}
