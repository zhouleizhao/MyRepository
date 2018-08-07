//
//  GeTuiHelper.m
//  融通天下
//
//  Created by MyApple on 27/03/2018.
//  Copyright © 2018 坤亚. All rights reserved.
//

#import "GeTuiHelper.h"
//#import "SaveNewViewController.h"
//#import "RescueMapViewController.h"
//#import "PostersView.h"
//#import "MobShareHelper.h"
#import <AudioToolbox/AudioToolbox.h>
//#import "VolunteersSaveInfoViewController.h"
//#import "CompleteRescueView.h"
//#import "GoToRescueViewController.h"
#import "LoginViewController.h"
@implementation GeTuiHelper
{
    int show_count;
}

GeTuiHelper * getui_helper = nil;

+ (GeTuiHelper *)getHelper {
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        getui_helper = [[GeTuiHelper alloc] init];
    });
    
    return getui_helper;
}

- (void)startGeTui{
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
}

#pragma mark - GeTuiSdkDelegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    self.clientID = clientId;
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"cid"];
    GETUSERINFO
    if (userInfo) {
        [self bindClientId];
    }else{
        NSLog(@"未登录不绑定个推ID！");
    }
}
- (void)bindClientId {
    //提交服务器
    if ([self.clientID isEqualToString:@""]) {
        [CommonAlertView showAlertWithMessage:@"CID为空，无法收到通知请重新打开APP尝试" AndTitle:@"温馨提示" Action:nil];
        return;
    }
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/protal/bindCid" dataDict:@{@"cid":self.clientID} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * responseObj) {
        NSLog(@"个推绑定Client ID成功！");
    } failedBlock:^(NSError * err) {
        NSLog(@"个推绑定Client ID失败！");
    }];
}
- (void)removeClientId:(void(^)(void))success{
    //提交服务器
//    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/bindingCid.do" dataDict:@{@"cId":@""} type:RequestType_Get loadingTitle:@"退出中..." sucessTitle:@"" sucessBlock:^(NSDictionary * responseObj) {
//        NSLog(@"个推解除绑定Client ID成功！");
//        success();
//    } failedBlock:^(NSError * err) {
//        NSLog(@"个推解除绑定Client ID失败！");
//    }];
}
/**
 *  SDK通知收到个推推送的透传消息
 *
 *  @param payloadData 推送消息内容
 *  @param taskId      推送消息的任务id
 *  @param msgId       推送消息的messageid
 *  @param offLine     是否是离线消息，YES.是离线消息
 *  @param appId       应用的appId
 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId
{
    
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSLog(@"收到个推消息:%@ taskId = %@",payloadMsg, taskId);
    
    if ([([UIApplication sharedApplication].keyWindow.rootViewController) isKindOfClass:[LoginViewController class]]) {
        return;
    }
    
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    AudioServicesPlaySystemSound(1000);
    [self playSoundEffect:@"9939.mp3"];
    
    //NSDictionary * dict = [App_ZLZ_Helper dictionaryWithJsonString:@"{ \"type\": \"3\", \"content\": \"您的救援已完成!\", \"id\": \"1\" } "];

    //[self goToViewController:[App_ZLZ_Helper dictionaryWithJsonString:payloadMsg]];
}
//- (void)goToViewController:(NSDictionary*)dict{
//    //[LoginViewController selectedViewController]: unrecognized selector sent to instance 0x164b7e20
//
//     UIViewController *baseVC = (UIViewController *)CURRENT_NAVIGATIONCONTROLLER.topViewController;
//    if ([[NSString stringWithFormat:@"%@", dict[@"type"]] isEqualToString:@"1"]) { //添加救援推送
//        if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:9028]) {
//            [[[[UIApplication sharedApplication] keyWindow] viewWithTag:9028] removeFromSuperview];
//            show_count ++;
//        }
//        if (show_count < 1) {
//            [ChooseAlertView showNewChooseViewWithTitle:@"温馨提示" ContentText:dict[@"data"] SureAction:^{
//                show_count = 0;
//                //跳转到详情页
//                VolunteersSaveInfoViewController * infoVC = [[VolunteersSaveInfoViewController alloc]init];
//                infoVC.rescuId = [NSString stringWithFormat:@"%@", dict[@"id"]];
//                [baseVC.navigationController pushViewController:infoVC animated:YES];
//
//            } AndCancelAction:^{
//                show_count = 0;
//            } SureTitle:@"查看详情" CancelTitle:@"知道了"];
//        }else{
//            [ChooseAlertView showNewChooseViewWithTitle:@"温馨提示" ContentText:dict[@"data"] SureAction:^{
//                show_count = 0;
//                GoToRescueViewController * gtrvc = [[GoToRescueViewController alloc] init];
//                [baseVC.navigationController pushViewController:gtrvc animated:true];
//
//            } AndCancelAction:^{
//                show_count = 0;
//            } SureTitle:@"查看救援列表" CancelTitle:@"知道了"];
//        }
//    }
//
//    if ([[NSString stringWithFormat:@"%@", dict[@"type"]] isEqualToString:@"2"] || [[NSString stringWithFormat:@"%@", dict[@"type"]] isEqualToString:@"3"]) { //接救援推送
//        //先判断程序是否在当前页面
//        if ([baseVC isKindOfClass:[RescueMapViewController class]]) {
//            //程序在当前页面
//            RescueMapViewController * vc = (RescueMapViewController *)baseVC;
//            [vc refreshState];
//        }else{
//            [ChooseAlertView showChooseViewWithTitle:@"提醒消息" ContentText:dict[@"data"] SureAction:^{
//
//                //程序不在当前页面，需跳转
//                [App_ZLZ_Helper sendDataToServerUseUrl:@"rescue/selectRescueDataByTypeAndUserId.do" dataDict:@{} type:RequestType_Get loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * responseObj) {
//                    NSString * status = [NSString stringWithFormat:@"%@", responseObj[@"data"][@"status"]];
//                    //未发起订单
//                    if ([status isEqualToString:@"0"]) {
//                        return;
//                    }
//                    RescueMapViewController * rmvc = [[RescueMapViewController alloc] init];
//                    rmvc.type = status.intValue;
//                    rmvc.dataDict = responseObj[@"data"];
//                    rmvc.launchTime = responseObj[@"data"][@"createtime"];
//                    rmvc.completeRescueBlock = ^{
//
//                        NSDictionary * dict = [App_ZLZ_Helper getUSERINFO];
//                        [RepresentPosterView showRepresentPosterViewWithUserModel:dict];
//
//                        //生成海报
//                        //跳转到完成评价界面
//                        /*
//                        UIView * bgV = [[UIView alloc] init];
//                        bgV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//                        [[UIApplication sharedApplication].keyWindow addSubview:bgV];
//                        [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.edges.equalTo(bgV.superview);
//                        }];
//                        PostersView * poster = [[PostersView alloc] init];
//                        [bgV addSubview:poster];
//
//                        [poster mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.left.mas_equalTo(10);
//                            make.right.mas_equalTo(-10);
//                            make.top.mas_equalTo(20);
//                            make.bottom.mas_equalTo(-20);
//                        }];
//                        poster.posterCancelBlock = ^{
//                            [bgV removeFromSuperview];
//                        };
//                        poster.posterShareBlock = ^(UIImage *shareImage) {
//                            [[MobShareHelper getHelper] shareLocalImage:shareImage title:@"我为公益代言"];
//                            [bgV removeFromSuperview];
//                        };*/
//
//                    };
//
//                    if (!(baseVC.tabBarController.tabBar.hidden)) {
//                        PUCHVC1(rmvc)
//                    }else{
//                        PUCHVC(rmvc);
//                    }
//                } failedBlock:^(NSError * error) {
//
//                }];
//
//            } AndCancelAction:^{
//
//            } SureTitle:@"查看详情" CancelTitle:@"知道了"];
//        }
//    }
//
//    if ([[NSString stringWithFormat:@"%@", dict[@"type"]] isEqualToString:@"4"]) { //救援完成
//        NSDictionary * dict1 = [App_ZLZ_Helper getUSERINFO];
//        //先判断程序是否在当前页面  如果在就需要返回
//        if ([baseVC isKindOfClass:[RescueMapViewController class]]) {
//            //程序在当前页面
//            [baseVC.navigationController popViewControllerAnimated:true];
//        }
//
//
//            [ChooseAlertView showChooseViewWithTitle:@"温馨提示" ContentText:dict[@"data"] SureAction:^{
//                NSLog(@"======%@",dict);
//                //            UIView * bgV1 = [[UIView alloc] init];
//                //            bgV1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//                //            [[UIApplication sharedApplication].keyWindow addSubview:bgV1];
//                //            [bgV1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                //                make.edges.equalTo(bgV1.superview);
//                //            }];
//                //            PostersView * poster = [[PostersView alloc] init];
//                //            [bgV1 addSubview:poster];
//                //
//                //            [poster mas_makeConstraints:^(MASConstraintMaker *make) {
//                //                make.left.mas_equalTo(10);
//                //                make.right.mas_equalTo(-10);
//                //                make.top.mas_equalTo(20);
//                //                make.bottom.mas_equalTo(-20);
//                //            }];
//                //            poster.posterCancelBlock = ^{
//                //                [bgV1 removeFromSuperview];
//                //            };
//                //            poster.posterShareBlock = ^(UIImage *shareImage) {
//                //                [[MobShareHelper getHelper] shareLocalImage:shareImage title:@"我为公益代言"];
//                //                [bgV1 removeFromSuperview];
//                //            };
//                NSMutableDictionary * mudic = [NSMutableDictionary dictionaryWithDictionary:dict1];
//                //            [mudic setValue:@"" forKey:@"content"];
//                [mudic addEntriesFromDictionary:@{@"content":[NSString stringWithFormat:@"我是%@，非常感谢公益援志愿者前来救援我，我愿意为公益代言！",dict1[@"nikename"]]}];
//                [RepresentPosterView showRepresentPosterViewWithUserModel:mudic];
//                [CompleteRescueView showReviewsView:^{
//
//                } andRescueId:dict[@"id"] andTags:@[@"整体感觉不错", @"志愿者太二贝", @"感觉好棒", @"志愿者不太健谈", @"暖男", @"没劲", @"有意思不"]];
//                /*
//                 //跳转到完成评价界面
//                 UIView * bgV = [[UIView alloc] init];
//                 bgV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//                 [[UIApplication sharedApplication].keyWindow addSubview:bgV];
//                 [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
//                 make.edges.equalTo(bgV.superview);
//                 }];
//
//                 CompleteRescueView * view = [[CompleteRescueView alloc] init];
//                 view.rescusId = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", dict[@"id"]]];
//                 [bgV addSubview:view];
//                 [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                 make.centerY.mas_equalTo(bgV);
//                 make.left.equalTo(bgV).offset(20);
//                 make.right.equalTo(bgV).offset(-20);
//                 make.height.mas_equalTo(250);
//                 }];
//
//                 view.completeBlock = ^{
//                 [bgV removeFromSuperview];
//                 UIView * bgV1 = [[UIView alloc] init];
//                 bgV1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//                 [[UIApplication sharedApplication].keyWindow addSubview:bgV1];
//                 [bgV1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                 make.edges.equalTo(bgV1.superview);
//                 }];
//                 PostersView * poster = [[PostersView alloc] init];
//                 [bgV1 addSubview:poster];
//
//                 [poster mas_makeConstraints:^(MASConstraintMaker *make) {
//                 make.left.mas_equalTo(10);
//                 make.right.mas_equalTo(-10);
//                 make.top.mas_equalTo(20);
//                 make.bottom.mas_equalTo(-20);
//                 }];
//                 poster.posterCancelBlock = ^{
//                 [bgV1 removeFromSuperview];
//                 };
//                 poster.posterShareBlock = ^(UIImage *shareImage) {
//                 [[MobShareHelper getHelper] shareLocalImage:shareImage title:@"我为公益代言"];
//                 [bgV1 removeFromSuperview];
//                 };
//                 };
//                 view.closeBlock = ^{
//                 [bgV removeFromSuperview];
//                 };*/
//
//            } AndCancelAction:^{
//
//            } SureTitle:@"评价一下" CancelTitle:@"残忍拒绝"];
//
//
//
//
//    }
//
//    if ([[NSString stringWithFormat:@"%@", dict[@"type"]] isEqualToString:@"5"]) { //限行
//
//        [CommonAlertView showAlertWithMessage:dict[@"data"] AndTitle:@"限行提醒" Action:nil];
//
//    }
//    if ([[NSString stringWithFormat:@"%@", dict[@"type"]] isEqualToString:@"6"]) { //账号在其他地方登陆
//        AppDelegate *app = [UIApplication sharedApplication].delegate;
//        UIWindow *window = app.window;
//        window.rootViewController = [LoginViewController new];
//        [CommonAlertView showAlertWithMessage:@"您的账号已在其他地方登陆，您已被强制下线" AndTitle:@"强制下线提醒" Action:^{
//
//        }];
//    }
//    if ([[NSString stringWithFormat:@"%@", dict[@"type"]] isEqualToString:@"7"]) { //审核消息
//
//        [CommonAlertView showAlertWithMessage:dict[@"data"] AndTitle:@"审核消息" Action:nil];
//
//    }
//    if ([[NSString stringWithFormat:@"%@", dict[@"type"]] isEqualToString:@"21"]) { //添加救援推送
//        if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:9028]) {
//            [[[[UIApplication sharedApplication] keyWindow] viewWithTag:9028] removeFromSuperview];
//            show_count ++;
//        }
//        if (show_count < 1) {
//            [ChooseAlertView showNewChooseViewWithTitle:@"温馨提示" ContentText:dict[@"data"] SureAction:^{
//                show_count = 0;
//                //跳转到详情页
//                VolunteersSaveInfoViewController * infoVC = [[VolunteersSaveInfoViewController alloc]init];
//                infoVC.rescuId = [NSString stringWithFormat:@"%@", dict[@"id"]];
//                [baseVC.navigationController pushViewController:infoVC animated:YES];
//
//            } AndCancelAction:^{
//                show_count = 0;
//            } SureTitle:@"查看详情" CancelTitle:@"知道了"];
//        }else{
//            [ChooseAlertView showNewChooseViewWithTitle:@"温馨提示" ContentText:dict[@"data"] SureAction:^{
//                show_count = 0;
//                GoToRescueViewController * gtrvc = [[GoToRescueViewController alloc] init];
//                [baseVC.navigationController pushViewController:gtrvc animated:true];
//
//            } AndCancelAction:^{
//                show_count = 0;
//            } SureTitle:@"查看救援列表" CancelTitle:@"知道了"];
//        }
//    }
//}

/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
    //4ea4bd0e851c6c509cb44877a7404241
}
/**
 * 播放音效文件
 *
 * @param name 音频文件名称 */
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl: 音频文件url
     * outSystemSoundID:声 id(此函数会将音效文件加入到系统音频服务中并返回一个长整形ID) */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作,可以调用如下方法注册一个播放完成回调函数 AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

@end
