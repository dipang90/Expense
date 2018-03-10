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
    var delegetDelet : deletealldataDeleget?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.funNavigationBarItems()
        delegetDelet = self
        tableViewData.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")
        tableViewData.tableFooterView = UIView()
        tableViewData.delegate = self
        tableViewData.dataSource = self
        
        var dateString = "01-02-2010"
        var dateFormatter = DateFormatter()
        // this is imporant - we set our input date format to match our input string
        dateFormatter.dateFormat = "dd-MM-yyyy"
        // voila!
        var dateFromString = dateFormatter.date(from: dateString)
        print("Formater -> \(dateFromString)")
        self.getTodayExpense()
        
        let strToday = dateUtility.currentDateWithFormate(formate: "dd/MM/yyyy", timeZone: "GMT", locale: "")
        let today = dateUtility.dateFromString(formate: strGlobalDateFormate, timeZone: "GMT", locale: "", strDate: strToday)
        
        dbHeloper.retriveTodayData(date: today)
        
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
        
        let alertController = UIAlertController (title: "", message:"Select any operation", preferredStyle: .actionSheet)
        let report = UIAlertAction(title: "Report", style: .default, handler: { (actionSheetController) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "dayPickId") as! DayPickTableViewController
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated:true, completion: nil)
        })
        report.setValue(#imageLiteral(resourceName: "settings"), forKey: "image")
        let setting = UIAlertAction(title: "Settings", style: .default, handler: { (actionSheetController) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "settingsId") as! SettingsTableViewController
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated:true, completion: nil)
        })
        setting.setValue(#imageLiteral(resourceName: "settings"), forKey: "image")
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(report)
        alertController.addAction(setting)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getTodayExpense() -> Void {
        
        arrayExpensedata.removeAll()
        let strToday = dateUtility.currentDateWithFormate(formate: "dd/MM/yyyy", timeZone: "GMT", locale: "")
        let today = dateUtility.dateFromString(formate: strGlobalDateFormate, timeZone: "GMT", locale: "", strDate: strToday)
         let DateTemp11 = dateUtility.dateFromString(formate: strGlobalDateFormate, timeZone: "GMT", locale: "", strDate:  "30/12/2017")
        let managObjects =  dbHeloper.retriveDataWithDate(date: today)
       // let managObjects = dbHeloper.retriveDataWithTo_FromDate(startDate: DateTemp, endDate: DateTemp11)
        arrayExpensedata = managObjects
        let descriptorGroupName: NSSortDescriptor = NSSortDescriptor(key: "date", ascending:false)
        let arryDataTemp = (arrayExpensedata as NSArray) .sortedArray(using: [descriptorGroupName])
        arrayExpensedata.removeAll()
        arrayExpensedata = arryDataTemp as! [NSManagedObject]
        arrayExpensSectionKey.removeAll()
         self.tableViewData.reloadData()
        
      /*  for trans in managObjects {
            
            let date = trans.value(forKey: "date") as! Date
            
            let strDate = dateUtility.stringFromDate(formate: strGlobalDateFormate, timeZone: "GMT", locale: "", strDate: date)
            
            print("Trans -> \(strDate)")
            
          //  if !arrayExpensSectionKey.contains(date) {
                
                arrayExpensSectionKey.append(date)
           // }
        }
        
       // let sortedNames = arrayExpensSectionKey.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedDescending }

        
       // arrayExpensSectionKey.removeAll()
      //  arrayExpensSectionKey = sortedNames
        
        for strval in arrayExpensSectionKey {
            
            let datePredicate = NSPredicate(format: "date == %@", strval as Date as CVarArg)
            
            let filetr:Array =  self.arrayExpensSectionKey.filter { datePredicate.evaluate(with: $0)  }
            
            if filetr.count > 0 {
                
                print("Arrray - > \(filetr)")
            }
        } */
        
        print("arrayExpensSectionKey -> \(arrayExpensSectionKey)")
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
        let strDate = dateUtility.stringFromDate(formate: strGlobalDateFormate, timeZone: "GMT", locale: "", strDate: managedObj.value(forKey: "date") as! Date)
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
