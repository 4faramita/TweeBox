//
//  SearchDialogView.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/25.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import SnapKit

class SearchDialogView: UIView {
    
    public var keyword: String? {
        didSet {
            setSearchButtons()
        }
    }

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var searchTweetButton: UIButton!
    @IBOutlet weak var searchHashtagButton: UIButton!
    @IBOutlet weak var findUserButton: UIButton!
    @IBOutlet weak var searchUserButton: UIButton!
    
    private var buttons: [UIButton]!
    
    
    func initSearchButtons() {

        buttons = [searchTweetButton, searchHashtagButton, findUserButton, searchUserButton]
        
        searchTweetButton.setTitle("Search Tweet", for: .disabled)
//        searchTweetButton.isEnabled = false
        
        searchHashtagButton.setTitle("Search Hashtag", for: .disabled)
//        searchHashtagButton.isEnabled = false
        
        findUserButton.setTitle("Find User", for: .disabled)
//        findUserButton.isEnabled = false
        
        searchUserButton.setTitle("Search User", for: .disabled)
//        searchUserButton.isEnabled = false

        for button in buttons {

            button.isEnabled = false

            button.cutToRound(radius: 5)

            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.lightGray.cgColor

//            button.backgroundColor = .gray

            button.setTitleColor(.darkGray, for: .normal)
            button.setTitleColor(.lightGray, for: .disabled)

        }

    }

    
    private func setSearchButtons() {
        if let keyword = keyword, !(keyword.isEmpty) {
            
            searchTweetButton.setTitle("Tweet With \"\(keyword)\"", for: .normal)
            if !(searchTweetButton.isEnabled) {
                searchTweetButton.isEnabled = true
            }

            if keyword.isLegit {
                searchHashtagButton.setTitle("Hashtag \"#\(keyword)\"", for: .normal)
                if !(searchHashtagButton.isEnabled) {
                    searchHashtagButton.isEnabled = true
                }

                findUserButton.setTitle("User \"@\(keyword)\"", for: .normal)
                if !(findUserButton.isEnabled) {
                    findUserButton.isEnabled = true
                }
                
                searchUserButton.setTitle("User With \"\(keyword)\"", for: .normal)
                if !(searchUserButton.isEnabled) {
                    searchUserButton.isEnabled = true
                }
            } else {

                for index in 1...3 {
                    let button = buttons[index]
                    if button.isEnabled {
                        button.isEnabled = false
                    }
                }
            }
        } else {

            for button in buttons {
                if button.isEnabled {
                    button.isEnabled = false
                }
            }
        }
    }
}

