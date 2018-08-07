//
//  ChooseAlertView.h
//  chexinghshanghu
//
//  Created by Apple on 16/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Action)(void);
@interface ChooseAlertView : UIView

+ (void) showChooseViewWithTitle:(NSString *)title ContentText:(NSString *)content AndSureAction:(Action)action;
+ (void) showChooseViewWithTitle:(NSString *)title ContentText:(NSString *)content SureAction:(Action)sureAction AndCancelAction:(Action)cancelAction;
+ (void) showChooseViewWithTitle:(NSString *)title ContentText:(NSString *)content SureAction:(Action)sureAction AndCancelAction:(Action)cancelAction SureTitle:(NSString *)sureTitle CancelTitle:(NSString *)cancelTitle;
@end
