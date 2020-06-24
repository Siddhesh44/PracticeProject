//
//  customActivityController.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 10/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

class customActivityController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func perfromActivity(_ sender: UIButton) {
        
        let customItem = ActivityViewCustomActivity(title: "Tap me!", image: #imageLiteral(resourceName: "AnimeX_778965")) { sharedItems in
            guard let sharedStrings = sharedItems as? [String] else { return }
            
            for string in sharedStrings {
                print("Here's the string: \(string)")
            }
        }
        
        let customItem1 = ActivityViewCustomActivity(title: "Tap me again!", image: #imageLiteral(resourceName: "AnimeX_778965")) { sharedItems in
            guard let sharedStrings = sharedItems as? [String] else { return }
            
            for string in sharedStrings {
                print("Here's the string: \(string)")
            }
        }
        
        let string = ["Hello, custom activity!"]
        let ac = UIActivityViewController(activityItems: [string,imageView.image!], applicationActivities: [customItem,customItem1])
        ac.excludedActivityTypes = [.postToFacebook]
        present(ac, animated: true)
        
        ac.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?,iscompleted: Bool,arrayReturnedItems: [Any]?, error: Error?) in
            if iscompleted{
                print("Completed")
                return
            }else{
                print("Cancelled")
            }
            if let Error = error{
                print("Error:",Error.localizedDescription)
            }
        }
    }
    
}
