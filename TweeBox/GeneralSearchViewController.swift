//
//  GeneralSearchViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/24.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import SnapKit
import PopupDialog

class GeneralSearchViewController: UIViewController {
    
    @IBOutlet weak var dialogView: SearchDialogView!
    
    fileprivate var keyword: String? {
        return dialogView.keyword
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
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
        dialogView.initSearchButtons()
    }
    
    private func setTextField() {
        
        dialogView.inputTextField.delegate = self
        
        dialogView.snp.makeConstraints { (make) in
            make.height.equalTo(350)
        }
        
        dialogView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] (timer) in
            self?.dialogView.keyword = textField.text
        }
    }
}

// Segue related
extension GeneralSearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let keyword = keyword, let identifier = segue.identifier {
            switch identifier {
                case "Show Tweets":
                    if let searchTimelineViewController = segue.destination.content as? SearchTimelineTableViewController {
                        searchTimelineViewController.query = keyword
                        searchTimelineViewController.navigationItem.title = "\"\(keyword)\""
                    }
                
                case "Show Tweets with Hashtag":
                    if let searchTimelineViewController = segue.destination.content as? SearchTimelineTableViewController {
//                        if let keyword = keyword {
                        searchTimelineViewController.query = "%23\(keyword)"
                        searchTimelineViewController.navigationItem.title = "#\(keyword)"
//                        }
                    }

                case "Show User":
                    if let profileViewController = segue.destination.content as? UserTimelineTableViewController {
                        if let user = fetchedUser {
                            profileViewController.user = user
                        }
                    }
                
                case "Show Users":
                    if let userListTableViewController = segue.destination.content as? UserListTableViewController {
                        
                        let simpleUserListRetriever = SearchUsers(
                            usersParams: UsersSearchParams(query: keyword),
                            resourceURL: ResourceURL.users_search
                        )
                        
                        userListTableViewController.userListRetriever = simpleUserListRetriever
                        userListTableViewController.navigationItem.title = "\"\(keyword)\""
                    }
                
                default:
                    return
            }
        }
    }
    
    
    
    fileprivate func alertForNoSuchUser() {
        
        print(">>> no user")
        
        let popup = PopupDialog(title: "Cannot Find User @\(keyword ?? "")", message: "Please check your input.", image: nil)
        let cancelButton = CancelButton(title: "OK") { }
        popup.addButton(cancelButton)
        present(popup, animated: true, completion: nil)

    }
    
    
    fileprivate func fetchUser(_ handler: @escaping (TwitterUser?) -> Void) {
        
        SingleUser(
            params: UserParams(userID: nil, screenName: keyword),
            resourceURL: ResourceURL.user_show
        ).fetchData { (singleUser) in
            handler(singleUser)
        }
    }
}


extension GeneralSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
