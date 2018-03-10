//
//  ReportTableViewCell.swift
//  Expense
//
//  Created by iOS Developer 03 on 1/3/17.
//  Copyright © 2017 Dipang Home. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblByWhome: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code  
        
        self.backgroundColor = UIColor.white
        
        self.lblTitle.textColor = colorType.titleColor.color
        self.lblDate.textColor = colorType.titleColor.color
        self.lblByWhome.textColor = colorType.borderColor.color
        self.lblAmount.textColor = colorType.headerColor.color
        
        self.lblTitle.font = fontPopins.Regular.of(size: 16)
        self.lblDate.font = fontPopins.Regular.of(size: 10)
        self.lblByWhome.font = fontPopins.Regular.of(size: 14)
        self.lblAmount.font = fontPopins.Regular.of(size: 14)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
