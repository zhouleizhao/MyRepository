//
//  PlaceholderTextView.swift
//  DesignateDriver
//
//  Created by MyApple on 20/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class PlaceholderTextView: BaseCustomLoadInXibView,UITextViewDelegate {

    //@IBOutlet var view: UIView!
    @IBOutlet weak var conentTextView: UITextView!
    @IBOutlet weak var hintLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    override func awakeFromNib() {
//        Bundle.main.loadNibNamed("PlaceholderTextView", owner: self, options: nil)
//        self.addSubview(self.)
//    }

    override func awakeFromNib() {
        self.conentTextView.delegate = self
    }
    
    
    //MARK: UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing")
        self.hintLabel.isHidden = true // 隐藏
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldEndEditing")
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.hintLabel.isHidden = false  // 显示
        }
        else{
            self.hintLabel.isHidden = true  // 隐藏
        }
        print("textViewDidEndEditing")
    }

}
