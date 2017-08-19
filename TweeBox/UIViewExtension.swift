//
//  UIViewExtension.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/19.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func cutToRound(radius: CGFloat?) {
        self.layer.cornerRadius = radius ?? (self.frame.size.width / 2)
        self.clipsToBounds = true
    }

}
