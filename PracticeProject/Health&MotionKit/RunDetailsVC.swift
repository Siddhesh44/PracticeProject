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
    var avgPace = 0
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
        
        distanceLbl.text = String(runningDistance!)
        timeLbl.text = runTime
    }
    
    //    MARK: Button Actions
    
    @IBAction func resumeRunBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
