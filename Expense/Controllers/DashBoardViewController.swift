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
    var delegetDelete : deletealldataDeleget?
    @IBOutlet var lblNoData: UILabel!
    
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
        let listButton = UIBarButtonItem(image: #imageLiteral(resourceName: "list"), style: .plain, target: self, action: #selector(DashBoardViewController.goReportView))
        listButton.titleTextAttributes(for: .normal)
        let moreButton  = UIBarButtonItem(image: #imageLiteral(resourceName: "more"), style: .plain, target: self, action:#selector(DashBoardViewController.more))
        moreButton.titleTextAttributes(for: .normal)
        self.navigationItem.rightBarButtonItems =  [moreButton,listButton]
    }
    
    func addExpense() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "dashboard_addexpenseId") as! AddExpenseTableViewController
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
        vc.onAddExpenseChange = { (_ view: AddExpenseTableViewController, _ managedObject : NSManagedObject) -> Void in
            self.arrayExpensedata.insert(managedObject, at: 0)
            self.hideLabel()
            OperationQueue.main.addOperation {
                self.tableViewData.reloadData()
            }
        }
    }
    
    @objc func more() {
        //  pdfviewId settingsId dayPickId
        
        let alertController = UIAlertController (title: "", message:"", preferredStyle: .actionSheet)
        let titleFont = [NSAttributedStringKey.font: fontPopins.Medium.of(size: 16)]
        let messageFont = [NSAttributedStringKey.font: fontPopins.Medium.of(size: 18)]
        let message = "Select Any Operation"
        let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        messageAttrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:message.count))
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let add = UIAlertAction(title: "Add Expense", style: .default, handler: { (actionSheetController) -> Void in
            self.addExpense()
        })
        
        let report = UIAlertAction(title: "Report", style: .default, handler: { (actionSheetController) -> Void in
            self.goReportView()
        })
      //  report.setValue(#imageLiteral(resourceName: "settings"), forKey: "image")
        let setting = UIAlertAction(title: "Settings", style: .default, handler: { (actionSheetController) -> Void in
            self.goSettingsView()
        })
       // setting.setValue(#imageLiteral(resourceName: "settings"), forKey: "image")

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(add)
       // alertController.addAction(report)
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
   @objc func goReportView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "dayPickId") as! DayPickTableViewController
        vc.delegate = self
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
    func hideLabel() {
        self.lblNoData.isHidden = true
        if self.arrayExpensedata.count == 0 {
            self.lblNoData.isHidden = false
        }
    }
}

// MARK: - ExpenseData Methods
extension DashBoardViewController : ExpenseDelegate {
    
    func getTodayExpense() -> Void {
        let string = DateUtil.stringFromDate(date:Date())
        let date = DateUtil.dateFromString(string: string)
        let managObjects =  dbHeloper.retriveDataWithDate(date: date)
        self.reloadTable(managedObj: managObjects)
    }
    
    func getExpenselist(startDate: String, endDate: String) {
        if startDate.isEmpty && endDate.isEmpty {
            self.createExpenseReport()
        } else if endDate.isEmpty {
            self.createExpenseReportWithSignleDate(startDate: startDate)
        } else {
            self.createExpenseReportWithRange(startDate: startDate, endDate: endDate)
        }
    }
    func createExpenseReport() {
        let managedObj = dbHeloper.retriveAllData()
        self.reloadTable(managedObj:managedObj)
    }
    func createExpenseReportWithSignleDate(startDate: String) {
        let date = DateUtil.dateFromString(string: startDate)
        let managedObj = dbHeloper.retriveDataWithDate(date: date)
        self.reloadTable(managedObj:managedObj)
    }
    func createExpenseReportWithRange(startDate: String, endDate: String) {
        let fromdate = DateUtil.dateFromString(string: startDate)
        let todate = DateUtil.dateFromString(string: endDate)
        let managedObj = dbHeloper.retriveDataWithTo_FromDate(startDate: todate, endDate: fromdate)
        self.reloadTable(managedObj:managedObj)
    }
    func reloadTable(managedObj : [NSManagedObject]) {
        self.arrayExpensedata.removeAll()
        arrayExpensedata = managedObj
        let descriptorGroupName: NSSortDescriptor = NSSortDescriptor(key: "date", ascending:false)
        let arryDataTemp = (arrayExpensedata as NSArray).sortedArray(using: [descriptorGroupName])
        arrayExpensedata.removeAll()
        arrayExpensedata = arryDataTemp as! [NSManagedObject]
        self.hideLabel()
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
                    self.hideLabel()
                    self.tableViewData.beginUpdates()
                    self.tableViewData.deleteRows(at: [indexPath], with: .automatic)
                    self.tableViewData.endUpdates()
                }
            }
        }
        return [delete]
    }
}
