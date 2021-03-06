//
//  DaiJiaBottomView.swift
//  DaiJia
//
//  Created by MyApple on 29/06/2018.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

import UIKit
import SnapKit

class DaiJiaBottomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var beginLocationTextField: UITextField!
    @IBOutlet weak var endLocationTextField: UITextField!
    @IBOutlet weak var numbersDriverLabel: UILabel!
    @IBOutlet weak var couponImageView: UIImageView!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var doneOrderButton: UIButton!
    @IBOutlet weak var leftImage2: UIImageView!
    @IBOutlet weak var leftImage1: UIImageView!
    @IBOutlet weak var leftImage3: UIImageView!
    @IBOutlet weak var oneInputView: UIView!
    @IBOutlet weak var twoInputView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @objc @IBOutlet weak var initialRateLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let viewArr = Bundle.main.loadNibNamed("DaiJiaBottomView", owner: self, options: nil)
        let mainView = viewArr?.first as! UIView
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    @IBAction func placeOrderBtnClicked(_ sender: Any) {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
