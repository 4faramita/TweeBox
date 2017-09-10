//
//  SingleUser.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/20.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class SingleUser {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
//    private var user: TwitterUser!
    
    public var resourceURL: (String, String)
    public var params: UserParams
    
    init(params: UserParams, resourceURL: (String, String)) {
        self.resourceURL = resourceURL
        self.params = params
    }
    
    public func fetchData(_ handler: @escaping (TwitterUser?) -> Void) {
        if Constants.selfID != "-1" {
            let client = RESTfulClient(resource: resourceURL, params: params.getParams())
            
            client.getData() { [weak self] data in
                if let data = data {
                    let json = JSON(data: data)
                    if json.null == nil {
                        self?.container?.performBackgroundTask({ (context) in
                            if let user = try? TwitterUser.matchOrCreateTwitterUser(with: json, in: context) {
                                context.perform {
                                    handler(user)
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
