//
//  SearchUsers.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/26.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class SearchUsers: UserListRetrieverProtocol {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var userList = [TwitterUser]()
    
    public var resourceURL: (String, String)
    public var params: UsersSearchParams
    
    init(params: UsersSearchParams, resourceURL: (String, String)) {
        self.resourceURL = resourceURL
        self.params = params
    }
    
    public func fetchData(_ handler: @escaping (String, String, [TwitterUser]) -> Void) {
        if Constants.selfID != "-1" {
            let client = RESTfulClient(resource: resourceURL, params: params.getParams())
            
            client.getData() { [weak self] data in
                
                guard var userList = self?.userList else { return }
                
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    for (_, userJSON) in json {
                        if userJSON.null == nil {
                            self?.container?.performBackgroundTask({ (context) in
                                if let user = try? TwitterUser.matchOrCreateTwitterUser(with: userJSON, in: context) {
                                    context.perform {
                                        userList.append(user)
                                    }
                                }
                            })
                        }
                    }
                    
                    handler("0", "0", userList)
                }
            }
        }
    }
}
