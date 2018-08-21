//
//  ChongZhiViewController.swift
//  DaiJia
//
//  Created by MyApple on 28/07/2018.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

import UIKit

class ChongZhiViewController: UIViewController {

    @objc var yuEStr:String = ""
    private var mainView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "充值"
        self.view.backgroundColor = App_ZLZ_Helper.getCONTROLLERCOLOR()
        
        let scrollV = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: CGFloat(App_ZLZ_Helper.screenWidth()), height: CGFloat(App_ZLZ_Helper.screenHeight())))
        scrollV.contentSize = CGSize.init(width: CGFloat(App_ZLZ_Helper.screenWidth()), height: CGFloat(App_ZLZ_Helper.screenHeight()) * 0.4 + 286)
        self.view.addSubview(scrollV)
        
        let view = ChongZhiView1.init(frame: CGRect.init(x: 0, y: 0, width: CGFloat(App_ZLZ_Helper.screenWidth()), height: CGFloat(App_ZLZ_Helper.screenHeight()) * 0.4 + 286))
        mainView = view;
        view.balanceLabel.text = yuEStr
        view.immediateRechargeBlock = { valueStr, isAlipay in

            App_ZLZ_Helper.sendData(toServerUseUrl: "user/transPwd/isHasPwd", dataDict: [:], type: RequestType_Post, loadingTitle: "加载中...", sucessTitle: "", sucessBlock: { (responseObj) in
                
                let str = "\(responseObj!["data"]!)"
                if str == "0" {
                    
                    ChooseAlertView.showChoose(withTitle: "温馨提示", contentText: "您还未设置支付密码，现在设置？", andSureAction: {
                        
                        self.gotoSetupPayPassword(vc: self)
                    })
                    
                }else{
                    
                    //判断是不是支付宝
                    if isAlipay {
                        
                        InputPayPasswordView.showPopView(completeBlock: { (str) in
                            //提现
                            print("请求服务器充值！")
                            
                            App_ZLZ_Helper.sendData(toServerUseUrl: "user/ali/recharge", dataDict: ["amount":valueStr, "transPwd":str], type: RequestType_Post, loadingTitle: "充值中...", sucessTitle: "", sucessBlock: { (responseObj) in
                                
                                //App_ZLZ_Helper.showErrorMessageAlert("充值申请已提交，请关注到账状态！")
                                //self.navigationController?.popViewController(animated: true)
                                let orderStr = responseObj!["data"] as! String
                                
                                App_ZLZ_Helper.payUseAliPay(orderStr, andResultCallBack: { (resCode) in
                                    self.navigationController?.popViewController(animated: true)
                                })
                                
                            }, failedBlock: { (error) in
                                
                            })
                            
                        }, hintTitle: "充值", cashValue: valueStr)
                    }else{
                        
                        if (!WXApi.isWXAppInstalled()) {
                            App_ZLZ_Helper.showErrorMessageAlert("您尚未安装微信，无法支付！")
                            return
                        }
                        
                        InputPayPasswordView.showPopView(completeBlock: { (str) in
                            //提现
                            print("请求服务器充值！")
                            App_ZLZ_Helper.sendData(toServerUseUrl: "user/wx/recharge", dataDict: ["amount":valueStr, "transPwd":str], type: RequestType_Post, loadingTitle: "充值中...", sucessTitle: "", sucessBlock: { (responseObj) in
                                
                                /*
                                 "data":{
                                 "appid":"wxfd5b5ad8494ed239",
                                 "noncestr":"r8JFOnQYtzoe1N2e",
                                 "package":"Sign=WXPay",
                                 "partnerid":"1511816971",
                                 "prepayid":"wx14103048397443485a7cc3b40258181896",
                                 "sign":"552D67EEE6F5A7565245F31F10677D95",
                                 "timestamp":1534213848
                                 }
                                 */
                                let dataDict = responseObj?["data"] as! NSDictionary
                                let mudict:NSMutableDictionary = NSMutableDictionary()
                                mudict.setValue("\(dataDict["partnerid"]!)", forKey: "partnerId")
                                mudict.setValue("\(dataDict["prepayid"]!)", forKey: "prepayId")
                                mudict.setValue("\(dataDict["packageX"]!)", forKey: "package")
                                mudict.setValue("\(dataDict["noncestr"]!)", forKey: "nonceStr")
                                mudict.setValue("\(dataDict["timestamp"]!)", forKey: "timeStamp")
                                mudict.setValue("\(dataDict["sign"]!)", forKey: "sign")
                                WXApiManager.shared().pay(usingData: mudict as! [AnyHashable : Any])
                                
                                NotificationCenter.default.addObserver(self, selector: #selector(self.winXinPaySuccess), name: NSNotification.Name.init(WINXIN_PAY_SUCCESS), object: nil)
                                NotificationCenter.default.addObserver(self, selector: #selector(self.winXinPayFailed), name: NSNotification.Name.init(WINXIN_PAY_FAILED), object: nil)
                                
                            }, failedBlock: { (error) in
                                
                            })
                            
                        }, hintTitle: "充值", cashValue: valueStr)
                    }

                }
            }) { (error) in
                
            }
        }
        scrollV.addSubview(view)
        
        /*
         self.title = @"充值";
         self.view.backgroundColor = CONTROLLERCOLOR
         self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
         self.scrollView.contentSize = CGSizeMake(SCREENWidth, 286+SCREENHeight*0.4);
         [self.view addSubview:self.scrollView];
         ChongZhiView1 * view = [[ChongZhiView1 alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 286+SCREENHeight*0.4)];
         */
        
        self.getAdData()
    }
    
    
    @objc func winXinPaySuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func winXinPayFailed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAdData() {
        App_ZLZ_Helper.sendData(toServerUseUrl: "user/advertising/getAdvert", dataDict: [:], type: RequestType_Post, loadingTitle: "", sucessTitle: "", sucessBlock: { (responseObj) in
            
            let view = self.mainView as! ChongZhiView1
            setImageViewUsingStr(urlStr: "\(responseObj!["data"]!)", imageView: view.topAdImageView, placeHolder: "充值banner")
        }) { (error) in
            
        }
    }
    
    @objc func checkPayPassword(vc:UIViewController, successBlock:@escaping (()->())) {
        
        App_ZLZ_Helper.sendData(toServerUseUrl: "user/transPwd/isHasPwd", dataDict: [:], type: RequestType_Post, loadingTitle: "加载中...", sucessTitle: "", sucessBlock: { (responseObj) in
            
            let str = "\(responseObj!["data"]!)"
            if str == "0" {
                
                ChooseAlertView.showChoose(withTitle: "温馨提示", contentText: "您还未设置支付密码，现在设置？", andSureAction: {
                    
                    self.gotoSetupPayPassword(vc: vc)
                })
                
            }else{
                successBlock()
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
