//
//  DCDataPickerView.h
//  DaiJia
//
//  Created by GaoBingnan on 2018/7/27.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DCDataPickerView;
@protocol DCDatePickerViewDelegate <NSObject>
// 代理方法
-(void)pickerDate:(DCDataPickerView *)pickerArea dayStr:(NSString *)dayStr houStr:(NSString *)houStr minStr:(NSString *)minStr;
@end

@interface DCDataPickerView : UIView
@property(weak,nonatomic)id<DCDatePickerViewDelegate>delegate;

@end

