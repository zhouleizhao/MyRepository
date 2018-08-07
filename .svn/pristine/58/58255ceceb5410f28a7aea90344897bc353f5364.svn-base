//
//  GeTuiHelper.h
//  融通天下
//
//  Created by MyApple on 27/03/2018.
//  Copyright © 2018 坤亚. All rights reserved.
//

#import <Foundation/Foundation.h>

//个推
#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用
/// 使用个推回调时，需要添加"GeTuiSdkDelegate"
/// iOS 10 及以上环境，需要添加 UNUserNotificationCenterDelegate 协议，才能使用 UserNotifications.framework 的回调
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
#define kGtAppId           @"iN8rqWIzuJAlxFBKC8SpH2"
#define kGtAppKey          @"dM7QjE4Rhn9NbvBNfb74F8"
#define kGtAppSecret       @"I3L7uVftkF61r5FIwI3vkA"

@interface GeTuiHelper : NSObject <GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, retain) NSString * clientID;

+ (GeTuiHelper *)getHelper;

- (void)startGeTui;
/** 注册 APNs */
- (void)registerRemoteNotification;
/** 绑定服务器 */
- (void)bindClientId;
/** 解除绑定服务器 退出登录需要调用*/
- (void)removeClientId:(void(^)(void))success;

@end
