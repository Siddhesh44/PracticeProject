//
//  GCDExampleVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 07/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import Alamofire

class GCDExampleVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl.text = "BackGround Task Ongoing"
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
            AF.download("https://httpbin.org/image/png").responseData { (response) in
                if let data = response.value{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
        
    }
}
