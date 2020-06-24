//
//  PubNubVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 11/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import PubNub

class PubNubVC: UIViewController {
    
    
    var pubnub: PubNub!
    let channels = ["awesomeChannel"]
    let listener = SubscriptionListener(queue: .main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add listener event callbacks
        listener.didReceiveSubscription = { event in
            switch event {
            case let .messageReceived(message):
                print("#####################")
                print("Message Received: \(message) Publisher: \(message.publisher ?? "defaultUUID")")
            case let .connectionStatusChanged(status):
                print("#####################")
                print("Status Received: \(status)")
            case let .presenceChanged(presence):
                print("#####################")
                print("Presence Received: \(presence)")
            case let .subscribeError(error):
                print("#####################")
                print("Subscription Error \(error)")
            default:
                break
            }
        }
                
        pubnub.add(listener)
        
        pubnub.subscribe(to: channels, withPresence: true)
        
        listener.didReceiveStatus = { status in
                   switch status {
                   case .success(let connection):
                       if connection == .connected {
                           self.pubnub.publish(channel: self.channels[0], message: "Hello, PubNub Swift!") { result in
                               print("#####################")
                               print(result.map { "Publish Response at \($0.timetoken.timetokenDate)" })
                           }
                       }
                   case .failure(let error):
                       print("#####################")
                       print("Status Error: \(error.localizedDescription)")
                   }
               }
               
               listener.didReceiveMessage = { message in
                   print("#####################")
                   print("[Message]: \(message)")
               }
    }
    
    
}
