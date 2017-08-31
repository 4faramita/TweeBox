//
//  LaunchScreenViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/31.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "launch_screen")
    }

}
