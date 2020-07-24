//
//  HealthKitHelper.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 24/07/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import Foundation
import HealthKit

protocol HealthKitDelegates: class {
    func didGetResults(success: Bool,result: String)
    func getWeight(weight: Double)
}
class HealthKitHelper {
    
    weak var healthKitDelegate: HealthKitDelegates?
    
    let healthStore = HKHealthStore()
    
    func requestAuthorizationFromHealthKit(toWrite: Set<HKSampleType>,toRead: Set<HKObjectType>){
        healthStore.requestAuthorization(toShare: toWrite, read: toRead) { (success, error) in
            if success {
                self.healthKitDelegate?.didGetResults(success: true, result: "Permission Granted")
            }else{
                if let error = error{
                    self.healthKitDelegate?.didGetResults(success: false, result: "Error Occured:- \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getWeigntDataFromHealthApp(){
        
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
                        self.healthKitDelegate?.getWeight(weight: data.quantity.doubleValue(for: unit))
                    } else{
                        let data = result[0] as! HKQuantitySample
                        let unit = HKUnit(from: "lb")
                        print("Weight of user is:- ",data.quantity.doubleValue(for: unit))
                        self.healthKitDelegate?.getWeight(weight: data.quantity.doubleValue(for: unit))
                    }
                }else{
                    if let error = error{
                        self.healthKitDelegate?.didGetResults(success: false, result: "Error Occured while getting user Weight:- \(error.localizedDescription)")
                    }
                }
            }
        }
        
        healthStore.execute(weightQuery)
    }
    
    func saveRunData(time: Int,distance: Double,caloriesBurned: Int){
        let runTime = time
        let runDistance = distance
        let caloriesBurned = caloriesBurned
        
        guard let exerciseMinutes = HKSampleType.quantityType(forIdentifier: .appleExerciseTime) else{
            return
        }
        guard let runningDistance = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else{
            return
        }
        guard let activeEnergy = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else{
            return
        }
        let minutes = HKQuantity(unit: .minute(), doubleValue: Double(Int(runTime/60)))
        let distance = HKQuantity(unit: .mile(), doubleValue: runDistance / 1.609)
        let calories = HKQuantity(unit: .kilocalorie(), doubleValue: Double(Int(caloriesBurned)))
        
        let minutesSample = HKQuantitySample(type: exerciseMinutes, quantity: minutes, start: NSDate() as Date, end: NSDate() as Date)
        let distanceSample = HKQuantitySample(type: runningDistance, quantity: distance, start: NSDate() as Date, end: NSDate() as Date)
        let caloriesSample = HKQuantitySample(type: activeEnergy, quantity: calories, start: NSDate() as Date, end: NSDate() as Date)
        
        
        healthStore.save(minutesSample) { (result, error) in
            if result{
                self.healthKitDelegate?.didGetResults(success: true, result: "exercise time saved")
            }else{
                if let error = error{
                    self.healthKitDelegate?.didGetResults(success: false, result: "Error Occured while saving exercise time:- \(error.localizedDescription)")
                }
            }
        }
        healthStore.save(distanceSample) { (result, error) in
            if result{
                self.healthKitDelegate?.didGetResults(success: true, result: "distance runned saved")
            }else{
                if let error = error{
                    self.healthKitDelegate?.didGetResults(success: false, result: "Error Occured while saving distance runned:- \(error.localizedDescription)")
                }
            }
        }
        healthStore.save(caloriesSample) { (result, error) in
            if result{
                self.healthKitDelegate?.didGetResults(success: true, result: "Active Energy Burned saved")
            }else{
                if let error = error{
                    self.healthKitDelegate?.didGetResults(success: false, result: "Error Occured while saving Active Energy Burned:- \(error.localizedDescription)")
                }            }
        }
    }
}
