//
//  AddExpenseTableViewController.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/5/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import UIKit
import CoreData

class AddExpenseTableViewController: UITableViewController {

    @IBOutlet var btnInvoice: UIButton!
    @IBOutlet var imgPhoto: UIImageView!
    @IBOutlet var lblDescriptionCount: UILabel!
    @IBOutlet var txtvRemarks: UITextView!
    @IBOutlet weak var txtfPlace: UITextField!
    @IBOutlet var tableviewExpense: UITableView!
    @IBOutlet weak var txtfPalce: UITextField!
    @IBOutlet weak var txtfByWhome: UITextField!
    @IBOutlet weak var txtfdate: UITextField!
    @IBOutlet weak var txtfAmount: UITextField!
    @IBOutlet weak var txtfTitle: UITextField!
    var datePicker : UIDatePicker!
    var errorView = ErrorView()
    var onAddExpenseChange: ((_ view: AddExpenseTableViewController, _ managedObject : NSManagedObject) -> Void)?
    var descriptionCount = 200
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.addSubview(errorView.getView())
        self.tableviewExpense.isHidden = false
        self.funNavigationBarItems()
        
    }
    
    @IBAction func addRemarks(_ sender: Any) {
        txtvRemarks.becomeFirstResponder()
    }
    
    // MARK: - Navigation Bar
    func funNavigationBarItems() {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        self.title = "Add Expense"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: fontPopins.Regular.of(size: 18)]
        
        let backButton : UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action:#selector(AddNewExpenseViewController.funBack))
        self.navigationItem.leftBarButtonItem = backButton
        
        
        let saveButton : UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "save"), style: .plain, target: self, action:#selector(AddNewExpenseViewController.funSave))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func funBack() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    func funSave() -> Void {
        
        UIView.animate(withDuration: 3.0, delay: 3.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.errorView.removeView()
                        
        },completion:nil)
        
        if (txtfTitle.text!.isEmpty) && (txtfdate.text!.isEmpty) && (txtfAmount.text!.isEmpty) && (txtvRemarks.text!.isEmpty) && (txtfByWhome.text!.isEmpty) && (txtfPlace.text!.isEmpty) {
            self.showError(message: "Please enter all details")
            return
        }
        guard let title = txtfTitle.text, !title.isEmpty else {
            self.showError(message: "Please enter Title")
            return
        }
        guard let date = txtfdate.text, !date.isEmpty else {
            self.showError(message: "Please enter Date")
            return
        }
        guard let amount = txtfAmount.text, !amount.isEmpty  else {
            self.showError(message: "Please enter Amount")
            return
        }
        guard let bywhome = txtfByWhome.text, !bywhome.isEmpty else {
            self.showError(message: "Please enter ByWhome")
            return
        }
        guard let place = txtfPalce.text, !place.isEmpty else {
            self.showError(message: "Please enter Place")
            return
        }
        
        let time = DateUtil.milliscond()
        if imgPhoto.image == nil {
            AlertMessage.showWithCancel(title: "", message: "You haven't uploaded invoice receipt\nAre you sure you want to add expense?" , OK: {
                 self.saveExpense(title: title, date: date, amount: Float(amount)! , bywhome: bywhome, place: place, remarks: self.txtvRemarks.text!, imagename: "",time: time)
            }, Cancel: {
            })
            return
        }
        self.saveExpense(title: title, date: date, amount: Float(amount)! , bywhome: bywhome, place: place, remarks: self.txtvRemarks.text!, imagename:"\(time).png",time: time)
    }
    
    func saveExpense(title :String, date : String, amount : Float, bywhome : String, place : String, remarks : String, imagename : String, time : Int64) {
            let dateValue = DateUtil.dateFromString(string: date)
            let managedSavedObj =  dbHeloper.savedata(title: title, date: dateValue, amount: amount, bywhome: bywhome, remarks: remarks,place: place, imagename: imagename, time: time)
            self.onAddExpenseChange?(self, managedSavedObj)
            AlertMessage.showWithCancel(title: "", message: "Expense added successfully\nDo you want add more?", OK: {
                self.imgPhoto.image = nil
                self.btnInvoice.setTitle("+ Upload invoice recept", for: .normal)
                self.txtvRemarks.text = ""
                self.txtfdate.text = ""
                self.txtfPalce.text = ""
                self.txtfTitle.text = ""
                self.txtfAmount.text = ""
                self.txtfByWhome.text = ""
            }, Cancel: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    
    func showError(message : String) -> Void {
        UIView.animate(withDuration: 0.5, delay: 0.1,
                       options: UIViewAnimationOptions.transitionFlipFromTop,
                       animations: {
                        self.errorView.showView(title: message)
        },completion:nil)
    }
    
    //MARK: - TextField Deleget Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddExpenseTableViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 3.0, delay: 3.0,
                       options: UIViewAnimationOptions.transitionFlipFromTop,
                       animations: {
                        self.errorView.removeView()
        },completion:nil)
        if textField.tag == 2 { self.dateTimeForm() }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    func dateTimeForm() -> Void {
        let customView:UIView = UIView (frame: CGRect(x: 0, y: 180, width: Expense.screenWidth, height: 180))
        customView.backgroundColor = colorType.headerColor.color
        customView.layer.borderWidth = 0.0
        
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: Expense.screenWidth, height: 180))
        self.datePicker.timeZone = TimeZone(identifier: "GMT")
        self.datePicker.addTarget(self, action: #selector(AddExpenseTableViewController.handleDatePicker(_:)), for: UIControlEvents.valueChanged)
        self.datePicker.setValue(colorType.titleColor.color, forKeyPath: "textColor")
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        self.datePicker.layer.borderWidth = 0.0
        self.datePicker.layer.borderColor = UIColor.clear.cgColor
        self.datePicker.date = Date()
        customView.addSubview(datePicker)
        txtfdate.text = DateUtil.stringFromDate(date: self.datePicker.date)
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackOpaque
        doneToolbar.barTintColor = colorType.headerColor.color
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton:UIButton = UIButton (frame: CGRect(x: Expense.screenWidth - 80, y: 5, width: 60, height: 30))
        doneButton.setTitle("Done", for: UIControlState())
        doneButton.addTarget(self, action: #selector(AddExpenseTableViewController.donedatePickerSelected),
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
        
        txtfdate.inputAccessoryView = doneToolbar
        txtfdate.inputView = customView
    }
    
    @objc func datePickerValueChanged (datePicker: UIDatePicker) {
        let date = datePicker.date
        txtfdate.text = DateUtil.stringFromDate(date: date)
    }
    
    // MARK: -  DatePicker  Call
    func handleDatePicker(_ sender: UIDatePicker) {
        let date = sender.date
        txtfdate.text = DateUtil.stringFromDate(date: date)
    }
    
    func donedatePickerSelected ()  {
        self.txtfdate.resignFirstResponder()
    }
}

extension AddExpenseTableViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        descriptionCount = 200 - textView.text.count
        self.lblDescriptionCount.text = "\(descriptionCount)"
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        return changedText.count <= 200
        
    }
}

extension AddExpenseTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func uploadInvoice(_ sender: Any) {
        photoActionSheet.UploadPhotos(photoLibary: {
            self.gallery()
        }, camera: {
            self.camera()
        })
    }
    
    func gallery() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
    }
    func camera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType =  UIImagePickerControllerSourceType.camera
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imgPhoto.image = image
            self.imgPhoto.contentMode = .center
            self.btnInvoice.setTitle("", for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
