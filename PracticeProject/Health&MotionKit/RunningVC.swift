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
    typealias kg = Double
    
    
    var runningDistance: km = 0.0
    var avgPace = 0.0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        stopRunBtn.layer.cornerRadius = stopRunBtn.frame.size.width / 2
        stopRunBtn.layer.masksToBounds = true
        
        if isHasRequriedPermissions{
            getDataFromHealthApp()
        }
        checkLocationServices()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createTimer()
    }
    
    func altimeterSetUp(){
        altimeter.startRelativeAltitudeUpdates(to: .main) { (data, error) in
            if error != nil { print("Error in getting data",error!) } else{
                print("Altitude Change",data?.relativeAltitude.stringValue)
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
            checkLocationAuthorization()
        } else{
            print("Check Location Services Unavailable")
        }
    }
    
    func checkLocationAuthorization(){
        
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
                altimeterSetUp()
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
    
    func getDataFromHealthApp(){
        
        guard let weightSample = HKWorkoutType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        let weightQuery = HKSampleQuery(sampleType: weightSample, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (sample, result, error) in
            print("weight sample",sample)
            if !result!.isEmpty{
                print(result!)
                let last = (result!.count - 1)
                let data = result![last] as! HKQuantitySample
                let unit = HKUnit(from: "lb")
                print("Weight of user is:- ",data.quantity.doubleValue(for: unit))
                self.userWeight = data.quantity.doubleValue(for: unit)
            }else{
                print("error",error!.localizedDescription)
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
        altimeter.stopRelativeAltitudeUpdates()
        let storyBoard : UIStoryboard = UIStoryboard(name: "HandMKit", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "RunDetailsVC") as! RunDetailsVC
        
        nextVC.runTime = timeLbl.text
        nextVC.runningDistance = runningDistance / 1000
        nextVC.elevation = elevation
        nextVC.avgPace = avgPace
        nextVC.userWeight = userWeight
        nextVC.counter = counter
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}


extension RunningVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationsArray.append(contentsOf: locations)
        
        if locationsArray.count > 0 {

            for location in locationsArray{

               
                runningDistance += location.distance(from: self.locationsArray.last!)

                elevation = locationsArray.last?.altitude

                avgPace = location.distance(from: self.locationsArray.last!)/(location.timestamp.timeIntervalSince(self.locationsArray.last!.timestamp))

            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
