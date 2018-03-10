//
//  Helper.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/2/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import Foundation
import UIKit

class alertView {
    
    class func alert (_ message : String) {
        OperationQueue.main.addOperation {
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}



/* class dateUtility {
    
    class func currentDateWithFormate(formate : String, timeZone : String, locale : String) -> String {
        let date = Date()
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(identifier: timeZone)
        formatter.locale = Locale(identifier: locale)
        return formatter.string(from: date)
    }
    
    class func dateFromString(formate : String, timeZone : String, locale : String, strDate : String) -> Date {
        
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = strGlobalDateFormate
        formatter.timeZone = TimeZone(identifier: timeZone)
        let myDate = formatter.date(from: strDate)!
        let somedateString = formatter.string(from: myDate)
        return formatter.date(from: somedateString)!
    }
    
    class func stringFromDate(formate : String, timeZone : String, locale : String, strDate : Date) -> String {
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = strGlobalDateFormate
        formatter.timeZone = TimeZone(identifier: timeZone)
        return formatter.string(from: strDate)
    }

    
    
    func getDateFromMiliscond(miliscondDate : Date, formate : String, timeZone : String, locale : String) -> String {
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(identifier: timeZone)
        formatter.locale = Locale(identifier: locale)
        return formatter.string(from: miliscondDate)
        
    }
    
    
    class func isCurrentDate(dateValue : String, formate : String) -> Bool {
        
        if !dateValue.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = formate
            let someDate = formatter.date(from: dateValue)!
            //Get calendar
            let calendar = Calendar.current
            //Get just MM/dd/yyyy from current date
            let flags : NSCalendar.Unit = [.day, .month, .year]
            let components = (calendar as NSCalendar).components(flags, from: Date())
            //Convert to NSDate
            let today = calendar.date(from: components)
            if (someDate as NSDate).timeIntervalSince(today!).sign == .minus {
                //someDate is berofe than today
                return true
            } else {
                return false
                //someDate is equal or after than today
            }
        }
        return false
    }
}

struct DateUtility {
    static func getDate(date : Date, formate : String, timeZone : String, locale : String) -> String {
        
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(identifier: timeZone)
        formatter.locale = Locale(identifier: locale)
        return formatter.string(from: date)
    }
    
    static func dateFromString(formate : String, timeZone : String, locale : String, strDate : String) -> Date {
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = strGlobalDateFormate
        formatter.timeZone = TimeZone(identifier: timeZone)
        let myDate = formatter.date(from: strDate)!
        let somedateString = formatter.string(from: myDate)
        return formatter.date(from: somedateString)!
    }
    
    
    static func stringFromDate(formate : String, timeZone : String, locale : String, strDate : Date) -> String {
        
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = strGlobalDateFormate
        formatter.timeZone = TimeZone(identifier: timeZone)
        
        return formatter.string(from: strDate)
    }
    
    static func StringToDate(stringDate : String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = strGlobalDateFormate
        let date = formatter.date(from: stringDate)
        return date!
    }
    
    static func compareDate(startDate : String, endDate : String) -> Bool {
        if !startDate.isEmpty && !endDate.isEmpty {
            if startDate == endDate {
                return true
            }
            let srart = self.StringToDate(stringDate: startDate)
            let end = self.StringToDate(stringDate: endDate)
            if (srart.compare(end)) == .orderedDescending {
                return true
            }
        }
        return false
    }
    
    
    func getDateFromMiliscond(miliscondDate : Date, formate : String, timeZone : String, locale : String) -> String {
        
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(identifier: timeZone)
        formatter.locale = Locale(identifier: locale)
        return formatter.string(from: miliscondDate)
        
    }
    
    static func isCurrentDate(dateValue : String, formate : String) -> Bool {
        
        if !dateValue.isEmpty {
            
            let formatter = DateFormatter()
            formatter.dateFormat = formate
            
            let someDate = formatter.date(from: dateValue)!
            
            //Get calendar
            let calendar = Calendar.current
            //Get just MM/dd/yyyy from current date
            let flags : NSCalendar.Unit = [.day, .month, .year]
            let components = (calendar as NSCalendar).components(flags, from: Date())
            //Convert to NSDate
            let today = calendar.date(from: components)
            
            if (someDate as NSDate).timeIntervalSince(today!).sign == .minus {
                //someDate is berofe than today
                return true
                
            } else {
                return false
                //someDate is equal or after than today
            }
        }
        
        return false
    }
}


*/
