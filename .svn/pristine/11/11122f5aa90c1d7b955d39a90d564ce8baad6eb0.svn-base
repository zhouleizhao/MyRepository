//
//  CommonAddressViewController.swift
//  DaiJia
//
//  Created by MyApple on 2018/7/31.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

import UIKit

class CommonAddressViewController: BaseSwiftViewController {
    @IBOutlet weak var addressNameTextField: UITextField!
    @IBOutlet weak var addressLocationNameTextField: UITextField!
    
    @objc var dataDict:NSDictionary!
    
    @objc var commonAddressBlock:((String)->())?
    @objc var countStr = "" //1,2
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "常用地址"
        
        let tapGr = UITapGestureRecognizer.init(target: self, action: #selector(selectedAddressViewClicked))
        self.addressLocationNameTextField.superview?.addGestureRecognizer(tapGr)
        
        self.addRightItemBtn(btnTitle: "保存")
        
        if dataDict != nil {
            
            /*address = "\U6b63\U5b9a\U7ad9";
             alias = "\U706b\U8f66\U7ad9";
             latitude = "38.1675930";
             longitude = "114.5627620";*/
            self.addressNameTextField.text = "\(dataDict["alias"]!)"
            self.addressLocationNameTextField.text = "\(dataDict["address"]!)"
            self.latitude = "\(dataDict["latitude"]!)"
            self.longitude = "\(dataDict["longitude"]!)"
        }
    }
    
    override func rightItemBtnClicked() {
        if self.addressNameTextField.text?.count == 0 {
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入地址命名！")
            return
        }
        if self.addressLocationNameTextField.text?.count == 0 {
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请选择定位信息！")
            return
        }
        
        App_ZLZ_Helper.sendData(toServerUseUrl: "user/commonAddress/modify", dataDict: ["addressID":self.countStr, "address":self.addressLocationNameTextField.text!, "alias":self.addressNameTextField.text!, "latitude":self.latitude, "longitude":self.longitude], type: RequestType_Post, loadingTitle: "设置中...", sucessTitle: "设置成功！", sucessBlock: { (responseObj) in
            
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
    
    private var latitude:String = ""
    private var longitude:String = ""
    @objc func selectedAddressViewClicked() {
        
        let savc = SearchAddressViewController()
        savc.isShowCommonAddress = false
        savc.selectedRowBlock = { info, latitude, longitude, isEnd in
            self.addressLocationNameTextField.text = info.name
            self.latitude = "\(latitude)"
            self.longitude = "\(longitude)"
        }
        self.navigationController?.pushViewController(savc, animated: true)
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
