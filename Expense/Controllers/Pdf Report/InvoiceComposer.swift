//
//  InvoiceComposer.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 23/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import CoreData

class InvoiceComposer: NSObject {

    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "expenseReport", ofType: "html")
    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "title", ofType: "html")
    let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "spendby", ofType: "html")
    let dueDate = ""
    let paymentMethod = "Wire Transfer"
    let logoImageURL = "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png"
    var invoiceNumber: String!
    var pdfFilename: String!
     var pdfData = NSMutableData()
    
    override init() {
        super.init()
    }
    
    
    func renderInvoice(managedObj : [NSManagedObject]) -> (htmlContain: String, total: Float, allItems : String) {
        // Store the invoice number for future use.
        self.invoiceNumber = ""
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            // The logo image.
            
            // Invoice number.
            
            // Invoice date.
            
            // Due date (we leave it blank by default).
            
            // Sender info.
            
            // Recipient info.
            
            // Payment method.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PAYMENT_METHOD#", with: "")
            // Total amount.
            // The invoice items will be added by using a loop.
            var allItems = ""
            // For all the items except for the last one we'll use the "single_item.html" template.
            // For the last one we'll use the "last_item.html" template.  
            
            
            var totalExpense : Float = 0.0
            var indexCount = 0
            for i in 0..<managedObj.count {
                indexCount = indexCount + 1
                let obj = managedObj[i]
                var itemHTMLContent: String!
                // Determine the proper template file.
                if i != managedObj.count - 1 {
                    itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                }
                else {
                    itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
                }
                // Replace the description and price placeholders with the actual values.
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_NO#", with: "\((indexCount)))")
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_TITLE#", with: String(obj.value(forKey: "title") as! String)!)
                 itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_SPENDBY#", with: String(obj.value(forKey: "bywhome") as! String)!)
                let strDate = DateUtil.stringFromDate(date: obj.value(forKey: "date") as! Date)
                 itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_DATE#", with: strDate)
                // Format each item's price as a currency value.
                totalExpense = totalExpense + Float(obj.value(forKey: "amount") as! Float)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with: String(obj.value(forKey: "amount") as! Float))
                // Add the item's HTML code to the general items string.
                allItems += itemHTMLContent
            }
            let largeNumber = totalExpense
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.locale = Locale(identifier: "en_IN")
            let formattedStr: NSString = numberFormatter.string(from: NSNumber(value: Double(largeNumber)))! as NSString
             HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: formattedStr as String)
            // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            // The HTML code is ready.
            print("Html code -> \(HTMLContent)")
            return (HTMLContent, totalExpense, allItems)
        }
        catch {
            print("Unable to open and use HTML template files.")
            
            /*
 
             .invoice-box{
             max-width:1000px;
             margin:20px;
             padding:10px;
             border:1px solid #eee;
             /*box-shadow:0 0 10px rgba(0, 0, 0, .15); */
             font-size:16px;
             line-height:20px;
             font-family:'Poppins-Regular';
             color:#555;
             }
             
             .invoice-box table{
             width:100%;
             line-height:inherit;
             text-align:left;
             }
             
             .invoice-box table td{
             padding:10px;
             vertical-align:top;
             }
             
             .invoice-box table tr td:nth-child(7){
             text-align:right;
             }
             
             .invoice-box table tr td:nth-child(1){
             text-align:right;
             max-width:10px;
             }
             
             .invoice-box table tr td:nth-child(3){
             max-width:160px;
             }
             
             .invoice-box table tr td:nth-child(4){
             max-width:300px;
             }
             
             .invoice-box table tr td:nth-child(5){
             max-width:120px;
             }
             
             .invoice-box table tr td:nth-child(7){
             max-width:100px;
             }
             
             .invoice-box table tr.top table td{
             padding-bottom:20px;
             }
             
             .invoice-box table tr.top table td.title{
             font-size:40px;
             line-height:45px;
             color:#333;
             }
             
             .invoice-box table tr.information table td{
             
             padding-bottom:40px;
             }
             
             .invoice-box table tr.heading td{
             background:#eee;
             border-bottom:1px solid #ddd;
             font-weight:bold;
             }
             
             .invoice-box table tr.details td{
             padding-bottom:40px;
             }
             
             .invoice-box table tr.item td{
             border-bottom:1px solid #eee;
             }
             
             .invoice-box table tr.item.last td{
             border-bottom:none;
             }
             
             .invoice-box table tr.total td:nth-child(7){
             border-top:2px solid #eee;
             font-weight:bold;
             }
             
 
  */
            
            
        }
        
        return ("",0.0, "")
    }
    
    
    func renderReportForPDF(managedObj : [NSManagedObject], countIndex : Int) -> String! {
        // Store the invoice number for future use.
        self.invoiceNumber = ""
        
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            // The logo image.
            
            // Invoice number.
            
            // Invoice date.
            
            // Due date (we leave it blank by default).
            
            // Sender info.
            
            // Recipient info.
            
            // Payment method.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PAYMENT_METHOD#", with: "")
            
            // Total amount. 
            
            // The invoice items will be added by using a loop.
            var allItems = ""
            
            // For all the items except for the last one we'll use the "single_item.html" template.
            // For the last one we'll use the "last_item.html" template.
            var totalExpense : Float = 0.0
            
            for i in 0..<countIndex {
                let obj = managedObj[i]
                var itemHTMLContent: String!
                // Determine the proper template file.
                if i != managedObj.count - 1 {
                    itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                }
                else {
                    itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
                }
                
                // Replace the description and price placeholders with the actual values.
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_NO#", with: "\((i+1)))")
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_TITLE#", with: String(obj.value(forKey: "title") as! String)!)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_SPENDBY#", with: String(obj.value(forKey: "bywhome") as! String)!)
                let strDate = DateUtil.stringFromDate(date: obj.value(forKey: "date") as! Date)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_DATE#", with: strDate)
                // Format each item's price as a currency value.
                totalExpense = totalExpense + Float(obj.value(forKey: "amount") as! Float)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with: String(obj.value(forKey: "amount") as! Float))
                // Add the item's HTML code to the general items string.
                allItems += itemHTMLContent
            }
            
            
            let largeNumber = totalExpense
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.locale = Locale(identifier: "en_IN")
            let formattedStr: NSString = numberFormatter.string(from: NSNumber(value: Double(largeNumber)))! as NSString
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: formattedStr as String)
            
            // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            // The HTML code is ready.
            print("Html code -> \(HTMLContent)")
            
            return HTMLContent
            
        }
        catch {
            
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }

    
    func createPDF(HTMLContent: String) -> String {
        
        let Content = HTMLContent.replacingOccurrences(of: "$v", with: "<p><p><p>").trim()
        let fmt = UIMarkupTextPrintFormatter(markupText: Content)
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0) //841.8
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 848) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        // 4. Create PDF context and draw
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        render.prepare(forDrawingPages: NSMakeRange(0, render.numberOfPages))
        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i-1, in: bounds)
        }
        UIGraphicsEndPDFContext();
        // 5. Save PDF file
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice.pdf"
        pdfData.write(toFile: pdfFilename, atomically: true)
        print(pdfFilename)
        return pdfFilename
        
    }
    
    func makePDF() -> Void {
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice.pdf"
        pdfData.write(toFile: pdfFilename, atomically: true)
        print(pdfFilename)
    }
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice.pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
        print(pdfFilename)
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for i in 1...printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i-1, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        return data
    }
}
