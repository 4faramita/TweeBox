//
//  FavoriteTimelineParams.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/31.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

class FavoriteTimelineParams: UserTimelineParams {
    
    override init(of userID: String, sinceID: String? = nil, maxID: String? = nil, excludeReplies: Bool = false, includeRetweets: Bool = true) {
        
        super.init(of: userID, sinceID: sinceID, maxID: maxID, excludeReplies: excludeReplies, includeRetweets: includeRetweets)
        resourceURL = ResourceURL.favorites_list
    }

}
