//
//  SingleTweet.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/21.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


class SingleTweet {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    //    private var user: TwitterUser!
    
    public var resourceURL: (String, String)
    public var params: TweetParams
    
    init(params: TweetParams, resourceURL: (String, String)) {
        self.resourceURL = resourceURL
        self.params = params
    }
    
    public func fetchData(_ handler: @escaping (Tweet?) -> Void) {
        if Constants.selfID != "-1" {
            let client = RESTfulClient(resource: resourceURL, params: params.getParams())
            
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
