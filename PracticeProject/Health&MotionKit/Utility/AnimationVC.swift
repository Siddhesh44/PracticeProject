//
//  RUNAnimation.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 05/08/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import CoreGraphics

enum Text{
    case text1
    case text2
    case text3
}

class AnimationVC: UIView {
    var currentText: Text?
    
    override func draw(_ rect: CGRect) {
        switch currentText{
        case .text1:
            drawText1()
        case .text2:
            drawText2()
        case .text3:
            drawText3()
        case .none:
            break
        }
    }
    
    func drawText(textToDraw: Text){
        currentText = textToDraw
        setNeedsDisplay()
    }
    
    func drawText1(){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 36),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: #colorLiteral(red: 0.6888125103, green: 0.04670301955, blue: 0.0725054376, alpha: 1)
        ]
        
        let string = "Get"
        
        let attributedString = NSAttributedString(string: string, attributes: attrs)
        
        attributedString.draw(with: CGRect(x: bounds.midX - (UIScreen.main.bounds.width/6),
                                           y: bounds.midY,
                                           width: UIScreen.main.bounds.width/3,
                                           height: 150),
                              options: .usesLineFragmentOrigin, context: nil)
        
        
    }
    
    func drawText2(){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 36),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: #colorLiteral(red: 0.6888125103, green: 0.04670301955, blue: 0.0725054376, alpha: 1)
        ]
        
        let string = "Set"
        
        let attributedString = NSAttributedString(string: string, attributes: attrs)
        
        attributedString.draw(with: CGRect(x: bounds.midX - (UIScreen.main.bounds.width/6),
                                           y: bounds.midY,
                                           width: UIScreen.main.bounds.width/3,
                                           height: 150),
                              options: .usesLineFragmentOrigin, context: nil)
        
        
    }
    
    func drawText3(){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 36),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: #colorLiteral(red: 0.6888125103, green: 0.04670301955, blue: 0.0725054376, alpha: 1),
        ]
        
        
        let string = "RUN LIKE HERO"
        
        let attributedString = NSAttributedString(string: string, attributes: attrs)
        
        
        attributedString.draw(with: CGRect(x: bounds.midX - (UIScreen.main.bounds.width/6),
                                           y: bounds.midY - 50,
                                           width: UIScreen.main.bounds.width/3,
                                           height: 150),
                              options: .usesLineFragmentOrigin, context: nil)
        
        
    }
}
