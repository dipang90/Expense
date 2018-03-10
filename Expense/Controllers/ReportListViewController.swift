//
//  ReportListViewController.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/2/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import UIKit

class ReportListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewReportList: UITableView!
    
    var arrayReportList  = [AnyObject]()
    
     var objReportList : expenseObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         tableViewReportList.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")
        
        tableViewReportList.tableFooterView = UIView()
        
        tableViewReportList.delegate = self
        tableViewReportList.dataSource = self
        
        arrayReportList.append(objReportList)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - tableView Deleget Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 78
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayReportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        
        cell.selectionStyle = .default
        
        tableView.separatorStyle = .singleLine
        
        let obj = arrayReportList[indexPath.row] as! expenseObject
        
        
        cell.lblTitle.text = obj.strObjTitle as String
        
        cell.lblAmount.text = String(obj.floatObjAmount as Float)
        
        cell.lblDate.text = obj.strObjDate as String
        
        cell.lblByWhome.text = obj.strObjBywhome as String
        
        return cell
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
