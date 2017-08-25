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
    
    @IBOutlet weak var dialogView: SearchDialogView!
    
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


extension GeneralSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
