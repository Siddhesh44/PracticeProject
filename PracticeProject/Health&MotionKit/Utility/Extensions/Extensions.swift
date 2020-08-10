//
//  Extension + Button.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 24/07/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    func circularButton(){
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
    }
    
    func addShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.9
        layer.masksToBounds = false
    }
    
}
