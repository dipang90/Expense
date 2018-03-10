//
//  ErrorView.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/7/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import Foundation
import UIKit

class ErrorView {
    var view: UIView!
    var lblMessage : UILabel!
    init() {
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: Expense.screenWidth, height: 30))
        self.view.backgroundColor = UIColor.red
        lblMessage = UILabel()
        lblMessage.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20 , height: 20)
        lblMessage.font = fontPopins.Regular.of(size: 14)
        lblMessage.textColor = UIColor.white
        self.view.addSubview(lblMessage)
    }
    
    func getView() -> UIView {
        self.view.alpha = 0.0
        self.view.isHidden = true
        return self.view
    }
    
    func showView(title : String) {
        self.view.alpha = 1.0
        lblMessage.text = title
        self.view.isHidden = false
    }
    func removeView() {
        lblMessage.text = ""
        self.view.isHidden = true
    }
}

struct ValidationError {
    static func show(title : String, message : String) {
        let alertController = UIAlertController (title: title, message:message, preferredStyle: .alert)
        let firstAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(firstAction)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

