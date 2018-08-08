//
//  SearchResultTableViewCell.swift
//  QuickDog
//
//  Created by MyApple on 11/05/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var selectedBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
