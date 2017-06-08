//
//  GroceriesTableViewCell.swift
//  Moolah
//
//  Created by Varun Pitta on 6/8/17.
//  Copyright © 2017 Sun, Jessica. All rights reserved.
//

import UIKit

class GroceriesTableViewCell: UITableViewCell {
    
    @IBOutlet var groceriesCouponLabel: UILabel!
    
    @IBOutlet var groceriesCouponAmountLabel: UILabel!
    
    @IBOutlet var groceriesCouponExpDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
