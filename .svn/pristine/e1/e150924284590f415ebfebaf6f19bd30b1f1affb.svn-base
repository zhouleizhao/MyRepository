//
//  UIView+Animation.m
//  chexingshanghu
//
//  Created by Apple on 16/10/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIView+Animation.h"
//#import <ShareSDKUI/ShareSDKUI.h>
//#import <ShareSDK/ShareSDK.h>
static UIButton *_cover;
@implementation UIView (Animation)

-(void)showAnimation{
    CLOUSEKEYBOARD;
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    keywindow.windowLevel = UIWindowLevelNormal;

    // 遮盖 为了只引用一次 造成部分提示不显示的问题
    // 遮盖
    if (!_cover) {
        UIButton *cover = [[UIButton alloc] init];
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0.2;
        [cover addTarget:self action:@selector(shouQiJianPan) forControlEvents:UIControlEventTouchUpInside];
        cover.frame = [UIScreen mainScreen].bounds;
        _cover = cover;
        
        [keywindow addSubview:_cover];
    }
    
    self.center = _cover.center;

    [keywindow addSubview:self];
    [keywindow bringSubviewToFront:self];
  
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.alpha = 0;
    [UIView animateWithDuration:.1 animations:^{
        
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)creatCover{
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.2;
    [cover addTarget:self action:@selector(shouQiJianPan) forControlEvents:UIControlEventTouchUpInside];
    cover.frame = [UIScreen mainScreen].bounds;
    _cover = cover;
    
}
- (void)Outanimated{
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
//    keywindow.windowLevel = UIWindowLevelAlert;
    [UIView animateWithDuration:.1 animations:^{
        
        [self removeFromSuperview];
        [_cover removeFromSuperview];
        _cover = nil;
    }];
    
}
- (void)shouQiJianPan{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self resignFirstResponder];
    [self endEditing:YES];
}
/*- (void)shareWithBaseURL:(NSURL *)url contentText:(NSString *)contentText AndTitle:(NSString *)title {
    
    
    NSArray* imageArray = @[[UIImage imageNamed:@"图标"]];
    if (imageArray.count >0) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:contentText
                                         images:imageArray
                                            url:url
                                          title:title
                                           type:3];
        
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction * okay = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                               [alert addAction:okay];
                               [CURRENT_NAVIGATIONCONTROLLER presentViewController:alert animated:YES completion:nil];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction * cacel = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
                               [alert addAction:cacel];
                               [CURRENT_NAVIGATIONCONTROLLER presentViewController:alert animated:YES completion:nil];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }
    
    
    
}*/

@end
