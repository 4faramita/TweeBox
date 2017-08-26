//
//  UserListRetriever.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/26.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

protocol UserListRetrieverProtocol {
    
    func fetchData(_ handler: @escaping (String, String, [TwitterUser]) -> Void)
}
