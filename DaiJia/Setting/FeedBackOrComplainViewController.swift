//
//  FeedBackOrComplainViewController.swift
//  DesignateDriver
//
//  Created by MyApple on 13/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class FeedBackOrComplainViewController: BaseSwiftViewController,UITextViewDelegate {

    var isFeedBack:Bool = true
    var _registerID = "" //投诉的时候需要
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var conentTextView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isFeedBack {
            self.title = "反馈"
        }else{
            self.title = "投诉"
        }
        
        self.conentTextView.delegate = self
    }
    @IBAction func submitBtnClicked(_ sender: Any) {
        
        if self.titleTextField.text?.count == 0 {
            
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入标题！")
            return
        }
        
        if self.conentTextView.text.count == 0{
            
            if isFeedBack {
                App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入反馈内容！")
            }else{
                App_ZLZ_Helper.showErrorMessageAlertAutoGone("请输入投诉内容！")
            }
            return
        }
        
        if isFeedBack {
            App_ZLZ_Helper.sendData(toServerUseUrl: "user/complaint/add", dataDict: ["title":self.titleTextField.text!, "content":self.conentTextView.text!], type: RequestType_Post, loadingTitle: "提交中...", sucessTitle: "提交成功！", sucessBlock: { (responseObj) in
                //请求服务器
                self.navigationController?.popViewController(animated: true)
            }) { (error) in
                
            }
        }else{
            App_ZLZ_Helper.sendData(toServerUseUrl: "complaint/company", dataDict: ["title":self.titleTextField.text!, "content":self.conentTextView.text!, "registerID":self._registerID], type: RequestType_Post, loadingTitle: "提交中...", sucessTitle: "提交成功！", sucessBlock: { (responseObj) in
                //请求服务器
                self.navigationController?.popViewController(animated: true)
            }) { (error) in
                
            }
        }
    }
    
    //MARK: UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing")
        self.placeHolderLabel?.isHidden = true // 隐藏
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldEndEditing")
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeHolderLabel?.isHidden = false  // 显示
        }
        else{
            self.placeHolderLabel?.isHidden = true  // 隐藏
        }
        print("textViewDidEndEditing")
    }
    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
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
