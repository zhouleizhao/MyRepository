//
//  SettingViewController.swift
//  DesignateDriver
//
//  Created by MyApple on 11/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class SettingViewController: BaseSwiftViewController {
    @IBOutlet weak var reportPhoneNumberLabel: UILabel!
    @IBOutlet weak var complainPhoneLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "设置"
        /*
        let arr:[UIView] = []
        for v in arr {
            let tapGr = UITapGestureRecognizer.init(target: self, action: #selector(viewsClicked(tapGr:)))
            v.addGestureRecognizer(tapGr)
        }*/
        self.requestDataFromServer()
    }
    @objc func viewsClicked(tapGr:UITapGestureRecognizer) {
        //开具发票
        let dbvc = DrawBillViewController()
        self.navigationController?.pushViewController(dbvc, animated: true)
    }
    @IBAction func drawBillViewClicked(_ sender: Any) {
        
        App_ZLZ_Helper.sendData(toServerUseUrl: "user/bill/list", dataDict: [:], type: RequestType_Post, loadingTitle: "加载中...", sucessTitle: "", sucessBlock: { (responseObj) in
            
            let dict = responseObj!["data"] as! NSDictionary
            if dict["money"] != nil {
                let dbvc = DrawBillViewController()
                dbvc.moneyStr = "\(dict["money"]!)"
                self.navigationController?.pushViewController(dbvc, animated: true)
            }else{
                App_ZLZ_Helper.showErrorMessageAlert("您目前没有需要开发票的订单！")
            }
        }) { (error) in
            
        }
    }
    @IBAction func priceSheelViewClicked(_ sender: Any) {
        let webVC = WebViewController()
        webVC.titleStr = "价格表"
        //webVC.jieKou = "driver/explain/5"
        webVC.jieKou = "user/explain/words?type=5&longitude=\(App_ZLZ_Helper.getHelper().current_longitude)&latitude=\(App_ZLZ_Helper.getHelper().current_latitude)"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    @IBAction func insureProtocalViewClicked(_ sender: Any) {
        let webVC = WebViewController()
        webVC.titleStr = "保险协议"
        //webVC.jieKou = "driver/explain/13"
        webVC.jieKou = "user/explain/words?type=13&longitude=&latitude="
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    @IBAction func usingProtocalViewClicked(_ sender: Any) {
        let webVC = WebViewController()
        webVC.titleStr = "使用规则与协议"
        //webVC.jieKou = "driver/explain/14"
        webVC.jieKou = "user/explain/words?type=14&longitude=&latitude="
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    @IBAction func feedBackViewClicked(_ sender: Any) {
        let fborvc = FeedBackOrComplainViewController()
        self.navigationController?.pushViewController(fborvc, animated: true)
    }
    @IBAction func complainTelViewClicked(_ sender: Any) {
        if self.reportPhoneNumberLabel.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlert("投诉电话为空，请退出界面重试！")
            return
        }
        ChooseAlertView.showChoose(withTitle: "温馨提示", contentText: "确认拨打投诉电话？") {
            UIApplication.shared.openURL(URL.init(string: "tel://"+"\(self.reportPhoneNumberLabel.text!)")!)
        }
    }
    @IBAction func phoneViewClicked(_ sender: Any) {
        if self.reportPhoneNumberLabel.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlert("报案电话为空，请退出界面重试！")
            return
        }
        ChooseAlertView.showChoose(withTitle: "温馨提示", contentText: "确认拨打加盟热线电话？") {
            UIApplication.shared.openURL(URL.init(string: "tel://"+"\(self.reportPhoneNumberLabel.text!)")!)
        }
    }
    @IBAction func versionViewClicked(_ sender: Any) {
        CheckAppVersionManager.shared().shareAppVersionAlert(true)
    }
    override func requestDataFromServer() {
        App_ZLZ_Helper.sendData(toServerUseUrl: "driver/phone/findPhone", dataDict: [:], type: RequestType_Post, loadingTitle: "", sucessTitle: "", sucessBlock: { (responseObj) in
            let dataDict = responseObj!["data"] as! NSDictionary
            self.reportPhoneNumberLabel.text = "\(dataDict["jointel"]!)"
            self.complainPhoneLabel.text = "\(dataDict["complaintel"]!)"
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
