//
//  DayPickTableViewController.swift
//  Expense
//
//  Created by iOS Developer 03 on 2/26/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import UIKit

protocol ExpenseDelegate {
    func getExpenselist(startDate : String, endDate : String)
}

class DayPickTableViewController: UITableViewController {

    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var txtfToDate: UITextField!
    @IBOutlet var txtfFromDate: UITextField!
    @IBOutlet var tableDays: UITableView!
    var datePicker : UIDatePicker!
    var fromDate = ""
    var toDate = ""
    var delegate : ExpenseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     self.funNavigationBarItems()
     btnCreate.isEnabled = false
     btnCreate.alpha = 0.5
    }
    
    // MARK: - Navigation Bar
    func funNavigationBarItems() {
        self.title = "Pick day "
        let backButton : UIBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "close"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.funBack))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
   @objc func funBack() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data sourc
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2  {
            return 1
        }
        return 2
    }    
    //dayPickId
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let string = DateUtil.stringFromDate(date:Date())
                let date = DateUtil.dateFromString(string: string)
                fromDate = DateUtil.stringFromDate(date: date)
                toDate = ""
                self.goPdfView(startDate: fromDate, endDate: toDate)
            }
            if indexPath.row == 1 {
                let string = DateUtil.stringFromDate(date:Date())
                let date = DateUtil.dateFromString(string: string)
                let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date)
                fromDate =  DateUtil.stringFromDate(date: yesterday!)
                toDate = ""
                self.goPdfView(startDate: fromDate, endDate: toDate)
            }
        }
        
        if indexPath.section == 2 {
            toDate = ""
            fromDate = ""
            self.goPdfView(startDate: fromDate, endDate: toDate)
        }
    }
    
    @IBAction func create(_ sender: Any) {
        fromDate = txtfFromDate.text!
        toDate = txtfToDate.text!
        let isEndDateHigh = DateUtil.compareDate(startDate: fromDate, endDate: toDate)
        if !isEndDateHigh {
            ValidationError.show(title: "", message: "End date must be lower than Begining date")
            return
        } else {
            self.goPdfView(startDate: fromDate, endDate: toDate)
        }
    }
    
    func goPdfView(startDate: String, endDate: String)  {
        self.dismiss(animated: true) {
            self.delegate?.getExpenselist(startDate: startDate, endDate: endDate)
        }
       // self.performSegue(withIdentifier: "dayPick_pdfView", sender: self)
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "dayPick_pdfView" {
            let objView = segue.destination as! PDFViewController
            objView.fromDate = self.fromDate
            objView.toDate = self.toDate
        }
    }
}


extension DayPickTableViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dateTimeForm(textfield: textField)
    }
    
    func dateTimeForm(textfield : UITextField) -> Void {
        let customView:UIView = UIView (frame: CGRect(x: 0, y: 180, width: Expense.screenWidth, height: 180))
        customView.backgroundColor = colorType.headerColor.color
        customView.layer.borderWidth = 0.0
        
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: Expense.screenWidth, height: 180))
        self.datePicker.timeZone = TimeZone(identifier: "GMT")
        self.datePicker.addTarget(self, action: #selector(AddExpenseTableViewController.handleDatePicker(_:)), for: UIControlEvents.valueChanged)
        self.datePicker.setValue(colorType.titleColor.color, forKeyPath: "textColor")
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        self.datePicker.layer.borderWidth = 1.0
        self.datePicker.layer.borderColor = UIColor.clear.cgColor
        self.datePicker.tag = textfield.tag
        self.datePicker.date = Date()
        self.datePicker.addTarget(self, action: #selector(DayPickTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        customView.addSubview(datePicker)
        if datePicker.tag == 0 {
            txtfFromDate.text = DateUtil.stringFromDate(date: self.datePicker.date)
        }
        if datePicker.tag == 1 {
            txtfToDate.text = DateUtil.stringFromDate(date: self.datePicker.date)
        }
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackOpaque
        doneToolbar.barTintColor = colorType.headerColor.color
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton:UIButton = UIButton (frame: CGRect(x: Expense.screenWidth - 80, y: 5, width: 60, height: 30))
        doneButton.setTitle("Done", for: UIControlState())
        doneButton.addTarget(self, action: #selector(DayPickTableViewController.donedatePickerSelected),
                             for: UIControlEvents.touchUpInside)
        doneButton.titleLabel?.textColor = UIColor.white
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 2.0
        doneButton.titleLabel?.font = fontPopins.Regular.of(size: 18)
        
        let barButton = UIBarButtonItem()
        barButton.customView = doneButton
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(barButton)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textfield.inputAccessoryView = doneToolbar
        textfield.inputView = customView
    }
        // MARK: -  DatePicker  Call
    
    
    @objc func datePickerValueChanged (datePicker: UIDatePicker) {
        let date = datePicker.date
        if datePicker.tag == 0 {
            txtfFromDate.text =  DateUtil.stringFromDate(date: date)
        }
        if datePicker.tag == 1 {
            txtfToDate.text = DateUtil.stringFromDate(date: date)
        }
    }
    
    func handleDatePicker(_ sender: UIDatePicker) {
        if sender.tag == 0 {
            txtfFromDate.text = DateUtil.stringFromDate(date: sender.date)
        }
        if sender.tag == 1 {
            txtfToDate.text = DateUtil.stringFromDate(date: sender.date)
        }
    }
    
    @objc func donedatePickerSelected ()  {
        self.txtfFromDate.resignFirstResponder()
        self.txtfToDate.resignFirstResponder()
        if !(txtfToDate.text?.isEmpty)! && !(txtfFromDate.text?.isEmpty)! {
            btnCreate.isEnabled = true
            btnCreate.alpha = 1.0
        }
    }
    @IBAction func pickCustomReport(_ sender: Any) {
       
    }
}
