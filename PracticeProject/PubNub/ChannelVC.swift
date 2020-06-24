//
//  ChannelVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 12/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import PubNub
import SwiftyJSON

class ChannelVC: UIViewController{
    
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typingSignalTxt: UILabel!
    
    var client: PubNub!
    let listener = SubscriptionListener(queue: .main)
    var messages: [String] = []
    //    var noMoreMessages = false
    //    var loadingMore = false
    var channelName = "Channel Name"
    var username = "Username"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTxt.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        print("######################")
        print("From Channel VC:-",username,channelName)
        print("######################")
        
        //Setting up our PubNub object!
        var config = PubNubConfiguration(publishKey: "pub-c-8077efe7-ae2d-4d46-b01a-8d0c0f8df966", subscribeKey: "sub-c-1f25c864-af0c-11ea-84e0-2a04d613294b")
        //Making each connection identifiable for future development
        config.uuid = UUID().uuidString
        client = PubNub(configuration: config)

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
        
        listener.didReceiveSubscription = { event in
            switch event {
            case let .signalReceived(signal):
                print("Signal Received from: ",signal.publisher!,"Signal",signal)
                if let userTypingActionSignal = signal.payload.stringOptional{
                    if let user = signal.publisher?.stringOptional{
                        print(user,"is",userTypingActionSignal)
                        var typingUserName: String = ""
                        if user == "29987843-D643-4846-AEC8-28C2A108EB4E"{
                            typingUserName = "Sid"
                        }
                        self.typingSignalTxt.text = "\(typingUserName) \(userTypingActionSignal)"
                    }
                }
            default:
                break
            }
        }
        client.add(listener)
        client.subscribe(to: [channelName],withPresence: true)
        
        
        loadLastMessages()
        
        listener.didReceiveMessage = { (message) in
            
            print("Received Message:-",message)
            
            let messageDate = message.timetoken.timetokenDate
            print("The message was sent at \(messageDate)")
            
            if(self.channelName == message.channel)
            {
                if let messagesFromUser = message.payload.stringOptional{
                    self.messages.append(messagesFromUser)
                }
                self.tableView.reloadData()
                
                let numberOfSections = self.tableView.numberOfSections
                let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
                let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
    
    //This function is called when this view initialy loads to populate the tableview
    func loadLastMessages()
    {
        
        client.fetchMessageHistory(for: [channelName], max: 25, start: nil, end: nil) { (result) in
            switch result{
            case let .success(response):
                print("######################")
                print("Successful History Fetch Response: \(response)")
                print("######################")
                
                if let response = response["My"]?.messages{
                    for m in response{
                        if let oldMessages = m.message.stringOptional {
                            print("messages",oldMessages)
                            self.messages.append(oldMessages)
                        }
                    }
                }
                
                self.tableView.reloadData()
                
                let numberOfSections = self.tableView.numberOfSections
                let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
                let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                
                
            case let .failure(error):
                print("######################")
                print("Failed History Fetch Response: \(error.localizedDescription)")
                print("######################")
            }
        }
    }
    
    
    func publishMessage() {
        if(messageTxt.text != "" || messageTxt.text != nil){
            let messageString: String = messageTxt.text!
            print("message publiing")
            client.publish(channel: channelName, message: messageString) { (status) in
                switch status {
                case let .success(response):
                    print("Handle successful Publish response: \(response)")
                case let .failure(error):
                    print("Handle response error: \(error.localizedDescription)")
                }
            }
            messageTxt.text = ""
        }
    }
    
    
    @IBAction func leaveBtn(_ sender: UIBarButtonItem) {
        client.unsubscribeAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        publishMessage()
    }
}

extension ChannelVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        client.signal(channel: channelName,message: "is typing...") { result in
            switch result {
            case let .success(response):
                print("Successful Response: \(response)")
            case let .failure(error):
                print("Failed Response: \(error.localizedDescription)")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}
extension ChannelVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Message Count:-",messages.count)
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCell
        print(messages[indexPath.row])
        cell.textLabel!.text = messages[indexPath.row]
        return cell
    }
}



