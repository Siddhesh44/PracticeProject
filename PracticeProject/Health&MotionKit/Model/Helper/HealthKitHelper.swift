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
}
