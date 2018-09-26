//
//  JWAddressPickView.m
//  PickerView
//
//  Created by jw on 2017/11/29.
//  Copyright © 2017年 jw. All rights reserved.
//

#import "JWAddressPickerView1.h"
#import "DataBaseManager.h"

@interface JWAddressPickerView1 ()

@property (nonatomic, strong) NSDictionary *pickerDic;
/** 以后扩展功能会用到(记住选中的地址...待完善) */
@property (nonatomic, strong) NSArray *selectedArray;
/** 省份数组 */
@property (nonatomic, strong) NSArray *provinceArray;
/** 城市数组 */
@property (nonatomic, strong) NSArray *cityArray;
/** 地区数组 */
@property (nonatomic, strong) NSArray *townArray;
/** 省份数组 */
@property (nonatomic, strong) NSArray *provinceIdArray;
/** 城市数组 */
@property (nonatomic, strong) NSArray *cityIdArray;
/** 地区数组 */
@property (nonatomic, strong) NSArray *townIdArray;
/** 省 */
@property (nonatomic,copy) NSString *province;
/** 市 */
@property (nonatomic,copy) NSString *city;
/** 区 */
@property (nonatomic,copy) NSString *area;
/** 省 */
@property (nonatomic,copy) NSString *provinceId;
/** 市 */
@property (nonatomic,copy) NSString *cityId;
/** 区 */
@property (nonatomic,copy) NSString *areaId;
@end

@implementation JWAddressPickerView1

+ (instancetype)showWithAddressBlock:(AddressBlcok)block {
    JWAddressPickerView1 *pickerView = [[JWAddressPickerView1 alloc] init];
    pickerView.addressBlock = block;
    [pickerView show];
    return pickerView;
}

- (void)setupPickerView {
    [super setupPickerView];
    [self loadAddressData];
}
- (void)loadAddressData {
    DataBaseManager * manager = [[DataBaseManager alloc]init];
    [manager queryProvinceFromTable:@"province"];
    self.provinceArray = manager.provinceArray;
    self.provinceIdArray = manager.provinceIdArray;
    [manager queryCityFromTable:@"city" withID:@"2"];
    self.cityArray = manager.cityArray;
    self.cityIdArray = manager.cityIdArray;
    [manager queryTownFromTable:@"area" withID:@"3420"];
    self.townArray = manager.townArray;
    self.townIdArray = manager.townIdArray;

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width/3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    DataBaseManager * manager = [[DataBaseManager alloc]init];
    if (component == 0) {
        
        self.province = self.provinceArray[row];
        self.provinceId = self.provinceIdArray[row];
        [manager queryCityFromTable:@"city" withID:self.provinceIdArray[row]];
        self.cityArray = manager.cityArray;
        self.cityIdArray = manager.cityIdArray;
        if (self.cityArray.count > 0) {
            [manager queryTownFromTable:@"area" withID:[self.cityIdArray firstObject]];
            self.townArray = manager.townArray;
            self.townIdArray = manager.townIdArray;
        } else {
            self.townArray = @[];
        }
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    if (component == 1) {
          [manager queryTownFromTable:@"area" withID:self.cityIdArray[row]];
        self.townArray = manager.townArray;
        self.townIdArray = manager.townIdArray;
        self.city = self.cityArray[row];
        self.cityId = self.cityIdArray[row];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    if (component == 2) {
        self.area = self.townArray[row];
        self.areaId = self.townIdArray[row];
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
#pragma mark - 点击确定按钮
- (void)comfirmBtnClick {
    NSInteger selectProvince = [self.pickerView selectedRowInComponent:0];
    NSInteger selectCity     = [self.pickerView selectedRowInComponent:1];
    NSInteger selectArea     = [self.pickerView selectedRowInComponent:2];
    self.province = self.provinceArray[selectProvince];
    self.provinceId = self.provinceIdArray[selectProvince];
    self.city = self.cityArray[selectCity];
    self.cityId = self.cityIdArray[selectCity];
    
    if (self.townArray != nil && self.townArray.count != 0) {
        self.area = self.townArray[selectArea];
        self.areaId = self.townIdArray[selectArea];
    }else{
        self.area = @"";
        self.areaId = @"";
    }
    
    if (self.addressBlock) {
        self.addressBlock(self.province,self.city,self.area,self.provinceId,self.cityId,self.areaId);
    }
    [super comfirmBtnClick];
}

@end
