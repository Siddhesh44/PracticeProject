//
//  OuterTableCell.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 05/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

class OuterTableCell: UITableViewCell {
    
    @IBOutlet weak var innerTableView: UITableView!
    @IBOutlet weak var outerLbl: UILabel!
    
    var tableInCellVC = TableInCellVC()
    
    var innerTableViewData = [String]()
    
    var delegate = TableInCellVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        innerTableView.delegate = self
        innerTableView.dataSource = self
        
        tableInCellVC.passingDataDeleagte = self
        tableInCellVC.innerData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(data: String){
        outerLbl.text = data
    }
}

extension OuterTableCell: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return innerTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "innerCell", for: indexPath) as! InnerTableCell
        let innerData = innerTableViewData[indexPath.row]
        print("data in innerCell",innerData)
        cell.setInnerCellData(data: innerData)
        return cell
    }
}


extension OuterTableCell: PassingData{
    func toInnerTable(data: [String]) {
        print("Inner Table Data",data)
        innerTableViewData = data
    }
}


