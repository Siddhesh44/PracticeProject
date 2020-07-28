//
//  RunDetailsVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 15/07/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import HealthKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import StoreKit
import MediaPlayer  


class RunDetailsVC: UIViewController {
    
    let healthKitHelper = HealthKitHelper()
    
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var resumeBtn: UIButton!
    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var calLbl: UILabel!
    @IBOutlet weak var elevationLbl: UILabel!
    @IBOutlet weak var bpmLbl: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    var googleView = GMSMapView()
    
    typealias km = Double
    typealias cal = Double
    typealias time = String
    typealias kg = Double
    
    var runningDistance: km?
    var runTime: String?
    var elevation: km?
    var caloriesBurned: cal = 0.0
    var bpm: Double?
    var userWeight: kg?
    var counter: Int?
    var locationsArray = [CLLocation]()
    
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        healthKitHelper.healthKitDelegate = self
        
        
        let screenHeight = UIScreen.main.bounds.height
        print("Screen height",screenHeight,screenHeight/3)
        let constant = screenHeight / 3
        mapHeight.constant = constant
        self.view.layoutIfNeeded()
        
        navigationController?.navigationBar.isHidden = true
        
        finishBtn.circularButton()
        resumeBtn.circularButton()
        
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
        let camera = GMSCameraPosition.camera(withLatitude: (locationsArray.first?.coordinate.latitude)!, longitude: (locationsArray.first?.coordinate.longitude)!, zoom: 12.0)
        googleView = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        self.mapView.addSubview(googleView)
        
        drawPath()
        
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
        
        print(MET)
        let time = (Double(counter!) / 3600)
        print("time",time)
        caloriesBurned = (time) * (MET * userWeight!)
        print(caloriesBurned)
        calLbl.text = "\(Int(caloriesBurned))"
        
    }
    
    func drawPath(){
        let path = GMSMutablePath()
        for location in self.locationsArray{
            path.add(location.coordinate)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2.0
        polyline.geodesic = true
        polyline.strokeColor = UIColor.blue
        polyline.map = self.googleView
        
        let bounds = GMSCoordinateBounds(path: path)
        self.googleView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    // MARK: Event Actions
    
    @IBAction func resumeRunBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishRunBtn(_ sender: UIButton) {
        
        healthKitHelper.saveRunData(time: counter!, distance: runningDistance!, caloriesBurned: Int(caloriesBurned))
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "HandMKit", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "JetSetRunVC") as! JetSetRunVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension RunDetailsVC: HealthKitDelegates{
    func didGetResults(success: Bool, result: String) {
        print(result)
    }
    
    func getWeight(weight: Double) { }
}



