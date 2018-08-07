//
//  AppDelegate.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/8.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "NearbyViewController.h"
#import "LeftSortViewController.h"
#import "LeftSlideViewController.h"
#import "GeTuiHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
@interface AppDelegate ()<BMKGeneralDelegate>{
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initBaiDuMap];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.mainNC = [[CustomNavigationViewController alloc] initWithRootViewController:[NearbyViewController new]];
    LeftSortViewController * leftSoutVC = [[LeftSortViewController alloc]init];
    CustomNavigationViewController * leftNC = [[CustomNavigationViewController alloc]initWithRootViewController:leftSoutVC];
    
    self.leftSlideVC = [[LeftSlideViewController alloc]initWithLeftView:leftNC andMainView:self.mainNC];
    self.leftSlideVC.title = @"左视图";
    
    self.window.rootViewController = self.leftSlideVC;
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"BackImage"] forBarMetrics:UIBarMetricsDefault];
    [self.window makeKeyAndVisible];
    [[GeTuiHelper getHelper] startGeTui];
    return YES;
}
- (void)initBaiDuMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    BOOL ret = [_mapManager start:BAIDU_MAP_APPKEY generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//pragma mark - alipay
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSLog(@"pay reslut = %@",resultDic);
            NSString * memo = resultDic[@"memo"];
            NSLog(@"===memo:%@", memo);
            
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                
                NSString * str = @"支付成功！";
                [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:PAY_SUCCESS_NOTIFICATION object:nil];
                    //[[NSNotificationCenter defaultCenter] removeObserver:[App_ZLZ_Helper getHelper].payViewController name:PAY_SUCCESS_NOTIFICATION object:nil];
                }];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderManagementViewControllerRefresh" object:@"1"];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderManagementViewControllerRefresh" object:@"0"];
                NSString *resultStatus = resultDic[@"resultStatus"];
                NSString * str = @"";
                if ([resultStatus isEqualToString:@"9000"]) {
                    
                }else if ([resultStatus isEqualToString:@"6002"])
                {
                    str = @"网络连接出现错误！";
                    [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                        
                    }];
                }
                else if ([resultStatus isEqualToString:@"8000"])
                {
                    str = @"正在处理中！";
                    [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                        
                    }];
                }
                else if ([resultStatus isEqualToString:@"4000"])
                {
                    str = @"订单支付失败！";
                    [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                        
                    }];
                }
                else if ([resultStatus isEqualToString:@"6001"])
                {
                    str = @"您中途取消了支付！";
                    [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                        
                    }];
                }
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else{
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSLog(@"pay reslut = %@",resultDic);
            NSString * memo = resultDic[@"memo"];
            NSLog(@"===memo:%@", memo);
            
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                
                NSString * str = @"支付成功！";
                
                [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:PAY_SUCCESS_NOTIFICATION object:nil];
                    //[[NSNotificationCenter defaultCenter] removeObserver:[App_ZLZ_Helper getHelper].payViewController name:PAY_SUCCESS_NOTIFICATION object:nil];
                }];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderManagementViewControllerRefresh" object:@"1"];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderManagementViewControllerRefresh" object:@"0"];
                NSString *resultStatus = resultDic[@"resultStatus"];
                NSString * str = @"";
                if ([resultStatus isEqualToString:@"9000"]) {
                    
                }else if ([resultStatus isEqualToString:@"6002"])
                {
                    str = @"网络连接出现错误！";
                    [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                        
                    }];
                }
                else if ([resultStatus isEqualToString:@"8000"])
                {
                    str = @"正在处理中！";
                    [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                        
                    }];
                }
                else if ([resultStatus isEqualToString:@"4000"])
                {
                    str = @"订单支付失败！";
                    [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                        
                    }];
                }
                else if ([resultStatus isEqualToString:@"6001"])
                {
                    str = @"您中途取消了支付！";
                    [CommonAlertView showAlertWithMessage:str AndTitle:@"支付结果" Action:^{
                        
                    }];
                }
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else{
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}


@end
