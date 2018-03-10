//
//  SettingsTableViewController.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/13/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import UIKit

protocol deletealldataDeleget {
    func deleteAlldata()
}

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var lblTotalExpense: UILabel!
    @IBOutlet weak var lblTtoalRows: UILabel!
    var deletealldataDeleget: deletealldataDeleget?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.funNavigationBarItems()
        let managedObj = dbHeloper.retriveAllData()
        lblTtoalRows.text! = "\(managedObj.count) Row"
        if managedObj.count > 1 {
             lblTtoalRows.text! = "\(managedObj.count) Rows"
        }
        var totalExpense : Float = 0.0
        for obj in managedObj {
            totalExpense = totalExpense + Float(obj.value(forKey: "amount") as! Float)
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.maximumFractionDigits = 0
        let val = numberFormatter.string(from: NSNumber(value: totalExpense))! as String
        lblTotalExpense.text! = "\(val) Inr"
    }
    
    // MARK: - Navigation Bar
    func funNavigationBarItems() {
        self.title = "Settings"
        let backButton : UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(SettingsTableViewController.funBack))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func funBack() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - Table view data source
extension SettingsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        }
        return 2
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 0 {
            OperationQueue.main.addOperation{
                let alertController = UIAlertController(title: "", message: "All data will be erased.\nAre you sure you want to delete all data?", preferredStyle: .alert)
                // add an action (button)
                let CancelAction = UIAlertAction(title:"Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
                }
                let DeleteAction = UIAlertAction(title:"Delete", style: .destructive) { (alert: UIAlertAction!) -> Void in
                    let isDelete = dbHeloper.deleteAllData()
                    if isDelete {
                        self.deletealldataDeleget?.deleteAlldata()
                        self.lblTotalExpense.text! = "0.0 Inr"
                        self.lblTtoalRows.text! = "0 Rows"
                    }
                }
                alertController.addAction(CancelAction)
                alertController.addAction(DeleteAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
