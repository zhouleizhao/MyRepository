//
//  CheckAppVersionManager.m
//  QuickDog
//
//  Created by MyApple on 30/05/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

#import "CheckAppVersionManager.h"

#define APP_ID @"1434370922"

@implementation CheckAppVersionManager
+ (CheckAppVersionManager *)sharedManager
{
    static CheckAppVersionManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[CheckAppVersionManager alloc] init];
        
    });
    
    return instance;
}

//判断是否需要提示更新App
- (void)shareAppVersionAlert:(BOOL)isShowError {
    if (!isShowError) {
        if(![self judgeNeedVersionUpdate])  return ;
    }
    if (isShowError) {
        [App_ZLZ_Helper showLoadingView:@"请求中..."];
    }
    //App内info.plist文件里面版本号
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = infoDict[@"CFBundleShortVersionString"];
    //NSString *bundleId   = infoDict[@"CFBundleIdentifier"];
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", APP_ID];
    //两种请求appStore最新版本app信息 通过bundleId与appleId判断
    //[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?bundleid=%@", bundleId]
    //[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", appleid]
    NSURL *urlStr = [NSURL URLWithString:urlString];
    //创建请求体
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlStr];
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error1) {
        if (isShowError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [App_ZLZ_Helper removeLoadingView];
            });
        }
        if (error1) {
            //            NSLog(@"connectionError->%@", connectionError.localizedDescription);
            if (isShowError) {
                [self showErrorAlert];
            }
            return ;
        }
        NSError *error;
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            //            NSLog(@"error->%@", error.localizedDescription);
            if (isShowError) {
                [self showErrorAlert];
            }
            return;
        }
        NSArray *sourceArray = resultsDict[@"results"];
        if (sourceArray.count >= 1) {
            //AppStore内最新App的版本号
            NSDictionary *sourceDict = sourceArray[0];
            NSString *newVersion = sourceDict[@"version"];
            if ([self judgeNewVersion:newVersion withOldVersion:appVersion])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ChooseAlertView showChooseViewWithTitle:@"温馨提示" ContentText:@"您的App不是最新版本，是否更新？" SureAction:^{
                        //跳转到AppStore，该App下载界面
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sourceDict[@"trackViewUrl"]]];
                    } AndCancelAction:^{
                        
                    } SureTitle:@"去更新" CancelTitle:@"暂不更新"];
                });
            }
        }else{
            if (isShowError) {
                [self showErrorAlert];
            }
        }
    }];
    
    [task resume];
    
}
- (void)showErrorAlert{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CommonAlertView showAlertWithMessage:@"暂无更新！" AndTitle:@"温馨提示" Action:^{
            
        }];
    });
}
//每天进行一次版本判断
- (BOOL)judgeNeedVersionUpdate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //获取年-月-日
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *currentDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"];
    if ([currentDate isEqualToString:dateString]) {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"currentDate"];
    return YES;
}
//判断当前app版本和AppStore最新app版本大小
- (BOOL)judgeNewVersion:(NSString *)newVersion withOldVersion:(NSString *)oldVersion {
    NSArray *newArray = [newVersion componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    NSArray *oldArray = [oldVersion componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    for (NSInteger i = 0; i < newArray.count; i ++) {
        if ([newArray[i] integerValue] > [oldArray[i] integerValue]) {
            return YES;
        } else if ([newArray[i] integerValue] < [oldArray[i] integerValue]) {
            return NO;
        } else { }
    }
    return NO;
}

@end
