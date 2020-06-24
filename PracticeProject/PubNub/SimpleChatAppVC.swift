//
//  SimpleChatAppVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 12/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import PubNub

class SimpleChatAppVC: UIViewController {
    
    @IBOutlet weak var usernameLbl: UITextField!
    @IBOutlet weak var channelnameLbl: UITextField!
    
    
    var pubnub: PubNub!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func connectBtn(_ sender: UIButton) {
        print("pressed")
        let storyBoard : UIStoryboard = UIStoryboard(name: "PubNubStory", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "ChannelVC") as! ChannelVC
        
        var username = ""
        var channel = ""
        
        if usernameLbl.text == ""{
            username = "user"
        }else{
            username = usernameLbl.text ?? "User"
        }
        if channelnameLbl.text == ""{
            channel = "my"
        }else{
            channel = channelnameLbl.text ?? "My"
        }
        print(username,channel)
        nextVC.username = username
        nextVC.channelName = channel
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
