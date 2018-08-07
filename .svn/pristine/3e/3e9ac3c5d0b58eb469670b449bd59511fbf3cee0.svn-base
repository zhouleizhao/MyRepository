//
//  BaseCustomLoadInXibView.swift
//  DesignateDriver
//
//  Created by MyApple on 20/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class BaseCustomLoadInXibView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("\(type(of: self))", owner: self, options: nil)
        self.frame = self.view.frame
        self.addSubview(self.view)
        self.view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

}
