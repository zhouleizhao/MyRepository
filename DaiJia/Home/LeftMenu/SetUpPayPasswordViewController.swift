//
//  ModifyPayPasswordViewController.swift
//  DesignateDriver
//
//  Created by MyApple on 16/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

/*  修改密码
 SetUpPayPasswordViewController * supvc = [[SetUpPayPasswordViewController alloc] init];
 supvc.title = @"修改密码";
 supvc.subTitleHintLabelStr = @"请输入旧密码";
 supvc.completeBlock = ^{
 
 //验证旧密码  成功之后处理下面逻辑
 SetUpPayPasswordViewController * supvc = [[SetUpPayPasswordViewController alloc] init];
 supvc.title = @"修改密码";
 supvc.subTitleHintLabelStr = @"请输入新密码";
 supvc.completeBlock = ^{
 
 SetUpPayPasswordViewController * supvc = [[SetUpPayPasswordViewController alloc] init];
 supvc.title = @"修改密码";
 supvc.subTitleHintLabelStr = @"请再次输入新密码";
 supvc.isAginConfirm = true;
 supvc.completeBlock = ^{
 
 //请求网络接口
 };
 
 UIViewController * controller = self.navigationController.viewControllers[1];
 
 [self.navigationController popViewControllerAnimated:false];
 [controller.navigationController pushViewController:supvc animated:true];
 };
 
 UIViewController * controller = self.navigationController.viewControllers[1];
 
 [self.navigationController popViewControllerAnimated:false];
 [controller.navigationController pushViewController:supvc animated:true];
 };
 [self.navigationController pushViewController:supvc animated:true];
 */

/* 设置新密码
 SetUpPayPasswordViewController * supvc = [[SetUpPayPasswordViewController alloc] init];
 supvc.title = @"设置密码";
 supvc.subTitleHintLabelStr = @"请输入新密码";
 supvc.completeBlock = ^{
 
 SetUpPayPasswordViewController * supvc = [[SetUpPayPasswordViewController alloc] init];
 supvc.title = @"设置密码";
 supvc.subTitleHintLabelStr = @"请再次输入新密码";
 supvc.isAginConfirm = true;
 supvc.completeBlock = ^{
 
 //请求网络接口
 };
 
 UIViewController * controller = self.navigationController.viewControllers[1];
 
 [self.navigationController popViewControllerAnimated:false];
 [controller.navigationController pushViewController:supvc animated:true];
 };
 [self.navigationController pushViewController:supvc animated:true];
 */

class SetUpPayPasswordViewController: BaseSwiftViewController,UITextFieldDelegate {

    @objc var titleHintLabelStr = ""
    @objc var subTitleHintLabelStr = ""
    @IBOutlet weak var titleHintLabel: UILabel!
    @IBOutlet weak var subTitleHintLabel: UILabel!
    @IBOutlet weak var verifyTextField: UITextField!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fiveLabel: UILabel!
    @IBOutlet weak var sixLabel: UILabel!
    
    @objc var isAginConfirm:Bool = false
    @objc var oldPassword:String = ""
    
    @objc var oldOldPassword:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "设置密码"
        
        //self.titleHintLabel.text = self.titleHintLabelStr
        if subTitleHintLabelStr.count != 0 {
            self.subTitleHintLabel.text = self.subTitleHintLabelStr
        }

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        verifyTextField.delegate = self
        
        self.initLabels()
        
//        if isAginConfirm {
//            self.titleHintLabel.text = "请再次输入新密码"
//        }

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.verifyTextField.becomeFirstResponder()
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        verifyTextField.text = ""
        self.initLabels()
        verifyTextField.superview?.sendSubview(toBack: verifyTextField)
        return true
    }
    func initLabels() {
        let labelsArr = [firstLabel, secondLabel, thirdLabel, fourLabel, fiveLabel, sixLabel]
        for label in labelsArr {
            circleLabel(label: label)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        verifyTextField.text = ""
        self.initLabels()
        verifyTextField.superview?.bringSubview(toFront: verifyTextField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 1 {
            return true
        }
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        default:
            return false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBar.isHidden = false
        if isAginConfirm == false {
            
            self.navigationController?.navigationBar.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationController?.navigationBar.alpha = 1
            }) { (isCom) in
                
            }
        }
    }
    
    func circleLabel(label:UILabel?) {
        label?.layer.cornerRadius = 10
        label?.layer.borderWidth = 1
        label?.layer.borderColor = UIColor.lightGray.cgColor
        label?.backgroundColor = UIColor.white
    }
    func solidCircleLabel(label:UILabel?)  {
        label?.layer.cornerRadius = 10
        label?.layer.borderWidth = 0
        label?.backgroundColor = UIColor.black
    }
    
    @objc var completeBlock:((String,String)->())?
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
                        solidCircleLabel(label: label)
                    }else{
                        circleLabel(label: label)
                    }
                }
                break
            case 1:
                for label in labelsArr {
                    if label == secondLabel || label == firstLabel {
                        solidCircleLabel(label: label)
                    }else{
                        circleLabel(label: label)
                    }
                }
                break
            case 2:
                for label in labelsArr {
                    if label == thirdLabel || label == secondLabel || label == firstLabel {
                        solidCircleLabel(label: label)
                    }else{
                        circleLabel(label: label)
                    }
                }
                break
            case 3:
                for label in labelsArr {
                    if label == fourLabel || label == thirdLabel || label == secondLabel || label == firstLabel {
                        solidCircleLabel(label: label)
                    }else{
                        circleLabel(label: label)
                    }
                }
                break
            case 4:
                for label in labelsArr {
                    if label == fiveLabel || label == fourLabel || label == thirdLabel || label == secondLabel || label == firstLabel {
                        solidCircleLabel(label: label)
                    }else{
                        circleLabel(label: label)
                    }
                }
                break
            case 5:

                for label in labelsArr {
                    solidCircleLabel(label: label)
                }
                break
                
            default:
                break
            }
        }
        
        if verifyTextField.text!.count == 6 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                self.completeBlock!(self.verifyTextField.text!,self.oldOldPassword)
                self.verifyTextField.resignFirstResponder()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
