//
//  AssetsTableViewCell.swift
//  DesignateDriver
//
//  Created by MyApple on 05/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class DriverView: BaseCustomXibView {

    @IBOutlet weak var firstStartImageView: UIImageView!
    @IBOutlet weak var scondeStartImageView: UIImageView!
    @IBOutlet weak var thirdStartImageView: UIImageView!
    @IBOutlet weak var fourStartImageView: UIImageView!
    @IBOutlet weak var fiveStartImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userIconImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func setStarCount(starCount:Int) {
        switch starCount {
        case 0:
            firstStartImageView.image = UIImage(named: "assets_star1")
            scondeStartImageView.image = UIImage(named: "assets_star1")
            thirdStartImageView.image = UIImage(named: "assets_star1")
            fourStartImageView.image = UIImage(named: "assets_star1")
            fiveStartImageView.image = UIImage(named: "assets_star1")
            break;
        case 1:
            firstStartImageView.isHidden = false
            scondeStartImageView.image = UIImage(named: "assets_star1")
            thirdStartImageView.image = UIImage(named: "assets_star1")
            fourStartImageView.image = UIImage(named: "assets_star1")
            fiveStartImageView.image = UIImage(named: "assets_star1")
            break;
        case 2:
            firstStartImageView.isHidden = false
            scondeStartImageView.isHidden = false
            thirdStartImageView.image = UIImage(named: "assets_star1")
            fourStartImageView.image = UIImage(named: "assets_star1")
            fiveStartImageView.image = UIImage(named: "assets_star1")
            break;
        case 3:
            firstStartImageView.isHidden = false
            scondeStartImageView.isHidden = false
            thirdStartImageView.isHidden = false
            fourStartImageView.image = UIImage(named: "assets_star1")
            fiveStartImageView.image = UIImage(named: "assets_star1")
            break;
        case 4:
            firstStartImageView.isHidden = false
            scondeStartImageView.isHidden = false
            thirdStartImageView.isHidden = false
            fourStartImageView.isHidden = false
            fiveStartImageView.image = UIImage(named: "assets_star1")
            break;
        case 5:
            firstStartImageView.isHidden = false
            scondeStartImageView.isHidden = false
            thirdStartImageView.isHidden = false
            fourStartImageView.isHidden = false
            fiveStartImageView.isHidden = false
            break;
        default:
            break;
        }
    }
    @objc func bindData(dic:NSDictionary) {
        setImageViewUsingStr(urlStr: "\(dic["avatar"]!)", imageView: self.userIconImageView, placeHolder: "logo1")
        self.userNameLabel.text = "\(dic["driverName"]!)"
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
