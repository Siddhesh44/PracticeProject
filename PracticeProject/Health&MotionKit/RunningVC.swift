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
    
    let healthStore = HKHealthStore()
    let motionManager = CMMotionManager()
    let altimeter = CMAltimeter()
    let locationManager = CLLocationManager()
    
    typealias km = Double
    typealias cal = Double
    typealias time = String
    
    var runningDistance: km = 0.0
    var avgPace = 0.0
    var runTime: time?
    var elvation: km?
    var caloriesBurned: cal?
    var bpm: Double?
    
    var timer: Timer?
    var counter = 0.0
    
    var startingLocation:CLLocation?
    
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var stopRunBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        stopRunBtn.layer.cornerRadius = stopRunBtn.frame.size.width / 2
        stopRunBtn.layer.masksToBounds = true
        
        authorizeHealthKit()
        checkLocationServices()
        
        switch CMAltimeter.authorizationStatus() {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorized:
            print("authorized")
        @unknown default:
            break
        }
        
        if CMAltimeter.isRelativeAltitudeAvailable(){
            print("RelativeAltitudeAvailable")
            altimeter.startRelativeAltitudeUpdates(to: .main) { (data, error) in
                if error != nil { print("Error in getting data",error) } else{
                    print("Altitude Change",data?.relativeAltitude.stringValue)
                }
            }
        }else{
            print("RelativeAltitudeUnavailable")
        }
        
        print("current location",locationManager.location?.coordinate)
        startingLocation = locationManager.location
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createTimer()
    }
    
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy =  kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 0
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        } else{
            print("Check Location Services Unavailable")
        }
    }
    
    func checkLocationAuthorization(){
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
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        case .authorizedWhenInUse:
            print("startUpdatingLocation")
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        @unknown default:
            break
        }
    }
    
    func authorizeHealthKit(){
        
        let writeTypes = Set([HKWorkoutType.quantityType(forIdentifier: .distanceWalkingRunning),
                              HKActivitySummaryType.quantityType(forIdentifier: .activeEnergyBurned),
                              HKObjectType.quantityType(forIdentifier: .heartRate)])
        
        let readTypes = Set([HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning),
                             HKSampleType.quantityType(forIdentifier: .activeEnergyBurned),
                             HKSampleType.quantityType(forIdentifier: .heartRate)])
        
        if !HKHealthStore.isHealthDataAvailable(){
            print("Error Occured")
            return
        }
        
        healthStore.requestAuthorization(toShare: writeTypes as? Set<HKSampleType>, read: readTypes as? Set<HKObjectType>) { (success, error) in
            if success {
                print("Permission Granted",success)
                self.getRunData()
            }else{
                print("Error Occured",error!.localizedDescription)
            }
        }
    }
    
    func getRunData(){
        
        guard let runSample = HKWorkoutType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        
        let runQuery = HKSampleQuery(sampleType: runSample, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (sample, result, error) in
            print("sample",sample)
            if !result!.isEmpty{
                print(result!)
                let data = result![0] as! HKQuantitySample
                let unit = HKUnit(from: "mi")
                print("Step Count",data.quantity.doubleValue(for: unit))
                
                let mil = Double(data.quantity.doubleValue(for: unit))
                let km = mil * 1.6
                print("Kilometers",km)
            }else{
                print("error",error!.localizedDescription)
            }
        }
        
        healthStore.execute(runQuery)
        
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func updateTime(){
        
        counter += 0.1
        
        let flooredCounter = Int(floor(counter))
        
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
        
        if counter > 3600.0 {
            timeLbl.text = "\(hoursString):\(minutesString):\(secondsString)"
        } else{
            timeLbl.text = "\(minutesString):\(secondsString)"
        }
        
    }
    
    @objc func updateTimer(){
        updateTime()
    }
    
    @IBAction func stopRun(_ sender: UIButton) {
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        let storyBoard : UIStoryboard = UIStoryboard(name: "HandMKit", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "RunDetailsVC") as! RunDetailsVC
        
        nextVC.runTime = timeLbl.text
        nextVC.runningDistance = runningDistance/1000
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}


extension RunningVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Altitude CLL",locations.last?.altitude.stringOptional)
        //print(locations.last?.coordinate)
        
        for location in locations{
            if locations.count > 0 {
                
                print(locations.last?.coordinate)
                
                runningDistance += location.distance(from: startingLocation!)
                
                print("distance in km",runningDistance/1000)
                
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
