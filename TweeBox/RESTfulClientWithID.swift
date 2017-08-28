//
//  RESTfulClientWithID.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/29.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import TwitterKit

class RESTfulClientWithID: RESTfulClient {
    
    override func getData(_ handler: @escaping (Data?) -> Void) {
        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            
            let client = TWTRAPIClient(userID: userID)
            var clientError : NSError?
            
            if let tweetID = params?["id"] as? String {
                
                let url = resource.url.replacingOccurrences(of: ":id", with: tweetID)
                print(">>> url \(url)")
                
                let request = client.urlRequest(withMethod: resource.method, url: url, parameters: nil, error: &clientError)
                
                client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                    if connectionError != nil {
                        print("Error: \(connectionError!)")
                    }
                    
                    if data != nil {
                        handler(data!)
                    } else {
                        print(">>> NO DATA")
                        handler(nil)
                    }
                }
            }
        }
    }
}
