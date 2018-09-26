//
//  SearchAddressViewController.swift
//  DesignateDriver
//
//  Created by MyApple on 20/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

import UIKit

class SearchAddressViewController: UIViewController,SearchSubViewDelegate,BMKPoiSearchDelegate,UITextFieldDelegate,BMKSuggestionSearchDelegate {
    
    @objc var isShowCommonAddress = true
    
    @objc var selectedRowBlock:((BMKPoiInfo,Double,Double,Bool)->())?
    @objc var lat:Double = 0
    @objc var lon:Double = 0
    @objc var isEnd:Bool = false
    @objc var selectedCommonAddressBlock:((NSDictionary)->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "地址搜索"
        
        if _baidu_map_poiSearch == nil {
            _baidu_map_poiSearch = BMKPoiSearch()
            _baidu_map_poiSearch.delegate = self
        }
        
        if _searchSubV == nil {
            _searchSubV = Bundle.main.loadNibNamed("SearchSubView", owner: self, options: nil)?.first as! SearchSubView
            _searchSubV.delegate = self
            _searchSubV.keyTextField.delegate = self
            self.view.addSubview(_searchSubV)
            _searchSubV.snp.makeConstraints { (maker) in
                maker.left.right.bottom.equalToSuperview()
                maker.top.equalToSuperview().offset(0)
            }
            _searchSubV.changeLocationBtn.addTarget(self, action: #selector(gotoSelecteCity), for: UIControlEvents.touchUpInside)
            self._searchSubV.currentLocationLabel.text = "当前城市：" + "石家庄"
            
            _searchSubV.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self._searchSubV.alpha = 1
            }
            self._searchSubV.deleteBtn.isHidden = true
        }
        
        //NotificationCenter.default.addObserver(self, selector: #selector(beginSearch), name: NSNotification.Name.init("doneAction"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isShowCommonAddress {
            self.getCommonAddress()
        }
    }
    
    private var commonAddressArr:NSArray!
    func getCommonAddress() {
        App_ZLZ_Helper.sendData(toServerUseUrl: "user/commonAddress/list", dataDict: [:], type: RequestType_Post, loadingTitle: "", sucessTitle: "", sucessBlock: { (responseObj) in
            
            self.commonAddressArr = responseObj?["data"] as! NSArray

            self._searchSubV.topConstarint.constant = 60
            
            let view:MiddleAddressView = MiddleAddressView()
            self._searchSubV.addSubview(view)
            view.snp.makeConstraints({ (maker) in
                maker.height.equalTo(60)
                maker.left.right.equalToSuperview()
                maker.bottom.equalTo(self._searchSubV.contentTableView.snp.top)
            })
            
            var tapGr = UITapGestureRecognizer.init(target: self, action: #selector(self.commonAddressClicked(tapGr:)))
            view.leftBottomLabel.superview?.tag = 1
            view.leftBottomLabel.superview?.addGestureRecognizer(tapGr)
            tapGr = UITapGestureRecognizer.init(target: self, action: #selector(self.commonAddressClicked(tapGr:)))
            view.rightBottomLabel.superview?.tag = 2
            view.rightBottomLabel.superview?.addGestureRecognizer(tapGr)
            
            if self.commonAddressArr.count == 1 {
                let dict = self.commonAddressArr[0] as! NSDictionary
                view.leftTopLabel.text = "\(dict["alias"]!)"
                view.leftBottomLabel.text = "\(dict["address"]!)"
                
            }
            if self.commonAddressArr.count == 2 {
                var dict = self.commonAddressArr[0] as! NSDictionary
                view.leftTopLabel.text = "\(dict["alias"]!)"
                view.leftBottomLabel.text = "\(dict["address"]!)"
                dict = self.commonAddressArr[1] as! NSDictionary
                view.rightTopLabel.text = "\(dict["alias"]!)"
                view.rightBottomLabel.text = "\(dict["address"]!)"
            }
        }) { (error) in
            
        }
    }
    
    @objc func commonAddressClicked(tapGr:UITapGestureRecognizer) {
        if tapGr.view?.tag == 1 {
            if self.commonAddressArr.count > 0 {
                let dict = self.commonAddressArr[tapGr.view!.tag - 1] as! NSDictionary
                self.selectedCommonAddressBlock?(dict)
                self.navigationController?.popViewController(animated: true)
            }else{
                //跳转到添加
                let cavc:CommonAddressViewController = CommonAddressViewController()
                cavc.countStr = "1"
                self.navigationController?.pushViewController(cavc, animated: true)
            }
        }
        if tapGr.view?.tag == 2 {
            if self.commonAddressArr.count > 1 {
                let dict = self.commonAddressArr[tapGr.view!.tag - 1] as! NSDictionary
                self.selectedCommonAddressBlock?(dict)
                self.navigationController?.popViewController(animated: true)
            }else{
                //跳转到添加
                let cavc:CommonAddressViewController = CommonAddressViewController()
                cavc.countStr = "2"
                self.navigationController?.pushViewController(cavc, animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func beginSearch() {
        //App_ZLZ_Helper.showLoadingView("搜索中...")
        //搜索服务
        /*
        let citySearchOption = BMKPOICitySearchOption()
        citySearchOption.pageIndex = 1
        citySearchOption.pageSize = 20
        citySearchOption.city = _cityName
        citySearchOption.keyword = _searchSubV.keyTextField.text!
        let flag = _baidu_map_poiSearch.poiSearch(inCity: citySearchOption)
        if flag {
            print("城市内检索发送成功！")
        }else{
            print("城市内检索发送失败！")
        }*/
        let searchManager = BMKSuggestionSearch()
        searchManager.delegate = self
        let option = BMKSuggestionSearchOption()
        option.keyword = _searchSubV.keyTextField.text!
        option.cityname = _cityName
        option.cityLimit = true
        let flag = searchManager.suggestionSearch(option)
        if flag {
            print("Sug检索发送成功！")
        }else{
            print("Sug检索发送失败！")
        }
    }
    
    //MARK: - SearchSubViewDelegate
    func selectedRow_SearchSubViewDelegate(_ point: BMKPoiInfo!) {
        //self.endLocaitonLabel.text = point.name
        print(point.pt.latitude)
        print(point.pt.longitude)
        self.lat = point.pt.latitude
        self.lon = point.pt.longitude
        self.selectedRowBlock!(point,point.pt.latitude,point.pt.longitude,self.isEnd)
        self.navigationController?.popViewController(animated: true)
    }
    func close_SearchSubViewDelegate() {
        self._searchSubV.keyTextField.text = ""
    }
    @objc func textChange() {
        /*
        print("verifyTextField.text = \(_searchSubV.keyTextField.text!)")
        if _searchSubV.keyTextField.text?.count != 0 {
            self._searchSubV.deleteBtn.isHidden = false
        }else{
            self._searchSubV.deleteBtn.isHidden = true
        }
        self.beginSearch()*/
        if _searchSubV.keyTextField.text?.count == 0 {
            _searchSubV.dataArr = NSArray.init(array: NSArray()) as! [Any]
            _searchSubV.contentTableView.reloadData()
            return;
        }
        
        print("verifyTextField.text = \(_searchSubV.keyTextField.text!)")
        
        if _searchSubV.keyTextField.markedTextRange == nil {
            self.beginSearch()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _searchSubV.keyTextField.resignFirstResponder()
        if _searchSubV.keyTextField.text?.count == 0 {
            return true
        }
        
        //self.beginSearch()
        
        /*
        //搜索服务
        let citySearchOption = BMKPOICitySearchOption()
        citySearchOption.pageIndex = 1
        citySearchOption.pageSize = 20
        citySearchOption.city = _cityName
        citySearchOption.keyword = _searchSubV.keyTextField.text!
        let flag = _baidu_map_poiSearch.poiSearch(inCity: citySearchOption)
        if flag {
            print("城市内检索发送成功！")
        }else{
            print("城市内检索发送失败！")
        }*/
        
        /*
         BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
         citySearchOption.pageIndex = curPage;
         citySearchOption.pageCapacity = 10;
         citySearchOption.city= @"北京";
         citySearchOption.keyword = @"小吃";
         //发起城市内POI检索
         BOOL flag = [_searcher poiSearchInCity:citySearchOption];
         if(flag) {
         NSLog(@"城市内检索发送成功");
         }
         else {
         NSLog(@"城市内检索发送失败");
         }
         */
        
        
        return true
    }
    
    //MARK: - BMKPoiSearchDelegate
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPOISearchResult!, errorCode: BMKSearchErrorCode) {
        
        App_ZLZ_Helper.removeLoadingView()
        if errorCode == BMK_SEARCH_NO_ERROR {
            _searchSubV.dataArr = NSArray.init(array: poiResult.poiInfoList) as! [Any]
            _searchSubV.contentTableView.reloadData()
        }else{
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("搜索出错，请重试！")
        }
    }
    
    //MARK: - BMKSuggestionSearchDelegate
    func onGetSuggestionResult(_ searcher: BMKSuggestionSearch!, result: BMKSuggestionResult!, errorCode error: BMKSearchErrorCode) {
        App_ZLZ_Helper.removeLoadingView()
        if error == BMK_SEARCH_NO_ERROR {
            //print("result keylist = \(result.keyList), = \(result.addressList), = \(result.ptList), = \(result.districtList), ==\(result.tagList),==\(result.poiIdList)")
            let arr = NSMutableArray()
            //arr.add(result.keyList!)
            //arr.add(result.ptList!)//CLLocationCoordinate2D
            //print("result arr = \(arr)")
            
            let newKeyList = NSMutableArray.init(array: result.keyList!)
            let newPtList = NSMutableArray.init(array: result.ptList!)
            
            if "\(result.districtList[0])".count == 0 {
                newKeyList.removeObject(at: 0)
                newPtList.removeObject(at: 0)
            }
            
            arr.add(newKeyList)
            arr.add(newPtList)
            
            _searchSubV.dataArr = arr as! [Any]
            _searchSubV.contentTableView.reloadData()
        }else{
            App_ZLZ_Helper.showErrorMessageAlertAutoGone("搜索出错，请重试！")
        }
    }
    
    var _searchSubV:SearchSubView!
    var _baidu_map_poiSearch:BMKPoiSearch!
    var _cityName = "石家庄"
    
    @objc func gotoSelecteCity() {
        
        let controller = CityViewController()
        controller.currentCityString = "石家庄"
        controller.selectString = { city in
            self._searchSubV.currentLocationLabel.text = "当前城市：" + city!
        }
        self.navigationController?.pushViewController(controller, animated: true)
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
