//
//  Constants.swift
//  TweeBox
//
//  Created by 4faramita on 2017/7/28.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

struct Constants {
    
    static var selfID: String {
        return Twitter.sharedInstance().sessionStore.session()?.userID ?? "-1"
    }

    static let tweetLimitPerRefresh = "100"
    static let userLimitPerRefresh = "100"
    
    static let picQuality = MediaSize.large
    
    static let aspectRatioWidth: CGFloat = 16
    static let aspectRatioHeight: CGFloat = 9
    
    static let normalAspectRatio = aspectRatioHeight / aspectRatioWidth
    static let thinAspectRatio = normalAspectRatio * 2
    
    static let picCornerRadius: CGFloat = 3

    static let defaultProfileRadius = ProfileRadius.round.rawValue
    
    static let picFadeInDuration = 0.2
    
    static let naturalReading = true
    
    static let profileImageRadius: CGFloat = 50
    static let profilePanelDragOffset: CGFloat = 100
    static let profileToolbarHeight: CGFloat = 50
    static let contentUnifiedOffset: CGFloat = 20
    
    static let themeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
    static let lightenThemeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
}

enum ProfileRadius: CGFloat {
    case round = 200
    case square = 20
}
