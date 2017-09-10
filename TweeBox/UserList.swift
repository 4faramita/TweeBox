//
//  UserList.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/15.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class UserList: UserListRetrieverProtocol {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    public var userList = [TwitterUser]()
    public var nextCursor = "-1"
    public var previousCursor = "-1"
    
    public var headID: String?
    public var tailID: String?
    
    public var fetchOlder = true
    public var resourceURL: (String, String)
    public var params: ParamsWithCursorProtocol
    
    init(resourceURL: (String, String), params: ParamsWithCursorProtocol, fetchOlder: Bool?, nextCursor: String?, previousCursor: String?, headID: String?, tailID: String?) {
        
        self.resourceURL = resourceURL
        
        self.params = params
        
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
                params.cursor = nextCursor
            }
            
            if !fetchOlder, previousCursor != "0" {
                params.cursor = previousCursor
            }
            
            
            let client = RESTfulClient(resource: resourceURL, params: params.getParams())
            
            print(">>> params >> \(params.getParams())")
            
            client.getData() { [weak self] data in
                
                guard let userList = self?.userList, let nextCursor = self?.nextCursor, let previousCursor = self?.previousCursor else { return }
                
                if let data = data {
                    let json = JSON(data: data)
                    
                    self?.nextCursor = json["next_cursor_str"].stringValue
                    self?.previousCursor = json["previous_cursor_str"].stringValue
                    
                    for (_, userJSON) in json["users"] {
                        if userJSON.null == nil {
                            self?.container?.performBackgroundTask({ (context) in
                                if let user = try? TwitterUser.matchOrCreateTwitterUser(with: userJSON, in: context) {
                                    context.perform {
                                        self?.userList.append(user)
                                    }
                                }
                            })
                        }
                    }
                    
                    if let fetchOlder = self?.fetchOlder, fetchOlder, let tailID = self?.tailID, let end = self?.userList.endIndex, let start = self?.userList.startIndex {
                        for index in stride(from: end - 1, through: start, by: -1) {
                            if self?.userList[index].id == tailID {
//                                self.userList = self.userList[(index + 1)..<(self.userList.endIndex)]
                                self?.userList = Array((self?.userList.suffix(end - index - 1))!)
                                break
                            }
                        }
                    }
                    
                    if let fetchOlder = self?.fetchOlder, !fetchOlder, let headID = self?.headID, let start = self?.userList.startIndex, let end = self?.userList.endIndex {
                        for index in start..<end {
                            if self?.userList[index].id == headID {
//                                self.userList = self.userList[0..<index]
                                self?.userList = Array((self?.userList.prefix(index))!)
                                break
                            }
                        }
                    }
                    
                    handler(nextCursor, previousCursor, userList)
                } else {
                    handler(nextCursor, previousCursor, userList)
                }
            }
            
        }
    }    
}
