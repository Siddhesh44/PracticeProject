//
//  InnerTableCell.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 05/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

class InnerTableCell: UITableViewCell {
    
    @IBOutlet weak var innerCellLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setInnerCellData(data: String){
        innerCellLbl.text = data
    }
}


