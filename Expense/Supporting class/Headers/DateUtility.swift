//
//  DateUtility.swift
//  Expense
//
//  Created by Dipang Sheth on 10/03/18.
//  Copyright © 2018 Dipang Home. All rights reserved.
//

import Foundation

struct DateUtil {
    static var formate = "dd MMM, yyyy"
    
    static func dateFormate() -> DateFormatter {
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }
    
    static func milliscond() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    static func stringFromDate(date : Date) -> String {
        let formate = self.dateFormate()
        return formate.string(from: date)
    }
    
    static func dateFromString(string : String) -> Date {
        let formate = self.dateFormate()
      //  return formate.date(from: string)!
        
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        formatter.timeZone = TimeZone(identifier: "")
        let myDate = formatter.date(from: string)!
        let somedateString = formatter.string(from: myDate)
        return formatter.date(from: somedateString)!
        
    }
    
    static func compareDate(startDate : String, endDate : String) -> Bool {
        if !startDate.isEmpty && !endDate.isEmpty {
            if startDate == endDate {
                return true
            }
            let srart = self.dateFromString(string:startDate)
            let end = self.dateFromString(string:endDate)
            if (srart.compare(end)) == .orderedDescending {
                return true
            }
        }
        return false
    }
    
    static func dateFromMiliscond (millisecond : Int) -> Date {
        let date = NSDate(timeIntervalSince1970: TimeInterval(millisecond)/1000)
        return date as Date
    }
    
    static func stringFromMiliscond(millisecond : Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(millisecond)/1000)
        let formate = self.dateFormate()
        return formate.string(from: date as Date)
        
    }
    
    static func isCurrentDate(dateValue : String) -> Bool {
        if !dateValue.isEmpty {
            let formate = self.dateFormate()
            let someDate = formate.date(from: dateValue)!
            let calendar = Calendar.current
            let flags : NSCalendar.Unit = [.day, .month, .year]
            let components = (calendar as NSCalendar).components(flags, from: Date())
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
