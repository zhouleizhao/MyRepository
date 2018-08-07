//
//  AppDelegate.h
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/8.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "CustomNavigationViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CustomNavigationViewController * mainNC;
@property (nonatomic, strong) LeftSlideViewController * leftSlideVC;

@end

