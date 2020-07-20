//
//  PubNubViewController.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 12/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import PubNub
class PubNubViewController: UIViewController {
    
    var pubnub: PubNub!
    var client: PubNub!
    let channels = ["awesomeChannel"]
    let listener = SubscriptionListener(queue: .main)

    @IBOutlet weak var lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPubNub()
        
    }
    
    func setUpPubNub(){
        let config = PubNubConfiguration(publishKey: "demo", subscribeKey: "demo")
        client = PubNub(configuration: config)
        client.add(listener)
        client.subscribe(to: channels,withPresence: true)
    }
    
    @IBAction func publishBtn(_ sender: UIButton) {
        self.client.publish(channel: channels[0], message: "my_channel") { (status) in
            print("Status:-",status)
        }
        
        listener.didReceiveMessage = { (message) in
            print("Message:-",message)
        }
    }
}
