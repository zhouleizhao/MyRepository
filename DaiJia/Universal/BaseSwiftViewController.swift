//
//  BaseSwiftViewController.swift
//  DesignateDriver
//
//  Created by MyApple on 30/06/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh
import Kingfisher

// 获取view当前所在的UIViewController
//func getCurrentViewController() -> UIViewController {
//    
//    let nav = App_ZLZ_Helper.getAppDelegate().homePageVC.navigationController!
//    return (nav.topViewController)!
//}

func setImageViewUsingStr(urlStr:String, imageView:UIImageView, placeHolder:String) {
    
    var imgStr = ""
    
    if urlStr.hasPrefix("http") {
        imgStr = urlStr
    }else{
        imgStr = App_ZLZ_Helper.getHelper().getRootImageUrlStr() + urlStr
    }

    let imgURL = NSURL.init(string: imgStr)
    //self.headerImageView.kf.setImage(with: ImageResource.init(downloadURL: imgURL! as URL))
    imageView.kf.setImage(with: ImageResource.init(downloadURL: imgURL! as URL), placeholder: UIImage.init(named: placeHolder), options: [.transition(.fade(1))], progressBlock: { (a, b) in
        
    }) { (img, error, type, url) in
        
    }
}

func getTimeStr(seconds:Int) -> String {
    let min = seconds/60
    let minStr = min < 10 ? "0\(min)" : "\(min)"
    let second = seconds%60
    let secondStr = second < 10 ? "0\(second)" : "\(second)"
    return (minStr + ":" + secondStr)
}

func safeString(str:String?) -> String {
    if  str == nil || str == "null" {
        return ""
    }
    return str!
}

func saveUserInfoStirng(key:String, value:String) {
//    let model = UserInfoModel.getModel()!
//    model.setValue(value, forKeyPath: key)
//    UserInfoModel.save(model)
}

//获取上一个controller
func getLastViewController(controller:UIViewController) -> UIViewController {
    
    let viewControllers = controller.navigationController!.viewControllers as NSArray
    return viewControllers[1] as! UIViewController
}

//根据type获取订单类型
func getOrderTypeStrAccordingType(type:String) -> String {
    var str = ""
    switch type {
    case "1":
        str = "代驾"
        break
    case "2":
        str = "预约"
        break;
    case "3":
        str = "代叫"
        break;
    case "4":
        str = "司机主动下订单"
        break;
    default:
        break
    }
    
    return str
}

class BaseSwiftViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.checkOrderStateNew()
    }
    
