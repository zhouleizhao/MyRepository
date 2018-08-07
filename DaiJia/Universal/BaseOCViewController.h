//
//  BaseOCViewController.h
//  DaiJia
//
//  Created by MyApple on 29/06/2018.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseOCViewController : UIViewController

- (void)leftItemBtnClicked;
- (void)rightItemBtnClicked;
- (void)addRightItemBtnTitle:(NSString *)btnTitle andTitleColor:(UIColor *)color;
- (void)addRightItemBtnUseImg:(UIImage *)img andImageInsets:(UIEdgeInsets)insets;
- (void)addLeftItemBtnUseImg:(UIImage *)img andImageInsets:(UIEdgeInsets)insets;
/**
 服务器请求数据
 */
- (void)requestDataFromServer;

@end
