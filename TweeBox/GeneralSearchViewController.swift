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
    
    fileprivate var shouldProceedSegue = true
    
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
        if let identifier = segue.identifier {
            switch identifier {
                case "Show Tweets":
                    
                    if let searchTimelineViewController = segue.destination.content as? SearchTimelineTableViewController {
                        searchTimelineViewController.query = keyword
                    }
                
                case "Show Tweets with Hashtag":
                    if let searchTimelineViewController = segue.destination.content as? SearchTimelineTableViewController {
                        if let keyword = keyword {
                            searchTimelineViewController.query = "%23\(keyword)"
                        }
                    }

                case "Show User":
                    fetchUser() { [weak self] (user) in
                        print(">>> user >> \(user)")
                        
                        if let user = user {
                            if let profileViewController = segue.destination.content as? UserTimelineTableViewController {
                                profileViewController.user = user
                                self?.shouldProceedSegue = true
                            } else {
                                self?.alertForNoSuchUser()
                            }
                        } else {
                            self?.alertForNoSuchUser()
                        }
                    }
                
//                case Show "Show Users":
                
                default:
                    return
            }
        }
    }
    
    private func alertForNoSuchUser() {
        
        shouldProceedSegue = false
        let popup = PopupDialog(title: "Cannot Find User @\(keyword ?? "")", message: "Please check your input.", image: nil)
        let buttonOne = CancelButton(title: "OK") {
            //                        popup.dismiss(animated: true, completion: nil)
        }
        popup.addButton(buttonOne)
        present(popup, animated: true, completion: nil)

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "Show User" {
            return shouldProceedSegue
        }
        
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    private func fetchUser(_ handler: @escaping (TwitterUser?) -> Void) {
        
        SingleUser(
            userParams: UserParams(userID: nil, screenName: keyword),
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
