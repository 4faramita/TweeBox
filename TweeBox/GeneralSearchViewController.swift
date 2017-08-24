//
//  GeneralSearchViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/24.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import SnapKit

class GeneralSearchViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var searchTweetButton: UIButton!
    @IBOutlet weak var searchHashtagButton: UIButton!
    @IBOutlet weak var findUserButton: UIButton!
    @IBOutlet weak var searchUserButton: UIButton!
    

//    private var inputTextField = UITextField()
//    private var searchTweetButton = UIButton()
//    private var searchHashtagButton = UIButton()
//    private var findUserButton = UIButton()
//    private var searchUserButton = UIButton()
    
    fileprivate var keyword: String? {
        didSet {
            setSearchButtons()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        setInputBox()
    }


    private func setInputBox() {

        inputTextField.delegate = self
        view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.leading.equalTo(view).offset(8)
            make.trailing.equalTo(view).offset(-8)
            make.height.equalTo(40)
        }
        
        inputTextField.autocapitalizationType = .none
        inputTextField.autocapitalizationType = .none
        inputTextField.textAlignment = .center
        inputTextField.font = UIFont.preferredFont(forTextStyle: .body)
        inputTextField.backgroundColor = .white
        inputTextField.textColor = .gray
    }

    private func setSearchButtons() {
        if let keyword = keyword, !(keyword.isEmpty) {

//            view.addSubview(searchTweetButton)
//            searchTweetButton.snp.makeConstraints { (make) in
//                make.leading.equalTo(view).offset(8)
//                make.trailing.equalTo(view).offset(-8)
//                make.height.equalTo(40)
//                make.top.equalTo(inputTextField.snp.bottom).offset(10)
//            }
//            setSearchButtonStyle(to: searchTweetButton)
            searchTweetButton.setTitle("Search Tweet With \"\(keyword)\"", for: .normal)


            if keyword.isAlpha || keyword.isDigit {
                // addMoreSearchButton
//                view.addSubview(searchHashtagButton)
//                searchHashtagButton.snp.makeConstraints { (make) in
//                    make.leading.equalTo(view).offset(8)
//                    make.trailing.equalTo(view).offset(-8)
//                    make.height.equalTo(40)
//                    make.top.equalTo(searchTweetButton.snp.bottom).offset(5)
//                }
//                setSearchButtonStyle(to: searchHashtagButton)
                searchHashtagButton.setTitle("Search Tweet With Hashtag \"#\(keyword)\"", for: .normal)

//                view.addSubview(findUserButton)
//                findUserButton.snp.makeConstraints { (make) in
//                    make.leading.equalTo(view).offset(8)
//                    make.trailing.equalTo(view).offset(-8)
//                    make.height.equalTo(40)
//                    make.top.equalTo(searchHashtagButton.snp.bottom).offset(5)
//                }
//                setSearchButtonStyle(to: findUserButton)
                findUserButton.setTitle("Find User \"@\(keyword)\"", for: .normal)

//                view.addSubview(searchUserButton)
//                searchUserButton.snp.makeConstraints { (make) in
//                    make.leading.equalTo(view).offset(8)
//                    make.trailing.equalTo(view).offset(-8)
//                    make.height.equalTo(40)
//                    make.top.equalTo(findUserButton.snp.bottom).offset(5)
//                }
//                setSearchButtonStyle(to: searchUserButton)
                searchUserButton.setTitle("Search User With \"\(keyword)\"", for: .normal)

            } else {
//                searchHashtagButton.removeFromSuperview()
//                findUserButton.removeFromSuperview()
//                searchUserButton.removeFromSuperview()
            }
        } else {
//            searchTweetButton.removeFromSuperview()
//            searchHashtagButton.removeFromSuperview()
//            findUserButton.removeFromSuperview()
//            searchUserButton.removeFromSuperview()
        }
    }
    
    private func setSearchButtonStyle(to button: UIButton) {
        
        button.backgroundColor = .lightGray
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)

    }
}

//extension GeneralSearchViewController: UITextViewDelegate {
//    
//    func textViewDidChange(_ textView: UITextView) {
//        self.keyword = textView.text
////        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] (timer) in
////            self?.keyword = textView.text
////        }
//    }
//}

extension GeneralSearchViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.keyword = textField.text
        
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] (timer) in
//            self?.keyword = textField
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
