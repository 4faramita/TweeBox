//
//  UserList.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/15.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserList: UserListRetrieverProtocol {
    
    public var userList = [TwitterUser]()
    public var nextCursor = "-1"
    public var previousCursor = "-1"
    
    public var headID: String?
    public var tailID: String?
    
    public var fetchOlder = true
    public var resourceURL: (String, String)
    public var userListParams: ParamsWithCursorProtocol
    
    init(resourceURL: (String, String), userListParams: ParamsWithCursorProtocol, fetchOlder: Bool?, nextCursor: String?, previousCursor: String?, headID: String?, tailID: String?) {
        
        self.resourceURL = resourceURL
        
        self.userListParams = userListParams
        
        if let fetchOlder = fetchOlder {
            self.fetchOlder = fetchOlder
        }
        
        if let nextCursor = nextCursor {
            self.nextCursor = nextCursor
        }
        
        if let previousCursor = previousCursor {
            self.previousCursor = previousCursor
        }
        
        self.headID = headID
        self.tailID = tailID
    }
    
    
    public func fetchData(_ handler: @escaping (String, String, [TwitterUser]) -> Void) {
        
        if Constants.selfID != "-1" {
            
            if fetchOlder, nextCursor != "0" {
                userListParams.cursor = nextCursor
            }
            
            if !fetchOlder, previousCursor != "0" {
                userListParams.cursor = previousCursor
            }
            
            
            let client = RESTfulClient(resource: resourceURL, params: userListParams.getParams())            
            
            print(">>> params >> \(userListParams.getParams())")
            
            client.getData() { data in
                if let data = data {
                    let json = JSON(data: data)
                    
                    self.nextCursor = json["next_cursor_str"].stringValue
                    self.previousCursor = json["previous_cursor_str"].stringValue
                    
                    for (_, userJSON) in json["users"] {
                        if userJSON.null == nil {
                            let user = TwitterUser(with: userJSON)
                            self.userList.append(user)  // mem cycle?
                        }
                    }
                    
                    if self.fetchOlder, let tailID = self.tailID {
                        for index in stride(from: self.userList.endIndex - 1, through: self.userList.startIndex, by: -1) {
                            if self.userList[index].id == tailID {
//                                self.userList = self.userList[(index + 1)..<(self.userList.endIndex)]
                                self.userList = Array(self.userList.suffix(self.userList.endIndex - index - 1))
                                break
                            }
                        }
                    }
                    
                    if !(self.fetchOlder), let headID = self.headID {
                        for index in self.userList.startIndex..<self.userList.endIndex {
                            if self.userList[index].id == headID {
//                                self.userList = self.userList[0..<index]
                                self.userList = Array(self.userList.prefix(index))
                                break
                            }
                        }
                    }
                    
                    handler(self.nextCursor, self.previousCursor, self.userList)
                } else {
                    handler(self.nextCursor, self.previousCursor, self.userList)
                }
            }
            
        }
    }    
}
