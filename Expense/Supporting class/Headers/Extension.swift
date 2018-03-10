//
//  Extension.swift
//  Expense
//
//  Created by Dipang Sheth on 10/03/18.
//  Copyright © 2018 Dipang Home. All rights reserved.
//

import Foundation

extension DateFormatter {
    func dateFormat(formate : String)  {
        let formatter : DateFormatter  = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.locale = Locale.current
    }
}

extension String {
    func trim() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
