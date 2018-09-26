//
//  JWAddressPickerView1.h
//  zhongChou
//
//  Created by GaoBingNan on 2018/1/11.
//  Copyright © 2018年 GaoBingNan. All rights reserved.
//

#import "BasePickerView.h"

typedef void(^AddressBlcok)(NSString *province,NSString *city,NSString *area,NSString *provinceId,NSString *cityId,NSString *areaId);
@interface JWAddressPickerView1 : BasePickerView
/** 回调block */
@property (nonatomic, copy) AddressBlcok addressBlock;
+ (instancetype)showWithAddressBlock:(AddressBlcok)block;

@end
