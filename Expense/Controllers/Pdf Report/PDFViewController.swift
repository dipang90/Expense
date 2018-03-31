//
//  PDFViewController.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/14/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import UIKit
import CoreData

class PDFViewController: UIViewController {

    @IBOutlet weak var webViewPdf: UIWebView!
    var invoiceComposer: InvoiceComposer!
    var saveButton : UIBarButtonItem!
    var managedObj : [NSManagedObject]!
    var HTMLContent: String!
    var fromDate = ""
    var toDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.funNavigationBarItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if fromDate.isEmpty {
            self.createExpenseReport()
        } else if toDate.isEmpty {
            self.createExpenseReportWithSignleDate()
        } else {
            self.createExpenseReportWithRange()
        }
    }
    
    // MARK: - Navigation Bar
    func funNavigationBarItems() {
        self.title = "PDF Report"
        let backButton : UIBarButtonItem = UIBarButtonItem(image : #imageLiteral(resourceName: "back"), style: .plain, target: self, action:#selector(PDFViewController.funBack))
        self.navigationItem.leftBarButtonItem = backButton
        saveButton  = UIBarButtonItem(image : #imageLiteral(resourceName: "share"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(PDFViewController.exportToPDF))
    }

    @objc func funBack() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func exportToPDF() -> Void {
        if self.managedObj.count > 0 {
            HTMLContent = ""
            let numbers : [NSManagedObject] = managedObj
            let chunkSize = 21
            let chunks = stride(from: 0, to: numbers.count, by: chunkSize).map {
                Array(numbers[$0..<min($0 + chunkSize, numbers.count)])
            }
            var totalExpense : Float = 0.0
            var allItems = ""
            print("Chunks -> \(chunks)")
            for objManag in chunks {
                let htmlContent = invoiceComposer.renderInvoice(managedObj: objManag)
                if HTMLContent.isEmpty {
                    HTMLContent = htmlContent.0
                    totalExpense = totalExpense + htmlContent.1
                    allItems = htmlContent.2
                } else {
                    HTMLContent = "\(HTMLContent.trim())$v\(htmlContent.0.trim())"
                    totalExpense = totalExpense + htmlContent.1
                    allItems = htmlContent.2
                }
            }
            print("HTMLContent -> \(HTMLContent)")
            let filePath =   invoiceComposer.createPDF(HTMLContent: HTMLContent)
            let url = NSURL.fileURL(withPath: filePath)
            let activityViewController = UIActivityViewController(activityItems: [url] , applicationActivities: nil)
            self.present(activityViewController,
                                  animated: true,
                                  completion: nil)
            
            /*
             {
             let url = URL(string: self.urlString)
             let shareAll = [self.message , url!] as [Any]
             let vc = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
             vc.popoverPresentationController?.sourceView = self.view
             self.present(vc, animated: true, completion: nil)
             }
             */
        }
    }
    
    func createExpenseReport() {
        let managedObj = dbHeloper.retriveAllData()
        self.getManageedObject(managedObj:managedObj)
    }
    
    func createExpenseReportWithSignleDate() {
        let date = DateUtil.dateFromString(string: fromDate)
        let managedObj = dbHeloper.retriveDataWithDate(date: date)
        self.getManageedObject(managedObj:managedObj)
    }
    
    func createExpenseReportWithRange() {
         let fromdate = DateUtil.dateFromString(string: fromDate)
         let todate = DateUtil.dateFromString(string: toDate)
         let managedObj = dbHeloper.retriveDataWithTo_FromDate(startDate: todate, endDate: fromdate)
        self.getManageedObject(managedObj:managedObj)
    }
    
    func getManageedObject(managedObj : [NSManagedObject]) {
        if managedObj.count > 0 {
            self.navigationItem.rightBarButtonItem = saveButton
            self.managedObj = managedObj
            invoiceComposer = InvoiceComposer()
            let invoiceHTML = invoiceComposer.renderInvoice(managedObj: managedObj)
            webViewPdf.loadHTMLString(invoiceHTML.0, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

