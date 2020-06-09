//
//  SemaphoreVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 08/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import Dispatch

class SemaphoreVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        semaphore1()
    }
    
    func semaphore(){
        let semaphore = DispatchSemaphore(value: 1)
        
        DispatchQueue.global().sync {
            print("kid 1 wait")
            semaphore.wait()
            print("kid 1 is playing")
            sleep(3)
            semaphore.signal()
            print("kid 1 done playing")
        }
        DispatchQueue.global().sync {
            print("kid 2 wait")
            semaphore.wait()
            print("kid 2 is playing")
            sleep(2)
            semaphore.signal()
            print("kid 2 done playing")
        }
        DispatchQueue.global().sync {
            print("kid 3 wait")
            semaphore.wait()
            print("kid 3 is playing")
            sleep(1)
            semaphore.signal()
            print("kid 3 done playing")
        }
    }
    
    func semaphore1(){
        let queue = DispatchQueue(label: "com.gcd.myQueue", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 3)
        for i in 0 ..< 15 {
            queue.async {
                let songNumber = i + 1
                semaphore.wait()
                print("Downloading song", songNumber)
                sleep(2) // Download take ~2 sec each
                print("Downloaded song", songNumber)
                semaphore.signal()
            }
        }
    }
    
}
