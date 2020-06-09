//
//  TableInCellVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 05/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

protocol PassingData: class {
    func toInnerTable(data: [String])
}

class TableInCellVC: UIViewController {
    
    var tableData = TableData()
    var passingDataDeleagte: PassingData?
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        data = tableData.outerArr
        
        print("in main",data!)
    }
    
    func innerData(){
        passingDataDeleagte?.toInnerTable(data: tableData.innerArr)
    }
}


extension TableInCellVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OuterTableCell
        let passData = data![indexPath.row]
        print("data in cell",passData)
        cell.setData(data: passData)
        // cell.innerTableViewData = innerTabledata!
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
}



