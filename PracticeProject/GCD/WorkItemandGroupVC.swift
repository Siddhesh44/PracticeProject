//
//  WorkItemandGroupVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 07/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import Dispatch

class WorkItemandGroupVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        useWorkItem()
        //        workItemFunc()
        dispatchGroup()
    }
    
    func useWorkItem() {
        
        var value = 10
        // create WorkItem
        let workItem = DispatchWorkItem {
            value += 5
        }
        
        // execute work item
        let queue = DispatchQueue.global()
        // queue.async(execute: workItem)
        queue.async {
            workItem.perform()
        }
        
        // notify main queue about completion of work item
        workItem.notify(queue: DispatchQueue.main) {
            print("value = ", value)
        }
    }
    
    func workItemFunc(){
        var workItem: DispatchWorkItem?
        workItem = DispatchWorkItem {
            for i in 1..<6 {
                guard let item = workItem, !item.isCancelled else {
                    print("cancelled")
                    break
                }
                sleep(1)
                print(String(i))
            }
        }
        
        workItem?.notify(queue: .main) {
            print("done")
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(4)) {
            workItem?.cancel()
        }
        DispatchQueue.main.async(execute: workItem!)
        
    }
    
    func dispatchGroup(){
        // 1 Create a group
        let dispatchGroup = DispatchGroup()
        let queue1 = DispatchQueue(label: "sampleQueue1")
        let queue2 = DispatchQueue(label: "sampleQueue2")
        let queue3 = DispatchQueue(label: "sampleQueue3")
        
        // 2 Put all queues into dispatchGroup
        queue1.async(group: dispatchGroup) {
            print("Queue1 complete.")
        }
        queue2.async(group: dispatchGroup) {
            print("Qqueue2 complete.")
        }
        queue3.async(group: dispatchGroup) {
            print("Queue3 complete.")
        }
        
        // 3 After the queues in dispatchGroup are all done, back to the main thread
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("All tasks are done.")
        }
    }
    
    func dispatchGroup1(){
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "Serial queue")
        let workItem = DispatchWorkItem {
            print("start")
            sleep(1)
            print("end")
        }
        
        
        queue.async(group: group) {
            print("group start")
            sleep(2)
            print("group end")
        }
        DispatchQueue.global().async(group: group, execute: workItem)
        
        // you can block your current queue and wait until the group is ready
        // a better way is to use a notification block instead of blocking
        //group.wait(timeout: .now() + .seconds(3))
        //print("done")
        
        group.notify(queue: .main) {
            print("done")
        }
    }
    
    
}
