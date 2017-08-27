//
//  TweetClickableContentProtocol.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/27.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import UIKit

protocol TweetClickableContentProtocol {
    
    var keyword: String? { get set }
    var fetchedUser: TwitterUser? { get set }
    
    func performSegue(withIdentifier: String, sender: Any?)
    func alertForNoSuchUser(viewController: UIViewController)
    func setAndPerformSegueForHashtag()
}
