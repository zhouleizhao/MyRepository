//
//  CommonAlertView.m
//  chexingshanghu
//
//  Created by Apple on 16/10/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CommonAlertView.h"

static UIButton *_cover;
@interface CommonAlertView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic ,strong) Action action;
@end
@implementation CommonAlertView
+(void)showAlertWithMessage:(NSString *)message AndTitle:(NSString *)title Action:(Action)action{
    CommonAlertView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CommonAlertView class]) owner:nil options:nil] lastObject];
    
    
    CGSize size = [message boundingRectWithSize:CGSizeMake(300-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
   
    view.action = ^(){
        
        if (action) {
            action();
        }
    };
    
    view.frame = CGRectMake(0, 0, SCREENWidth-50, size.height+140+10);
    view.titleLabel.text = title;
    view.messageLabel.text = message;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    
    [view showAnimation];
    view.sureBtn.backgroundColor = ZHUTICOLOR;
    
}
+(void)showAlertWithMessage:(NSString *)message AndTitle:(NSString *)title{

    CommonAlertView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CommonAlertView class]) owner:nil options:nil] lastObject];
    
   
    CGSize size = [message boundingRectWithSize:CGSizeMake(300-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    view.frame = CGRectMake(0, 0, SCREENWidth-50, size.height+140);
    view.titleLabel.text = title;
    view.messageLabel.text = message;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    
    [view showAnimation];

}
- (IBAction)outAlert:(UIButton *)sender {
    _action();
    [self Outanimated];
}

- (void)shouQiJianPan{


}
@end
