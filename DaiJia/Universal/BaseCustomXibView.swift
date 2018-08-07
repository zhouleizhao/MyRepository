//
//  BaseCustomXibView.swift
//  DesignateDriver
//
//  Created by MyApple on 05/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class BaseCustomXibView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let viewArr = Bundle.main.loadNibNamed("\(type(of: self))", owner: self, options: nil)
        let mainView = viewArr?.first as! UIView
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (isCom) in
            self.removeFromSuperview()
        }
    }
    
    func showView() {
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
}
