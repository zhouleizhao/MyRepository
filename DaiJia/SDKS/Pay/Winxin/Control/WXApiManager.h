//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#define WINXIN_PAY_SUCCESS @"WINXIN_PAY_SUCCESS"
#define WINXIN_PAY_FAILED @"WINXIN_PAY_FAILED"

@protocol WXApiManagerDelegate <NSObject>

@optional


@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;
- (void)registerWinxin;
- (void)payUsingData:(NSDictionary *)dict; //partnerId prepayId package nonceStr timeStamp sign

@end
