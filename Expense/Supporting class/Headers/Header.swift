//
//  Header.swift
//  Home Inspect
//
//  Created by iOS Developer 03 on 8/30/16.
//  Copyright © 2016 DipangiOS. All rights reserved.
//

import Foundation
import UIKit

//Variables 

var strGlobalUserid : String!
var strGlobalUtokenID : String!

var screenWidth : CGFloat = 0

var screenHeight : CGFloat = 0

var strGlobalReportId = ""

var strGlobalReortName = ""

var strGlobalDateFormate  = "dd/MM/yyyy"

// MARK: - Print Method Which only excute in Debug time.
func  Printlog(_ message: String, function: String = #function) -> Void {
    
    print("\(message): \(function)")
}



enum fontLato : String {
    
    case Regular = "Lato-Regular"
    
    case LightItalic = "Lato-LightItalic"
    
    case Italic = "Lato-Italic"
    
    case Bold = "Lato-Bold"
    
    case BoldItalic = "Lato-BoldItalic"
    
    case Black = "Lato-Black"
    
    case Light = "Lato-Light"
    
    case BlackItalic = "Lato-BlackItalic"
    

}

enum fontRoboto : String {
    
    case Regular = "Roboto-Regular"
    
    case Black = "Roboto-Black"
    
    case Light = "Roboto-Light"
    
    case BoldItalic = "Roboto-BoldItalic"
    
    case LightItalic = "Roboto-LightItalic"
    
    case Thin = "Roboto-Thin"
    
    case MediumItalic = "Roboto-MediumItalic"
    
    case Medium = "Roboto-Medium"
    
    case Bold = "Roboto-Bold"
    
    case BlackItalic = "Roboto-BlackItalic"
    
    case Italic = "Roboto-Italic"
    
    case ThinItalic = "Roboto-ThinItalic"
    
}

enum fontPopins : String {
    
    case Regular = "Poppins-Regular"
    
    case SemiBold = "Poppins-SemiBold"
    
    case Medium = "Poppins-Medium"
    
    case Light = "Poppins-Light"
    
    case Bold =  "Poppins-Bold"
    
    func of(size: CGFloat) -> UIFont {
        
        return UIFont(name: self.rawValue, size: size)!
    }
}

enum colorType {
    
    case titleColor
    case borderColor
    case headerColor
    case sectionColor
    case backgroundColor
    
    var color: UIColor {
        switch self {
        case .titleColor: return UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        case .borderColor: return UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        case .headerColor: return UIColor(red: 0/255.0, green: 159/255.0, blue: 218/255.0, alpha: 1.0)
        case .sectionColor:return UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        case .backgroundColor:return UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            
            // case .red: return UIColor(red: 255.0/255.0, green: 82.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            
            //UIColor(red: 3.0/255.0, green: 128.0/255.0, blue: 209.0/255.0, alpha: 1.0)
            
        }
    }
}


extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}




