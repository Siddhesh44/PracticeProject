//
//  RunDetailsVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 15/07/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import HealthKit

class RunDetailsVC: UIViewController {
    
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var resumeBtn: UIButton!
    
    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var calLbl: UILabel!
    @IBOutlet weak var elevationLbl: UILabel!
    @IBOutlet weak var bpmLbl: UILabel!
    
    typealias km = Double
    typealias cal = Double
    typealias time = String
    
    var runningDistance: km?
    var avgPace = 0.0
    var runTime: String?
    var elvation: km?
    var caloriesBurned: cal?
    var bpm: Double?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        stopBtn.layer.cornerRadius = stopBtn.frame.size.width / 2
        stopBtn.layer.masksToBounds = true
        
        resumeBtn.layer.cornerRadius = resumeBtn.frame.size.width / 2
        resumeBtn.layer.masksToBounds = true
        
        let flooredCounter = Int(floor(avgPace))

        let hours = flooredCounter / 3600
        var hoursString = String(hours)
        if hours < 10 {
            hoursString = "0\(hours)"
        }

        let minutes = flooredCounter / 60 % 60
        var minutesString = String(minutes)

        if minutes < 10 {
            minutesString = "0\(minutes)"
        }

        let seconds = flooredCounter % 60
        var secondsString = String(seconds)
        if seconds < 10 {
            secondsString = "0\(seconds)"
        }
        
        if avgPace > 3600.0 {
            paceLbl.text = "\(hoursString):\(minutesString):\(secondsString)"
        } else{
            paceLbl.text = "\(minutesString)'\(secondsString)\""
        }
        
        distanceLbl.text = String(format: "%.1f", runningDistance!)
//        paceLbl.text = String(avgPace)
        timeLbl.text = runTime
    }
    
    //    MARK: Button Actions
    
    @IBAction func resumeRunBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
