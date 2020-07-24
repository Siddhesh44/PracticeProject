//
//  ExtensionAndGF.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 24/07/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import Foundation

class CommonFunctions {
    
    func timeString(counter: Int) -> String {
        
        let hours = counter / 3600
        var hoursString = String(hours)
        if hours < 10 {
            hoursString = "0\(hours)"
        }
        
        let minutes = counter / 60 % 60
        var minutesString = String(minutes)
        
        if minutes < 10 {
            minutesString = "0\(minutes)"
        }
        
        let seconds = counter % 60
        var secondsString = String(seconds)
        if seconds < 10 {
            secondsString = "0\(seconds)"
        }
        
        if counter > 3600 {
            return "\(hoursString):\(minutesString):\(secondsString)"
        } else{
            return "\(minutesString):\(secondsString)"
        }
        
    }
    
}
