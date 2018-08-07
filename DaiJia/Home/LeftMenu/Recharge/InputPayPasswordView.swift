//
//  InputPayPasswordView.swift
//  DesignateDriver
//
//  Created by MyApple on 12/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class InputPayPasswordView: BaseCustomXibView,UITextFieldDelegate {
    
    @IBOutlet weak var titleHintLabel: UILabel!
    @IBOutlet weak var cashValueLabel: UILabel!
    @IBOutlet weak var verifyTextField: UITextField!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fiveLabel: UILabel!
    @IBOutlet weak var sixLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var _completeBlock:((_ password:String)->())?
    class func showPopView(completeBlock:@escaping ((_ password:String)->()), hintTitle:String, cashValue:String) { //在类中绑定值
        let popView = InputPayPasswordView()
        popView._completeBlock = completeBlock
        popView.titleHintLabel.text = hintTitle
        popView.cashValueLabel.text = "¥" + cashValue
        popView.verifyTextField.delegate = popView
        popView.backBtn.addTarget(popView, action: #selector(backBtnClicked), for: UIControlEvents.touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(popView)
        popView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        popView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            popView.alpha = 1
        }
        
        NotificationCenter.default.addObserver(popView, selector: #selector(textChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        popView.verifyTextField.delegate = popView
        
        let labelsArr = [popView.firstLabel, popView.secondLabel, popView.thirdLabel, popView.fourLabel, popView.fiveLabel, popView.sixLabel]
        
        for label in labelsArr {
            label?.isHidden = true
            label?.superview?.layer.borderWidth = 1
            label?.superview?.layer.borderColor = UIColor.lightGray.cgColor
        }
        popView.verifyTextField.becomeFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        verifyTextField.text = ""
        let labelsArr = [firstLabel, secondLabel, thirdLabel, fourLabel, fiveLabel, sixLabel]
        
        for label in labelsArr {
            label?.isHidden = true
        }
        verifyTextField.superview?.sendSubview(toBack: verifyTextField)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        verifyTextField.text = ""
        let labelsArr = [firstLabel, secondLabel, thirdLabel, fourLabel, fiveLabel, sixLabel]
        
        for label in labelsArr {
            label?.isHidden = true
        }
        verifyTextField.superview?.bringSubview(toFront: verifyTextField)
    }
    
    @objc func textChange() {
        print("verifyTextField.text = \(verifyTextField.text!)")
        
        let labelsArr = [firstLabel, secondLabel, thirdLabel, fourLabel, fiveLabel, sixLabel]
        if verifyTextField.text?.count == 0 {
            for label in labelsArr {
                
                label?.isHidden = true
            }
            return
        }
        
        for i in 0 ..< verifyTextField.text!.count {
            
            switch i {
            case 0:
                
                for label in labelsArr {
                    if label == firstLabel {
                        firstLabel.isHidden = false
                    }else{
                        label?.isHidden = true
                    }
                }
                break
            case 1:
                for label in labelsArr {
                    if label == secondLabel || label == firstLabel {
                        label?.isHidden = false
                    }else{
                        label?.isHidden = true
                    }
                }
                break
            case 2:
                for label in labelsArr {
                    if label == thirdLabel || label == secondLabel || label == firstLabel {
                        label?.isHidden = false
                    }else{
                        label?.isHidden = true
                    }
                }
                break
            case 3:
                for label in labelsArr {
                    if label == fourLabel || label == thirdLabel || label == secondLabel || label == firstLabel {
                        label?.isHidden = false
                    }else{
                        label?.isHidden = true
                    }
                }
                break
            case 4:
                for label in labelsArr {
                    if label == fiveLabel || label == fourLabel || label == thirdLabel || label == secondLabel || label == firstLabel {
                        label?.isHidden = false
                    }else{
                        label?.isHidden = true
                    }
                }
                break
            case 5:
                
                for label in labelsArr {
                    label?.isHidden = false
                }
                break
                
            default:
                break
            }
        }
        
        if verifyTextField.text!.count == 6 {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self._completeBlock!(self.verifyTextField.text!)
                self.backBtnClicked()
                self.verifyTextField.resignFirstResponder()
                
                //验证支付密码
                /*
                App_ZLZ_Helper.sendData(toServerUseUrl: "", dataDict: [:], type: RequestType_Post, loadingTitle: "", sucessTitle: "", sucessBlock: { (responseObj) in
                    
                    self._completeBlock!(self.verifyTextField.text!)
                    self.backBtnClicked()
                }) { (error) in
                    
                    
                }*/
            }
        }
    }
    
    @objc func backBtnClicked(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (isCom) in
            self.removeFromSuperview()
        }
    }

}
