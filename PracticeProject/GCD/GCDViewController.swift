//
//  GCDViewController.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 06/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import Dispatch

class GCDViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Concurrent vs Serial
        
       

        let serialQueue = DispatchQueue(label: "serial.queue")
        
        //        serialQueue.async {
        //            print("Task 1 started")
        //            print("Task 1 finished")
        //        }
        //        serialQueue.async {
        //            print("Task 2 started")
        //            print("Task 2 finished")
        //        }
        
        let concurrentQueue = DispatchQueue(label: "concurrent.queue", attributes: .concurrent)
        
        concurrentQueue.async {
            print("Task 1 started")
            print("Task 1 finished")
        }
        concurrentQueue.async {
            print("Task 2 started")
            print("Task 2 finished")
        }
        
        syncWork()
        print("##########")
        asyncWork()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            //this code will be executed only after 2 seconds have been passed
            print("Delay in execution")
        }
        
        DispatchQueue.concurrentPerform(iterations: 5) { (i) in
            print("concurrentPerform",i)
        }
        
    }
    
    // Sync vs Async
    
    func syncWork(){
        let northZone = DispatchQueue(label: "perform_task_with_team_north")
        let southZone = DispatchQueue(label: "perform_task_with_team_south")
        
        northZone.sync {
            for numer in 1...3{ print("North \(numer)")}
        }
        southZone.sync {
            for numer in 1...3{ print("South \(numer)") }
        }
    }
    
    func asyncWork(){
        let northZone = DispatchQueue(label: "perform_task_with_team_north")
        let southZone = DispatchQueue(label: "perform_task_with_team_south")
        
        northZone.async {
            for numer in 1...3{ print("North \(numer)") }
        }
        southZone.async {
            for numer in 1...3{ print("South \(numer)") }
        }
    }
    
    
    
}
