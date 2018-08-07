//
//  AddImageSubView.swift
//  QuickDog
//
//  Created by MyApple on 26/04/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

@objc protocol AddImageSubViewDelegate:class {
    func album_AddImageSubView()
    func shot_AddImageSubView()
}

class AddImageSubView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var albumBtn:UIButton!
    @IBOutlet weak var shotBtn:UIButton!
    @IBOutlet weak var cancelBtn:UIButton!
    
    @objc var delegate:AddImageSubViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let viewArr = Bundle.main.loadNibNamed("AddImageSubView", owner: self, options: nil)
        let mainV = viewArr?.first as! UIView
        self.addSubview(mainV)
        mainV.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        self.cancelBtn.addTarget(self, action: #selector(removeSelf), for: UIControlEvents.touchUpInside)
        self.albumBtn.addTarget(self, action: #selector(albumClicked), for: UIControlEvents.touchUpInside)
        self.shotBtn.addTarget(self, action: #selector(shotClicked), for: UIControlEvents.touchUpInside)
    }
    
    @objc func albumClicked(){
        self.removeSelf()
        delegate?.album_AddImageSubView()
    }
    @objc func shotClicked(){
        self.removeSelf()
        delegate?.shot_AddImageSubView()
    }
    
    @objc class func showView() -> AddImageSubView! {
        let addView = AddImageSubView.init(frame: CGRect.zero)
        UIApplication.shared.keyWindow?.addSubview(addView)
        addView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        addView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            addView.alpha = 1
        }
        return addView
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.removeSelf()
    }
    @objc func removeSelf(){
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (res) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
