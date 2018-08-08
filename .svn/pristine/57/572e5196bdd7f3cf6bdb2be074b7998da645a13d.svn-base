//
//  ApplyDaiJiaoViewController.swift
//  DaiJia
//
//  Created by MyApple on 2018/8/7.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

import UIKit

class ApplyDaiJiaoViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @objc var contentTableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.title = "申请代叫"
    }
    
    @objc func addressClicked() {
        let savc = SearchAddressViewController()
        savc.selectedRowBlock = {info, latitude, longitude, isEnd in
            self._latitude = "\(latitude)"
            self._longitude = "\(longitude)"
            self.addressTextField.text = info.name
        }
        self.navigationController?.pushViewController(savc, animated: true)
    }
    
    private var _latitude = ""
    private var _longitude = ""
    @IBAction func applyBtnClicked(_ sender: Any) {
        
        if self.nameTextField.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入商家名称！")
            return
        }
        if self.addressTextField.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请选择商家地址！")
            return
        }
        
        App_ZLZ_Helper.sendData(toServerUseUrl: "user/calledAddress/modify", dataDict: ["address":self.addressTextField.text!, "latitude":self._latitude, "longitude":self._longitude], type: RequestType_Post, loadingTitle: "申请中...", sucessTitle: "申请成功！", sucessBlock: { (responseObj) in
            
            let muDict = NSMutableDictionary.init(dictionary: App_ZLZ_Helper.getUSERINFO())
            muDict.setValue("1", forKey: "isNo")
            UserDefaults.standard.setValue(muDict, forKey: "userInfo")
            UserDefaults.standard.synchronize()
            
            self.contentTableView?.reloadData()
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
