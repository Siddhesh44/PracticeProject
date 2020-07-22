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
    
    let healthStore = HKHealthStore()
    
    @IBOutlet weak var startBtn: UIButton!
    
    var isHasRequriedPermissions = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        startBtn.layer.cornerRadius = startBtn.frame.size.width / 2
        startBtn.layer.masksToBounds = true
        
        authorizeHealthKit()
    }
    func authorizeHealthKit(){
        
        let writeTypes = Set([HKWorkoutType.quantityType(forIdentifier: .distanceWalkingRunning),
                              HKActivitySummaryType.quantityType(forIdentifier: .activeEnergyBurned),
                              HKObjectType.quantityType(forIdentifier: .heartRate)])
        
        let readTypes = Set([HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning),
                             HKSampleType.quantityType(forIdentifier: .activeEnergyBurned),
                             HKSampleType.quantityType(forIdentifier: .heartRate),
                             HKSampleType.quantityType(forIdentifier: .bodyMass)])
        
        if !HKHealthStore.isHealthDataAvailable(){
            print("Error Occured")
            return
        }
        
        healthStore.requestAuthorization(toShare: writeTypes as? Set<HKSampleType>, read: readTypes as? Set<HKObjectType>) { (success, error) in
            if success {
                print("Permission Granted",success)
                self.isHasRequriedPermissions = true
            }else{
                print("Error Occured",error!.localizedDescription)
            }
        }
    }
    
    @IBAction func startRunBtn(_ sender: UIButton) {
        print("Start Run")
        let storyBoard : UIStoryboard = UIStoryboard(name: "HandMKit", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "RunningVC") as! RunningVC
        nextVC.isHasRequriedPermissions = isHasRequriedPermissions
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

