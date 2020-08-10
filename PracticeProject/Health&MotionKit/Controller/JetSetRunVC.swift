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
    
    let commonFunction = CommonFunctions()
    let healthKitHelper = HealthKitHelper()
    
    let healthStore = HKHealthStore()
    let altimeter = CMAltimeter()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var gradientLabelView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var isHasHealthStorePermission = false
    var isHasLocationPermission = false
    var isHasRequriedPermissions = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor,
                           UIColor.blue.cgColor,
                           UIColor.red.cgColor,
        ]
        gradient.locations = [0.2,0.5,0.9]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = gradientLabelView.bounds
        
        gradientLabelView.layer.addSublayer(gradient)
        
        gradientLabelView.mask = nameLabel
        
        startBtn.circularButton()
        startBtn.addShadow()

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
        
        healthKitHelper.requestAuthorizationFromHealthKit(toWrite: (writeTypes as! Set<HKSampleType>), toRead: (readTypes as! Set<HKObjectType>))
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
        
        let locationStatus = commonFunction.checkLocationStatus()
        if locationStatus == true{
            isHasLocationPermission = true
        }
    }
    
    // MARK: Event Actions
    @IBAction func startRunBtn(_ sender: UIButton) {
        print("Start Run")
        let storyBoard : UIStoryboard = UIStoryboard(name: "HandMKit", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "RunningVC") as! RunningVC
        if self.isHasLocationPermission && self.isHasHealthStorePermission{
            self.isHasRequriedPermissions = true
        }
        nextVC.isHasRequriedPermissions = self.isHasRequriedPermissions
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}


// MARK: Extensions

extension JetSetRunVC: HealthKitDelegates{
    func getWeight(weight: Double) { }
    
    func didGetResults(success: Bool, result: String) {
        if success{
            self.isHasHealthStorePermission = true
        }else{
            print(result)
        }
    }
}

