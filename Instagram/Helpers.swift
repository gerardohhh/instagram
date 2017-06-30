//
//  Helpers.swift
//  Instagram
//
//  Created by Gerardo Parra on 6/30/17.
//  Copyright © 2017 Gerardo Parra. All rights reserved.
//

import UIKit

extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: self.frame.size.width / 8, y: self.frame.size.height - width, width:  (self.frame.size.width * 0.75), height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
