//
//  PayPasswordViewController.swift
//  DaiJia
//
//  Created by MyApple on 2018/7/31.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

import UIKit

class PayPasswordViewController: BaseSwiftViewController {
    @IBOutlet weak var passwordTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "支付密码"
        
        let tapGr = UITapGestureRecognizer.init(target: self, action: #selector(viewClicked))
        self.passwordTitleLabel.superview?.addGestureRecognizer(tapGr)
    }
    @IBAction func forgetPasswordViewClicked(_ sender: Any) {
        
        let fpvc = ForgetPasswordViewController()
        fpvc.isForgetPassword = false
        self.navigationController?.pushViewController(fpvc, animated: true)
    }
    
    @objc func viewClicked() {
        if (self.passwordTitleLabel.text! == "设置密码") {
            
            //设置支付密码
            let mppvc = SetUpPayPasswordViewController()
            mppvc.title = "设置密码"
            mppvc.subTitleHintLabelStr = "请输入新密码"
            mppvc.completeBlock = { str, str1 in
                
                let mppvc = SetUpPayPasswordViewController()
                mppvc.title = "设置密码"
                mppvc.subTitleHintLabelStr = "请输入新密码"
                mppvc.oldPassword = str
                mppvc.isAginConfirm = true
                mppvc.completeBlock = { str, str1 in
                    
                    App_ZLZ_Helper.sendData(toServerUseUrl: "user/transPwd/set", dataDict: ["newPwd":str], type: RequestType_Post, loadingTitle: "设置中...", sucessTitle: "设置成功！", sucessBlock: { (responseObj) in
                        
                        self.navigationController?.popViewController(animated: true)
                    }, failedBlock: { (error) in
                        
                    })
                }
                let controller = self.navigationController?.viewControllers.last!
                self.navigationController?.popViewController(animated: false)
                controller?.navigationController?.pushViewController(mppvc, animated: true)
                
            }
            self.navigationController?.pushViewController(mppvc, animated: true)
        } else {
            
            //修改支付密码
            let mppvc = SetUpPayPasswordViewController()
            mppvc.title = "修改密码"
            mppvc.subTitleHintLabelStr = "请输入旧密码"
            mppvc.completeBlock = { str, str1 in
                
                let mppvc1 = SetUpPayPasswordViewController()
                mppvc1.title = "修改密码"
                mppvc1.oldOldPassword = str1
                mppvc1.subTitleHintLabelStr = "请输入新密码"
                mppvc1.completeBlock = { str, str1 in
                    
                    let mppvc = SetUpPayPasswordViewController()
                    mppvc.title = "修改密码"
                    mppvc.oldOldPassword = str1
                    mppvc.subTitleHintLabelStr = "请再次输入新密码"
                    mppvc.oldPassword = str
                    mppvc.isAginConfirm = true
                    mppvc.completeBlock = { str, str1 in
                        
                        App_ZLZ_Helper.sendData(toServerUseUrl: "user/transPwd/modify", dataDict: ["newPwd":str, "oldPwd":str1], type: RequestType_Post, loadingTitle: "修改中...", sucessTitle: "设置成功！", sucessBlock: { (responseObj) in
                            
                            self.navigationController?.popViewController(animated: true)
                        }, failedBlock: { (error) in
                            
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    let viewControllers = self.navigationController!.viewControllers as NSArray
                    let controller = viewControllers[1] as! UIViewController
                    self.navigationController?.popViewController(animated: false)
                    controller.navigationController?.pushViewController(mppvc, animated: true)
                }
                
                let viewControllers = self.navigationController!.viewControllers as NSArray
                let controller = viewControllers[1] as! UIViewController
                self.navigationController?.popViewController(animated: false)
                controller.navigationController?.pushViewController(mppvc1, animated: true)
            }
            self.navigationController?.pushViewController(mppvc, animated: true)

        }
    }

    override func requestDataFromServer() {
        
        App_ZLZ_Helper.sendData(toServerUseUrl: "transPwd/isHasPwd", dataDict: [:], type: RequestType_Post, loadingTitle: "加载中...", sucessTitle: "", sucessBlock: { (responseObj) in
            
            if "\(responseObj!["data"]!)" == "0" {
                self.passwordTitleLabel.text = "设置密码"
            } else {
                self.passwordTitleLabel.text = "修改密码"
            }
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
