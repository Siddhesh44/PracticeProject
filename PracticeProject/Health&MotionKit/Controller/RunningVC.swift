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
import StoreKit
import MediaPlayer
import CoreGraphics

class RunningVC: UIViewController {
    
    let commonFunction = CommonFunctions()
    let healthKitHelper = HealthKitHelper()
    
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
    
    var isHasRequriedPermissions = false
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var stopRunBtn: UIButton!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var bpmLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    
    @IBOutlet var animatedView: UIView!
    @IBOutlet weak var animatingView: AnimationVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedView.frame = UIScreen.main.bounds
        self.view.addSubview(animatedView)
        
        Timer.scheduledTimer(timeInterval:0.5, target: self, selector: #selector(RunningVC.firstTimeOut), userInfo: nil, repeats: false)
        
        Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(RunningVC.secondTimeOut), userInfo: nil, repeats: false)
    }
    @objc func firstTimeOut(){
        UIView.animate(withDuration: 1, animations: {
            self.animatingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.animatingView.drawText(textToDraw: .text1)
            self.animatingView.transform = CGAffineTransform(scaleX: -2, y: -1)
        }) { (true) in
            self.secondAnimation()
        }
    }
    @objc func secondTimeOut(){
        
        self.animatedView.removeFromSuperview()
        self.navigationController?.navigationBar.isHidden = true
        
        self.stopRunBtn.circularButton()
        self.stopRunBtn.addShadow()
        
        self.healthKitHelper.healthKitDelegate = self
        
        if self.isHasRequriedPermissions{
            print("Got All Permissions")
            self.healthKitHelper.getWeigntDataFromHealthApp()
            self.altimeterSetUp()
            self.setUpLocationManager()
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
            self.createTimer()
        }
    }
    
    func secondAnimation(){
        UIView.animate(withDuration: 1, animations: {
            self.animatingView.transform = CGAffineTransform(scaleX: -2, y: -1)
            self.animatingView.drawText(textToDraw: .text2)
            self.animatingView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (true) in
            self.thirdAnimation()
        }
    }
    func thirdAnimation(){
        UIView.animate(withDuration: 1.5, animations: {
            self.animatingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.animatingView.drawText(textToDraw: .text3)
            self.animatingView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
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
        locationManager.distanceFilter = 5
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
    
    // MARK: Event Actions
    
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
        nextVC.locationsArray = locationsArray
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

//Mark: Extensions

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
        let locationStatus = commonFunction.checkLocationStatus()
        if locationStatus == true{
            setUpLocationManager()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
}

// MARK: Extensions

extension RunningVC: HealthKitDelegates{
    func getWeight(weight: Double) {
        userWeight = weight
    }
    
    func didGetResults(success: Bool, result: String) { }
}

