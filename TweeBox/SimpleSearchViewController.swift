//
//  SimpleSearchViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/27.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit

class SimpleSearchViewController: UIViewController {

    public var keywordToSet: String?
    
    fileprivate var keyword: String? {
        return keywordToSet
    }
    
    fileprivate var fetchedUser: TwitterUser?

    @IBAction func findUser(_ sender: UIButton) {
        
        fetchUser() { [weak self] (user) in
            
            if let user = user {
                self?.fetchedUser = user
                self?.performSegue(withIdentifier: "Show User", sender: self)
            } else {
                self?.alertForNoSuchUser()
            }
        }
    }

}
