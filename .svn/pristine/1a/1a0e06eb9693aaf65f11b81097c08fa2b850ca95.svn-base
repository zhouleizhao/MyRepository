//
//  WithdrawCashViewController.swift
//  DesignateDriver
//
//  Created by MyApple on 12/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class WithdrawCashViewController: BaseSwiftViewController,UITextFieldDelegate {
    @IBOutlet weak var bankLogoImageView: UIImageView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var cashValueTextField: UITextField!
    @IBOutlet weak var walletCashLabel: UILabel!
    
    @objc var totalCash:String = ""
    var bankLogoStr:String = ""
    var bankNameStr:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "佣金提现"
        
        cashValueTextField.delegate = self
        
        //self.requestDataFromServer()
        
        self.walletCashLabel.text = "佣金余额¥" + totalCash + "，"
    }
    
    private var allCash = ""
    override func requestDataFromServer() {
        App_ZLZ_Helper.sendData(toServerUseUrl: "user/commission/page", dataDict: [:], type: RequestType_Post, loadingTitle: "加载中...", sucessTitle: "", sucessBlock: { (responseObj) in
            /*
             "cardNum":"中国银行（9999）",
             "balance":0,
             "bankLogo":"profile/nyyh.jpg"
             */
            let dataDict = responseObj?["data"] as! NSDictionary
            self.bankNameLabel.text = "\(dataDict["cardNum"]!)"
            self.walletCashLabel.text = "佣金金额¥" + "\(dataDict["balance"]!)" + "，"
            self.allCash = "\(dataDict["balance"]!)"
            //setImageViewUsingStr(urlStr: "\(dataDict["bankLogo"]!)", imageView: self.bankLogoImageView, placeHolder: "")
        }) { (error) in
            self.showNetworkErrorDefaultView()
        }
    }
    
    func goWithdraw(str:String) {
        //提现
        print("请求服务器提现！")
        App_ZLZ_Helper.sendData(toServerUseUrl: "withdraw/apply", dataDict: ["amount":self.cashValueTextField.text!, "transPwd":str], type: RequestType_Post, loadingTitle: "申请中...", sucessTitle: "", sucessBlock: { (responseObj) in
            
            App_ZLZ_Helper.showErrorMessageAlert("申请成功，请耐心等待！")
            self.navigationController?.popViewController(animated: true)
            
            /*
             let viewControllers = self.navigationController!.viewControllers as NSArray
             let controller = viewControllers[1] as! UIViewController
             self.navigationController?.popViewController(animated: false)
             
             let wsvc = WithdrawStateViewController()
             controller.navigationController?.pushViewController(wsvc, animated: true)*/
        }, failedBlock: { (error) in
            
        })
    }
    
    @IBAction func withdrawAllCashBtnClicked(_ sender: Any) {
        
        cashValueTextField.text = totalCash
    }
    @IBAction func withdrawBtnClicked(_ sender: Any) {
        
        if cashValueTextField.text!.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入提现金额！")
            return
        }
        
        App_ZLZ_Helper.sendData(toServerUseUrl: "user/transPwd/isHasPwd", dataDict: [:], type: RequestType_Post, loadingTitle: "加载中...", sucessTitle: "", sucessBlock: { (responseObj) in
            
            let str = "\(responseObj!["data"]!)"
            if str == "0" {
                
                ChooseAlertView.showChoose(withTitle: "温馨提示", contentText: "您还未设置支付密码，现在设置？", andSureAction: {
                    
                    self.gotoSetupPayPassword(vc: self)
                })
                
            }else{
                
                InputPayPasswordView.showPopView(completeBlock: { (str) in
                    print("str = \(str)")
                    
                    self.goWithdraw(str: str)
                }, hintTitle: "提现", cashValue: self.cashValueTextField.text!)
            }
        }) { (error) in
            
        }
    }
    
    @objc  func gotoSetupPayPassword(vc:UIViewController) {
        let sppvc:SetUpPayPasswordViewController = SetUpPayPasswordViewController()
        sppvc.title = "设置交易密码"
        sppvc.titleHintLabelStr = "请输入交易密码"
        sppvc.completeBlock = { str, str1 in
            let sppvc:SetUpPayPasswordViewController = SetUpPayPasswordViewController()
            sppvc.title = "设置交易密码"
            sppvc.titleHintLabelStr = "请再次输入交易密码"
            sppvc.isAginConfirm = true
            sppvc.oldPassword = str
            sppvc.completeBlock = { str, str1 in
                //请求设置交易密码
                
                App_ZLZ_Helper.sendData(toServerUseUrl: "user/transPwd/set", dataDict: ["newPwd":str], type: RequestType_Post, loadingTitle: "设置中...", sucessTitle: "设置成功！", sucessBlock: { (responseObj) in
                    
                    vc.navigationController?.popViewController(animated: true)
                }, failedBlock: { (error) in
                    vc.navigationController?.popViewController(animated: true)
                })
            }
            
            let controller = vc.navigationController?.viewControllers.last
            vc.navigationController?.popViewController(animated: true)
            controller?.navigationController?.pushViewController(sppvc, animated: true)
        }
        vc.navigationController?.pushViewController(sppvc, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("replacementString = \(string), \(textField.text!)")
        if "\(string)".count == 0 && textField.text!.count == 1 {
            return true
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let expression = "^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (newString as NSString).length))
        return numberOfMatches != 0
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
