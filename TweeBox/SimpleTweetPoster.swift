//
//  SimpleTweetPoster.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


class SimpleTweetPoster {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var resourceURL: (String, String)
    var params: SimplePostParams
    
    var client: RESTfulClient {
        return RESTfulClientWithID(resource: resourceURL, params: params.getParams())
    }
    
    init(params: SimplePostParams, resourceURL: (String, String)) {
        self.resourceURL = resourceURL
        self.params = params
    }

    
    public func postData(_ handler: @escaping (Tweet?) -> Void) {
        if Constants.selfID != "-1" {
//            let client = RESTfulClientWithID(resource: resourceURL, params: params.getParams())
            
            print(">>> composer >> \(params.getParams())")
            
            client.getData() { [weak self] data in
                if let data = data {
                    let json = JSON(data: data)
                    if json.null == nil {
                        self?.container?.performBackgroundTask({ (context) in
                            if let tweet = try? Tweet.matchOrCreateTweet(with: json, in: context) {
                                context.perform {
                                    handler(tweet)
                                }
                            }
                        })
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
