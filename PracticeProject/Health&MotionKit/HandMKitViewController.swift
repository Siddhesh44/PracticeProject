//
//  HandMKitViewController.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 14/07/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import HealthKit

class HandMKitViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
    }
    
    func authorizeHealthKit(){
        
        let writeTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)])
        
        let readTypes = Set([HKSampleType.quantityType(forIdentifier: .stepCount),
                             HKSampleType.characteristicType(forIdentifier: .dateOfBirth),
                             HKSampleType.characteristicType(forIdentifier: .biologicalSex)])
        
        if !HKHealthStore.isHealthDataAvailable(){
            print("Error Occured")
            return
        }
        
        healthStore.requestAuthorization(toShare: writeTypes as? Set<HKSampleType>, read: readTypes as? Set<HKObjectType>) { (success, error) in
            if success {
                print("Permission Granted",success)
                self.writeHealthData()
                self.getHealthData()
            }else{
                print("Error Occured",error!.localizedDescription)
            }
        }
    }
    
    func getHealthData(){
        guard let stepSample = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        guard let heightSample = HKSampleType.quantityType(forIdentifier: .height) else {
            return
        }
        
        guard let dateOfBirthSample = HKSampleType.characteristicType(forIdentifier: .dateOfBirth) else {
            return
        }
        
        let stepQuery = HKSampleQuery(sampleType: stepSample, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (sample, result, error) in
            print("sample",sample)
            if !result!.isEmpty{
                print(result)
                let data = result![0] as! HKQuantitySample
                let unit = HKUnit(from: "count")
                print("Step Count",data.quantity.doubleValue(for: unit))
            }else{
                print("error",error!.localizedDescription)
            }
        }
        
        let heightQuery = HKSampleQuery(sampleType: heightSample, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (sample, result, error) in
            print("sample",sample)
            if !result!.isEmpty{
                print(result)
            }else{
                print("error",error!.localizedDescription)
            }
        }
        
        do { if let dateOfBirth = try healthStore.dateOfBirthComponents().date {
            print("Date of birth",dateOfBirth)
            }
        } catch let error{
            print("error fetching Date of Birth",error)
        }
        
        do { let  gender = try healthStore.biologicalSex()
            switch gender.biologicalSex {
            case .male:
                print("Gender: Male")
            case .notSet:
                print("Gender: Not Set")
            case .female:
                print("Gender: Female")
            case .other:
                print("Gender: Other")
            @unknown default:
                break
            }
        } catch let error{
            print("error fetching Date of Birth",error)
        }
        
        
        healthStore.execute(stepQuery)
    }
    
    func writeHealthData(){
        let step = Double(25)
        
        guard let type = HKSampleType.quantityType(forIdentifier: .stepCount) else{
            return
        }
        
        let quantity = HKQuantity(unit: .count(), doubleValue: step)
        let sample = HKQuantitySample(type: type, quantity: quantity, start: NSDate() as Date, end: NSDate() as Date)
        
        healthStore.save(sample) { (result, error) in
            if result{
                print("Step Count Saved",result)
            }else{
                print("error while saving Steps",error!.localizedDescription)
            }
        }
    }
}
