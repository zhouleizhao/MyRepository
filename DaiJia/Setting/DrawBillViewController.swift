//
//  DrawBillViewController.swift
//  DaiJia
//
//  Created by MyApple on 2018/9/18.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

import UIKit

class DrawBillViewController: UIViewController {
    @IBOutlet weak var invoiceTitleTextField: UITextField!
    @IBOutlet weak var dutyParagraphyTextField: UITextField!
    @IBOutlet weak var invoiceContentTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var moreInformationTextField: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var detailAddressTextField: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    
    var moneyStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "开具发票"
        if (moneyStr as NSString).floatValue >= 500 {
            hintLabel.text = "开票金额满500元包邮，本次邮费由平台支付"
        }
        priceLabel.text = moneyStr
    }
    private var provinceStr = ""
    private var cityStr = ""
    private var areaStr = ""
    @IBAction func addressViewClicked(_ sender: Any) {
        JWAddressPickerView1.show { (province, city, area, provinceId, cityId, areaId) in
            let str = ((province == nil) ? "" : province!)
            let str1 = ((city == nil) ? "" : city!)
            let str2 = ((area == nil) ? "" : area!)
            self.provinceStr = str
            self.cityStr = str1
            self.areaStr = str2
            self.addressLabel.text = str + " " + str1 + " " + str2
        }
    }
    @IBAction func commitBtnClicked(_ sender: Any) {
        if invoiceTitleTextField.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入发票抬头！")
            return
        }
        if dutyParagraphyTextField.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入税号！")
            return
        }
        if invoiceContentTextField.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入发票内容！")
            return
        }
        if nameLabel.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入收件人！")
            return
        }
        if phoneLabel.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入联系电话！")
            return
        }
        if addressLabel.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入所在地区！")
            return
        }
        if detailAddressTextField.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入详细地址！")
            return
        }
        let paraDict = ["billType":"企业单位", "billRise":invoiceTitleTextField.text!, "duty":dutyParagraphyTextField.text!, "content":invoiceContentTextField.text!, "remark":moreInformationTextField.text!, "money":moneyStr, "recipient":nameLabel.text!, "phone":phoneLabel.text!, "province":addressLabel.text!,  "address":detailAddressTextField.text!]
        App_ZLZ_Helper.sendData(toServerUseUrl: "user/bill/add", dataDict: paraDict, type: RequestType_Post, loadingTitle: "提交中...", sucessTitle: "提交成功！请等待邮寄！", sucessBlock: { (responseObj) in
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
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
