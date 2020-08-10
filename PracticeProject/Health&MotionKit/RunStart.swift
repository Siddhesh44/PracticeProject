////
////  RunStart.swift
////  PracticeProject
////
////  Created by Siddhesh jadhav on 04/08/20.
////  Copyright © 2020 infiny. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CoreGraphics
//
//open class RunStart: UIView {
//    
//    var gAndA = GandA()
//    internal static var showView: UIView?
//    
//    static func start(){
//        if showView == nil, let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first{
//            showView = UIView(frame: UIScreen.main.bounds)
//            showView!.backgroundColor = UIColor.black
//            window.addSubview(showView!)
//            let graphicView = GandA(frame: showView!.bounds)
//            showView?.addSubview(graphicView)
//            
//            func drawText1(){
//                UIView.animate(withDuration: 1, animations: {
//                    graphicView.drawText(textToDraw: .text1)
//                    graphicView.transform = CGAffineTransform(translationX: (UIScreen.main.bounds.width/3), y: 0)
//                }) { (true) in
//                    drawText2()
//                }
//            }
//            func drawText2(){
//                UIView.animate(withDuration: 2, animations: {
//                    graphicView.drawText(textToDraw: .text3)
//                    graphicView.transform = CGAffineTransform(translationX: (UIScreen.main.bounds.width/3), y: 0)
//                }) { (true) in
//                    drawText3()
//                }
//            }
//            func drawText3(){
//                UIView.animate(withDuration: 3, animations: {
//                    graphicView.drawText(textToDraw: .text3)
//                    graphicView.transform = CGAffineTransform(translationX: (UIScreen.main.bounds.width/3), y: 0)
//                })
//            }
//            drawText1()
//        }
//    }
//    
//    static func stop(){
//        showView!.removeFromSuperview()
//        showView = nil
//    }
//}
