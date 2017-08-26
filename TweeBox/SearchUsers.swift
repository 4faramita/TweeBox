//
//  SearchUsers.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/26.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchUsers: UserListRetrieverProtocol {
    
    private var userList = [TwitterUser]()
    
    public var resourceURL: (String, String)
    public var usersParams: UsersSearchParams
    
    init(usersParams: UsersSearchParams, resourceURL: (String, String)) {
        self.resourceURL = resourceURL
        self.usersParams = usersParams
    }
    
    public func fetchData(_ handler: @escaping (String, String, [TwitterUser]) -> Void) {
        if Constants.selfID != "-1" {
            let client = RESTfulClient(resource: resourceURL, params: usersParams.getParams())
            
            client.getData() { data in
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    for (_, userJSON) in json {
                        if userJSON.null == nil {
                            let user = TwitterUser(with: userJSON)
                            self.userList.append(user)  // mem cycle?
                        }
                    }
                    
                    handler("0", "0", self.userList)
                }
            }
        }
    }
}
