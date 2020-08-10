//
//  TableViewVCViewController.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 05/06/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

class TableViewVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let sections = ["A","B","C","D"]
    let items = [["A1","A2","A3",],["B1","B2","B3",],["C1","C2","C3",],["D1","D2","D3",]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TableViewVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Footer"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: AnimationVC, forSection section: Int) {
        view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
        return 100
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: AnimationVC, forSection section: Int) {
        view.tintColor = UIColor.blue
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Alert", message: "Section \(sections[indexPath.section]) Row \(items[indexPath.section][indexPath.row])", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController,animated: true,completion: nil)
    }
    
    
}
