//
//  JetSetRunVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 15/07/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion
import CoreLocation

class JetSetRunVC: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        startBtn.layer.cornerRadius = startBtn.frame.size.width / 2
        startBtn.layer.masksToBounds = true
        
    }
    
    @IBAction func startRunBtn(_ sender: UIButton) {
        print("Start Run")
        let storyBoard : UIStoryboard = UIStoryboard(name: "HandMKit", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "RunningVC") as! RunningVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

