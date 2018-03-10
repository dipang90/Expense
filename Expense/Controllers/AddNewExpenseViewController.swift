//
//  AddNewExpenseViewController.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/1/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddNewExpenseViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtvRemarks: UITextView!
    @IBOutlet weak var txtAmount: HoshiTextField!
    @IBOutlet weak var txtByWhome: HoshiTextField!
    @IBOutlet weak var txtDate: HoshiTextField!
    @IBOutlet weak var txtTitle: HoshiTextField!
    
    var objAddexpense : expenseObject!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.funNavigationBarItems()
        
        txtvRemarks.layer.masksToBounds = true
        txtvRemarks.layer.cornerRadius = 4.0
        txtvRemarks.layer.borderWidth = 1.0
        txtvRemarks.layer.borderColor = colorType.borderColor.color.cgColor
        
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation Bar
    func funNavigationBarItems() {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationItem.hidesBackButton = true
        
        self.title = "Add Expense"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: fontLato.Regular.rawValue, size: 18)!]
        
        let backButton : UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style:.plain, target: self, action:#selector(AddNewExpenseViewController.funBack))
        backButton.titleTextAttributes(for: .normal)
        self.navigationItem.leftBarButtonItem = backButton
        
        
        let saveButton : UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "save"), style: .plain, target: self, action:#selector(AddNewExpenseViewController.funSave))
        saveButton.titleTextAttributes(for: .normal)
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func funBack() -> Void {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func funSave() -> Void {
        
        if (txtTitle.text!.isEmpty) && (txtDate.text!.isEmpty) && (txtAmount.text!.isEmpty) && (txtvRemarks.text!.isEmpty) && (txtByWhome.text!.isEmpty) {
            
            alertView.alert("Please fill all the details")
            
            return
            
        } else {
            
            if (txtTitle.text!.isEmpty) {
                
                alertView.alert("Please fill Title")
                
                return
            }
            
            if (txtAmount.text!.isEmpty) {
                
                alertView.alert("Please fill Amount")
                
                return
            }
            
            if (txtByWhome.text!.isEmpty) {
                
                alertView.alert("Please fill Bywhome")
                
                return
            }
            
            if (txtDate.text!.isEmpty) {
                
                alertView.alert("Please fill Date")
                
                return
            }
            
            if (txtvRemarks.text!.isEmpty) {
                
                alertView.alert("Please fill Remarks")
                
                return
            }
            
            let isSaveData =  dbHeloper.savedata(title: txtTitle.text!, date: Date(), amount: Float(txtAmount.text!)!, bywhome: txtByWhome.text!, remarks: txtvRemarks.text!,place: "")
            
            print("Save Data -> \(isSaveData)")
            
            objAddexpense = expenseObject()
            
            objAddexpense.strObjTitle = txtTitle.text!
            objAddexpense.strObjDate = txtDate.text!
            objAddexpense.strObjeRemarks = txtvRemarks.text!
            objAddexpense.strObjBywhome = txtByWhome.text!
            objAddexpense.floatObjAmount = Float(txtAmount.text!)
            
            OperationQueue.main.addOperation {
                
            self.performSegue(withIdentifier: "addnewexpense_reportlist_segue", sender: self)
            }
            
            
        }
        
    }
    
    //MARK: - TextField Deleget Method
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("TextField did begin editing method called")
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        print("TextField did end editing method called\(textField.text)")
        
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        print("TextField should begin editing method called")
        
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true;
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("TextField should return method called")
        
        textField.resignFirstResponder();
        return true;
    }
    
    //MARK: - TextView Deleget Methods...
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            
        textView.resignFirstResponder()
            
        return true
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
            
        textView.resignFirstResponder()
            
    }
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            
        if(text == "\n") {
                
            textView.resignFirstResponder()
                
            return false
        }
            
        return true
    }
        
    func textViewShouldReturn(_ textView: UITextView!) -> Bool {
        
        textView.resignFirstResponder()
            
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addnewexpense_reportlist_segue" {
            
            let reportView = segue.destination as! ReportListViewController
            
            reportView.objReportList = self.objAddexpense
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
