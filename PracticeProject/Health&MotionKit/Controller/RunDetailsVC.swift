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
    typealias kg = Double
    
    var runningDistance: km?
    var runTime: String?
    var elevation: km?
    var caloriesBurned: cal?
    var bpm: Double?
    var userWeight: kg?
    var counter: Int?
    
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        
        let screenHeight = UIScreen.main.bounds.height
        print(screenHeight,screenHeight/3)
        mapHeight.constant = screenHeight/3
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        stopBtn.layer.cornerRadius = stopBtn.frame.size.width / 2
        stopBtn.layer.masksToBounds = true
        
        resumeBtn.layer.cornerRadius = resumeBtn.frame.size.width / 2
        resumeBtn.layer.masksToBounds = true
        
        setAvgPace()
        setCalBurn()
        
        distanceLbl.text = String(format: "%.1f", runningDistance!)
        
        timeLbl.text = runTime
        if let elevation = elevation{
            if elevation > 0{
                elevationLbl.text = "\(elevation)m"
            }else{
                elevationLbl.text = "0m"
                
            }
        }
    }
    
    //    MARK: Button Actions
    
    @IBAction func resumeRunBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UserDefined Functions
    func setAvgPace(){
        // minutes per km = minutes divided by km
        var paceInMPK = (Double(counter!) / 60) / (runningDistance!)
        if paceInMPK.isNaN || paceInMPK.isInfinite {
            paceInMPK = 0.0
        }
        let paceMinutes = Int(paceInMPK)
        let paceDecimal = paceInMPK - Double(paceMinutes)
        let paceSec = Int(paceDecimal * 60)
        
        paceLbl.text = "\(paceMinutes)'\(paceSec)\""
    }
    
    func setCalBurn(){
        let paceInMPH = (runningDistance!) / (Double(counter!) / 3600)
        print(paceInMPH)
        
        var MET = 0.0
        switch paceInMPH {
        case 0...0.5:
            MET = 0.1
        case 0.5...1.0:
            MET = 1
        case 1.0..<2.0:
            MET = 1.3
        case 2.0..<3.0:
            MET = 2.5
        case 3.0..<4.0:
            MET = 3.5
        case 4.0..<5.0:
            MET = 5
        case 4.0..<5.0:
            MET = 8.3
        case 5.0..<5.2:
            MET = 9
        case 5.2..<6.0:
            MET = 9.8
        case 6.0..<6.7:
            MET = 10.5
        case 6.7..<7.0:
            MET = 11
        case 7.0..<7.5:
            MET = 11.5
        case 7.5..<8.0:
            MET = 11.8
        case 8.0..<8.6:
            MET = 12.3
        case 8.6..<9.0:
            MET = 12.8
        case 9.0..<10.0:
            MET = 14.5
        case 10.0..<11.0:
            MET = 16
        case 11.0..<12.0:
            MET = 19
        case 12.0..<13.0:
            MET = 19.8
        case 13.0..<14.0,14.0...:
            MET = 23
        default:
            break
        }
        print(userWeight)
        print(MET)
        let time = (Double(counter!) / 3600)
        print("time",time)
        let caloriesBurned = (time) * (MET * userWeight!)
        print(caloriesBurned)
        calLbl.text = "\(Int(caloriesBurned))"
        
    }
    
}





