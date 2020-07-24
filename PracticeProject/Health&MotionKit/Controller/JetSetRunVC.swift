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
    let healthKitHelper = HealthKitHelper()
    let altimeter = CMAltimeter()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var startBtn: UIButton!
    
    var isHasHealthStorePermission = false
    var isHasLocationPermission = false
    var isHasRequriedPermissions = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        startBtn.layer.cornerRadius = startBtn.frame.size.width / 2
        startBtn.layer.masksToBounds = true
        
        healthKitHelper.healthKitDelegate = self
        
        checkAuthorizations()
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
        
        healthKitHelper.requestAuthorizationFromHealthKit(toWrite: (writeTypes as? Set<HKSampleType>)!, toRead: (readTypes as? Set<HKObjectType>)!)
    }
    
    func checkAuthorizations(){
        
        switch CMAltimeter.authorizationStatus() {
        case .notDetermined:
            print("CMAltimeter.authorizationStatus not Determined")
        case .restricted:
            print("CMAltimeter.authorizationStatus Restricted")
        case .denied:
            print("CMAltimeter.authorizationStatus Denied")
        case .authorized:
            print("CMAltimeter.authorizationStatus Authorized")
            if CMAltimeter.isRelativeAltitudeAvailable(){
                print("Relative Altitude Available")
            }
        @unknown default:
            break
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Authorization notDetermined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Authorization Restricted")
        case .denied:
            print("Authorization Denied")
        case .authorizedAlways:
            print("Authorized Always")
            isHasLocationPermission = true
        case .authorizedWhenInUse:
            print("startUpdatingLocation")
            isHasLocationPermission = true
        @unknown default:
            break
        }
    }
    
    @IBAction func startRunBtn(_ sender: UIButton) {
        print("Start Run")
        let storyBoard : UIStoryboard = UIStoryboard(name: "HandMKit", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "RunningVC") as! RunningVC
        if isHasLocationPermission && isHasHealthStorePermission{
            isHasRequriedPermissions = true
        }
        nextVC.isHasRequriedPermissions = isHasRequriedPermissions
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension JetSetRunVC: HealthKitDelegates{
    func didGetResults(success: Bool, result: String) {
        if success{
            self.isHasHealthStorePermission = true
        }else{
            print(result)
        }
    }
}

