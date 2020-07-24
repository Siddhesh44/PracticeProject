//
//  RunningVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 18/07/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion
import CoreLocation

class RunningVC: UIViewController {
    
    let commonFunction = CommonFunctions()
    let healthStore = HKHealthStore()
    let motionManager = CMMotionManager()
    let altimeter = CMAltimeter()
    let locationManager = CLLocationManager()
    
    typealias km = Double
    typealias cal = Double
    typealias time = String
    typealias kg = Double
    
    
    var runningDistance: km = 0.0
    var runTime: time?
    var elevation: km?
    var caloriesBurned: cal?
    var bpm: Double?
    var userWeight: kg?
    var timer: Timer?
    var counter = 0
    
    lazy var locationsArray = [CLLocation]()
    
    var startingLocation:CLLocation?
    var isHasRequriedPermissions = false
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var stopRunBtn: UIButton!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var bpmLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        stopRunBtn.layer.cornerRadius = stopRunBtn.frame.size.width / 2
        stopRunBtn.layer.masksToBounds = true
        
        if isHasRequriedPermissions{
            print("Got All Permissions")
            getDataFromHealthApp()
            altimeterSetUp()
            setUpLocationManager()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            createTimer()
        }
    }
    
    func altimeterSetUp(){
        altimeter.startRelativeAltitudeUpdates(to: .main) { (data, error) in
            if error != nil {
                if let error = error{
                    print("Error in getting data",error.localizedDescription)
                }
            } else{
                if let data = data{
                    print("Altitude Change",data.relativeAltitude.stringValue)
                }
            }
        }
        
    }
    
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy =  kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkAuthorizations()
        } else{
            print("Check Location Services Unavailable")
        }
    }
    
    func checkAuthorizations(){
        
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
            setUpLocationManager()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            setUpLocationManager()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        @unknown default:
            break
        }
    }
    
    func getDataFromHealthApp(){
        
        guard let weightSample = HKWorkoutType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        let weightQuery = HKSampleQuery(sampleType: weightSample, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (sample, result, error) in
            print("weight sample",sample)
            if let result = result{
                if !result.isEmpty{
                    print(result.count)
                    if result.count > 1{
                        let last = (result.count - 1)
                        let data = result[last] as! HKQuantitySample
                        let unit = HKUnit(from: "lb")
                        print("Weight of user is:- ",data.quantity.doubleValue(for: unit))
                        self.userWeight = data.quantity.doubleValue(for: unit)
                    } else{
                        let data = result[0] as! HKQuantitySample
                        let unit = HKUnit(from: "lb")
                        print("Weight of user is:- ",data.quantity.doubleValue(for: unit))
                        self.userWeight = data.quantity.doubleValue(for: unit)
                    }
                }else{
                    if let error = error{
                        print("error",error.localizedDescription)
                    }
                }
            }
        }
        
        healthStore.execute(weightQuery)
        
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func updateTime(){
        
        counter += 1
        
        let time = commonFunction.timeString(counter: counter)
        
        timeLbl.text = time
    }
    
    @objc func updateTimer(){
        updateTime()
    }
    
    @IBAction func stopRun(_ sender: UIButton) {
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        altimeter.stopRelativeAltitudeUpdates()
        let storyBoard : UIStoryboard = UIStoryboard(name: "HandMKit", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "RunDetailsVC") as! RunDetailsVC
        
        nextVC.runTime = timeLbl.text
        nextVC.runningDistance = runningDistance / 1000
        nextVC.elevation = elevation
        nextVC.userWeight = userWeight
        nextVC.counter = counter
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension RunningVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationsArray.append(contentsOf: locations)
        
        for location in locationsArray{
            print(location)
            runningDistance += location.distance(from: self.locationsArray.last!)
            distanceLbl.text = String(format: "%.1f", runningDistance / 1000)
            elevation = locationsArray.last?.altitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizations()
    }
    
}
