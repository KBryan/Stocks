//
//  StockCellTableViewCell.swift
//  TestStocks
//
//  Created by Jon-Tait Beason on 4/30/15.
//  Copyright (c) 2015 IOBI - Inspire Or Be Inspired. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var arrowLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
