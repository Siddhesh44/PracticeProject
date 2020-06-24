//
//  ActivityViewController.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 10/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let string = "Hello, world!"
    let url = URL(string: "https://nshipster.com")!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ActivityViewController.shareImage))
    }
    
    @objc func shareImage(){
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
        present(activityController,animated: true)
    }
    
    @IBAction func onTapActivityBtn(_ sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [string], applicationActivities: [])
        activityController.excludedActivityTypes = [.addToReadingList]
        present(activityController,animated: true)
        
        activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?,completed: Bool,arrayReturnedItems: [Any]?, error: Error?) in
            if completed{
                print("completed")
                return
            }
            else{
                print("cancel")
            }
            if let Error = error{
                print(Error.localizedDescription)
            }
        }
    }
    
    
}
