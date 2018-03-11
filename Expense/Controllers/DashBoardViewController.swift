//
//  DashBoardViewController.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/1/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import UIKit
import CoreData

class DashBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, deletealldataDeleget {

    @IBOutlet weak var tableViewData: UITableView!
    var arrayExpensedata = [NSManagedObject]()
    var arrayExpensSectionKey = [Date]()
    var delegetDelete : deletealldataDeleget?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.funNavigationBarItems()
        delegetDelete = self
        tableViewData.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")
        tableViewData.tableFooterView = UIView()
        tableViewData.delegate = self
        tableViewData.dataSource = self
        self.getTodayExpense()
        
        let n =  Int64(Date().timeIntervalSince1970)
        
       let m =  Int64(Date().timeIntervalSince1970 * 1000)
        print("Time -> \(m) --- \(n)")
    }
    
    // MARK: - Navigation Bar
    func funNavigationBarItems() {
        self.title = "Dashboard"
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(DashBoardViewController.addExpense))
        addButton.titleTextAttributes(for: .normal)
        let moreButton  = UIBarButtonItem(image: #imageLiteral(resourceName: "more"), style: .plain, target: self, action:#selector(DashBoardViewController.more))
        moreButton.titleTextAttributes(for: .normal)
        self.navigationItem.rightBarButtonItems =  [moreButton,addButton]
    }
    
    func addExpense() -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "dashboard_addexpenseId") as! AddExpenseTableViewController
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
        vc.onAddExpenseChange = { (_ view: AddExpenseTableViewController, _ managedObject : NSManagedObject) -> Void in
            self.arrayExpensedata.insert(managedObject, at: 0)
            OperationQueue.main.addOperation {
                self.tableViewData.reloadData()
            }
        }
    }
    
    func more() -> Void {
        //  pdfviewId settingsId dayPickId
        
        let alertController = UIAlertController (title: "", message:"", preferredStyle: .actionSheet)
        let titleFont = [NSFontAttributeName: fontPopins.Medium.of(size: 16)]
        let messageFont = [NSFontAttributeName: fontPopins.Medium.of(size: 18)]
        let message = "Select Any Operation"
        let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        messageAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let report = UIAlertAction(title: "Report", style: .default, handler: { (actionSheetController) -> Void in
            self.goReportView()
        })
      //  report.setValue(#imageLiteral(resourceName: "settings"), forKey: "image")
        let setting = UIAlertAction(title: "Settings", style: .default, handler: { (actionSheetController) -> Void in
            self.goSettingsView()
        })
       // setting.setValue(#imageLiteral(resourceName: "settings"), forKey: "image")

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(report)
        alertController.addAction(setting)
        alertController.addAction(cancel)
        
        alertController.view.tintColor = colorType.headerColor.color
        alertController.view.backgroundColor = UIColor.gray
        alertController.view.layer.cornerRadius = 40
        self.present(alertController, animated: true, completion: nil)
    }
    
    func goSettingsView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settingsId") as! SettingsTableViewController
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    func goReportView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "dayPickId") as! DayPickTableViewController
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
    }
    
    func deleteAlldata() {
        arrayExpensedata.removeAll()
        OperationQueue.main.addOperation {
            self.tableViewData.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dashboard_addexpense-segue" {
         //   let addExpense = segue.destination as! AddExpenseTableViewController
         //   let navController = UINavigationController(rootViewController: addExpense)
          //  navController.presentedViewController?.performSegue(withIdentifier: "dashboard_addexpense", sender: self)
           // self.present(navController, animated:true, completion: nil)
            //if you need send something to destnation View Controller
            //vc.delegate = self
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
// MARK: - ExpenseData Methods
extension DashBoardViewController {
    
}

// MARK: - ExpenseData Methods
extension DashBoardViewController {
    
    func getTodayExpense() -> Void {
        let managObjects =  dbHeloper.retriveDataWithDate(date: Date())
        arrayExpensedata = managObjects
        let descriptorGroupName: NSSortDescriptor = NSSortDescriptor(key: "date", ascending:false)
        let arryDataTemp = (arrayExpensedata as NSArray).sortedArray(using: [descriptorGroupName])
        arrayExpensedata.removeAll()
        arrayExpensedata = arryDataTemp as! [NSManagedObject]
        arrayExpensSectionKey.removeAll()
        self.tableViewData.reloadData()
    }
}

// MARK: - tableView Deleget Methods
extension DashBoardViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayExpensedata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        cell.selectionStyle = .default
        tableView.separatorStyle = .singleLine
        let managedObj = arrayExpensedata[indexPath.row]
        cell.lblTitle.text! = managedObj.value(forKey: "title") as! String
        let strDate = DateUtil.stringFromDate(date: managedObj.value(forKey: "date") as! Date)
        cell.lblDate.text!  = strDate
        cell.lblAmount.text! = String(managedObj.value(forKey: "amount") as! Float)
        cell.lblByWhome.text! = "\(managedObj.value(forKey: "bywhome") as! String), \(managedObj.value(forKey: "place") as! String)"
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            let managedObj = self.arrayExpensedata[indexPath.row]
            let isDelete = dbHeloper.deleteRow(managedObject: managedObj)
            if isDelete {
                self.arrayExpensedata.remove(at: indexPath.row)
                OperationQueue.main.addOperation {
                    self.tableViewData.beginUpdates()
                    self.tableViewData.deleteRows(at: [indexPath], with: .automatic)
                    self.tableViewData.endUpdates()
                }
            }
        }
        return [delete]
    }
}