//    //MARK: - 获取用户订单状态
//    func checkOrderStateNew() {
//        /*
//         订单状态码：
//         0   初始状态（预约订单）
//         1   系统已派单
//         2   已前往服务
//         3   已到达目的地
//         4   开始开车
//         5   开始中途等待
//         6   已结束服务（停止开车）
//         7   已确认款项
//         8   已报单
//         9   已报单未支付（在线支付）
//         10  订单完成——已报单已支付（现金支付报单后直接置位此状态）
//         11  用户已取消
//         12  客户已取消
//         spot   0抽中了  1已拍照   2未拍照  3未抽中
//         */
//        App_ZLZ_Helper.sendData(toServerUseUrl: "home/getNormalOrder", dataDict: [:], type: RequestType_Post, loadingTitle: "", sucessTitle: "", sucessBlock: { (responseObj) in
//            let rootDict = responseObj! as NSDictionary
//            let dataDict = rootDict["data"] as! NSDictionary
//            //let orderDict = dataDict["order"] as! NSDictionary
//            let inspectionDict = dataDict["spot"] as! NSDictionary
//            //print("spot state = \(inspectionDict["status"]!)")
//            print("记得处理在岗抽查inspection state = \(inspectionDict["status"]!)")
//
//            switch "\(inspectionDict["status"]!)" {
//            case "1":
//                //不需要任何操作
//                break
//            case "2":
//                SpotCheckPopView.showPopView(reatTime: "\(inspectionDict["createTime"]!)")
//                break
//            case "3":
//                //不需要任何操作
//                break
//
//            default:
//                break
//
//            }
//
//        }) { (error) in
//
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        /*
         UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [backButton setTitle:@"返回" forState:UIControlStateNormal];
         [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [backButton setImage:[UIImage imageNamed:@"形状-4-拷贝-6"] forState:UIControlStateNormal];
         [backButton sizeToFit];
         [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
         backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
         */
        //self.view.backgroundColor = App_ZLZ_Helper.getBaseControllerBackColor()
    }
    
    func showNetworkErrorDefaultView() {
        let view = UIView()
        view.backgroundColor = App_ZLZ_Helper.color(withHexString: "efefef")
        self.view.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    //上拉下拉加载
    var pageNumber:Int = 1
    var totalPage:Int = 1
    
    func refreshData(){
        
    }
    func loadMoreData(){
        
    }
    
    func requestDataFromServer() {
        
    }

    @objc func back_root(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightItemBtnClicked(){
        print("super class rightItemBtnClicked!")
    }
    @objc func leftItemBtnClicked(){
        
    }
    func addRightItemBtn(btnTitle:String){
        let rightButton = UIButton.init()
        rightButton.setTitle(btnTitle, for: UIControlState.normal)
        rightButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        rightButton.addTarget(self, action: #selector(rightItemBtnClicked), for: UIControlEvents.touchUpInside)
        rightButton.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
    }
    func addRightItemBtnUseImg(img:UIImage, imageInsets:UIEdgeInsets){
        let rightButton = UIButton.init()
        rightButton.frame = CGRect.init(x: 0, y: 0, width: 38, height: 38)
        rightButton.imageEdgeInsets = imageInsets
        rightButton.setImage(img, for: UIControlState.normal)
        
        rightButton.addTarget(self, action: #selector(rightItemBtnClicked), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
    }
    func addLeftItemBtnUseImg(img:UIImage, imageInsets:UIEdgeInsets){
        let leftButton = UIButton.init()
        leftButton.frame = CGRect.init(x: 0, y: 0, width: 38, height: 38)
        leftButton.imageEdgeInsets = imageInsets
        leftButton.setImage(img, for: UIControlState.normal)
        
        leftButton.addTarget(self, action: #selector(leftItemBtnClicked), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
    }
    
    //添加根View的时候适配屏幕  适配iPhoneX
    func rootViewAddSubView(v:UIView) {
        self.view.addSubview(v)
        v.snp.makeConstraints { (maker) in
            if App_ZLZ_Helper.isIphoneX() {
                maker.top.equalToSuperview().offset(88)
            }else{
                maker.top.equalToSuperview().offset(64)
            }
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    //添加根View的时候适配屏幕  适配iPhoneX
    func rootViewAddSubViewWhenScrollView(v:UIView) {
        self.view.addSubview(v)
        v.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    enum Request_type {
        case GET
        case POST
    }
    
    func sendDataToServer(url:String, dataDict:NSDictionary, type:Request_type, loadingTitle:String, sucessTitle:String, sucessBlock:@escaping ((NSDictionary)->()), filedBlock:@escaping((Error?)->())){
        
        let userInfo = App_ZLZ_Helper.getHelper().getUSERINFO()
        let userId:String = "\(String(describing: (userInfo!["id"]!)))"
        let manager = AFHTTPSessionManager()
        let response = AFJSONResponseSerializer()
        response.removesKeysWithNullValues = true
        response.acceptableContentTypes = NSSet.init(array: ["text/html", "text/json", "text/plain", "text/javascript", "application/json"]) as? Set<String>
        manager.responseSerializer = response
        let realDict = NSMutableDictionary.init(dictionary: dataDict)
        realDict.setValue(userId, forKey: "userId")
        
        var hud:MBProgressHUD?
        if loadingTitle.count != 0 {
            hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
            hud?.label.text = loadingTitle
        }
        if type == .GET {
            manager.get(App_ZLZ_Helper.getHelper().getServiceStr() + url, parameters: realDict, progress: { (progress) in
                
            }, success: { (task, responseObject) in
                hud?.isHidden = true
                let dict = responseObject as! NSDictionary
                print((task.currentRequest?.url?.description)! + "返回数据 = \(dict)")
                if ("\(dict["code"]!)" == "10000") {
                    
                    if sucessTitle.count != 0 {
                        MBProgressHUD.showSuccess(sucessTitle, to:UIApplication.shared.keyWindow)
                    }
                    
                    sucessBlock(dict)
                    
                }else{
                    MBProgressHUD.showError(String(describing: dict["msg"]!), to:self.view)
                    //print("添加信用卡银行卡错误数据 = \(dict)")
                    filedBlock(nil)
                }
            }) { (task, error) in
                hud?.isHidden = true
                print((task?.currentRequest?.url?.description)! + "返回错误数据 = \(error)")
                MBProgressHUD.showError("网络请求失败", to:self.view)
                filedBlock(error)
            }
        }
        if type == .POST {
            manager.post(App_ZLZ_Helper.getHelper().getServiceStr() + url, parameters: realDict, progress: { (progress) in
                
            }, success: { (task, responseObject) in
                hud?.isHidden = true
                let dict = responseObject as! NSDictionary
                print((task.currentRequest?.url?.description)! + "返回数据 = \(dict)")
                if ("\(dict["code"]!)" == "10000") {
                    
                    if sucessTitle.count != 0 {
                        MBProgressHUD.showSuccess(sucessTitle, to:UIApplication.shared.keyWindow)
                    }
                    
                    sucessBlock(dict)
                    
                }else{
                    MBProgressHUD.showError(String(describing: dict["msg"]!), to:self.view)
                    filedBlock(nil)
                }
            }) { (task, error) in
                hud?.isHidden = true
                MBProgressHUD.showError("网络请求失败", to:self.view)
                filedBlock(error)
            }
        }
    }
    
    func sendDataToServerUseUnique(url:String, dataDict:NSDictionary, type:Request_type, loadingTitle:String, sucessTitle:String, sucessBlock:@escaping ((NSDictionary)->()), filedBlock:@escaping((Error?)->())){
        
        let userInfo = App_ZLZ_Helper.getHelper().getUSERINFO()
        let userId:String = "\(String(describing: (userInfo!["id"]!)))"
        let manager = AFHTTPSessionManager()
        let response = AFJSONResponseSerializer()
        response.removesKeysWithNullValues = true
        response.acceptableContentTypes = NSSet.init(array: ["text/html", "text/json", "text/plain", "text/javascript", "application/json"]) as? Set<String>
        manager.responseSerializer = response
        let realDict = NSMutableDictionary.init(dictionary: dataDict)
        realDict.setValue(userId, forKey: "userId")
        
        var hud:MBProgressHUD?
        if loadingTitle.count != 0 {
            hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
            hud?.label.text = loadingTitle
        }
        if type == .GET {
            manager.get(url, parameters: realDict, progress: { (progress) in
                
            }, success: { (task, responseObject) in
                hud?.isHidden = true
                let dict = responseObject as! NSDictionary
                print((task.currentRequest?.url?.description)! + "返回数据 = \(dict)")
                
                if sucessTitle.count != 0 {
                    MBProgressHUD.showSuccess(sucessTitle, to:UIApplication.shared.keyWindow)
                }
                
                sucessBlock(dict)
            }) { (task, error) in
                print((task?.currentRequest?.url?.description)! + "返回error数据 = \(error)")
                hud?.isHidden = true
                MBProgressHUD.showError("网络请求失败", to:self.view)
                filedBlock(error)
            }
        }
        if type == .POST {
            manager.post(url, parameters: realDict, progress: { (progress) in
                
            }, success: { (task, responseObject) in
                hud?.isHidden = true
                let dict = responseObject as! NSDictionary
                print((task.currentRequest?.url?.description)! + "返回数据 = \(dict)")
                if sucessTitle.count != 0 {
                    MBProgressHUD.showSuccess(sucessTitle, to:UIApplication.shared.keyWindow)
                }
                
                sucessBlock(dict)
            }) { (task, error) in
                print((task?.currentRequest?.url?.description)! + "返回error数据 = \(error)")
                hud?.isHidden = true
                MBProgressHUD.showError("网络请求失败", to:self.view)
                filedBlock(error)
            }
        }
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
