//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)registerWinxin {
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    [WXApi registerApp:@"wx28260208a22a8046"];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:WINXIN_PAY_SUCCESS object:nil];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [[NSNotificationCenter defaultCenter] postNotificationName:WINXIN_PAY_FAILED object:nil];
                break;
        }
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:strTitle message:strMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
    }else {
    }
}

- (void)onReq:(BaseReq *)req {
    
}

- (void)payUsingData:(NSDictionary *)dict {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = dict[@"partnerId"];
    request.prepayId= dict[@"prepayId"];
    request.package = dict[@"package"];
    request.nonceStr= dict[@"nonceStr"];
    request.timeStamp= [NSString stringWithFormat:@"%@", dict[@"timeStamp"]].intValue;
    request.sign= dict[@"sign"];
    [WXApi sendReq:request];
} //partnerId prepayId package nonceStr timeStamp sign

@end
