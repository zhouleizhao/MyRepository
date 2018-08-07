//
//  ChooseAlertView.m
//  chexinghshanghu
//
//  Created by Apple on 16/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChooseAlertView.h"

@interface ChooseAlertView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cntentLabel;
//确定事件
@property (nonatomic ,strong) Action action;
//取消事件
@property (nonatomic ,strong) Action cAction;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@end
@implementation ChooseAlertView
+(void)showChooseViewWithTitle:(NSString *)title ContentText:(NSString *)content AndSureAction:(Action)action{
       
 ChooseAlertView *chooseView = [[NSBundle mainBundle] loadNibNamed:@"ChooseAlertView" owner:nil options:nil].firstObject;
    chooseView.cancleButton.backgroundColor = ZHUTICOLOR;
    chooseView.doneButton.backgroundColor = ZHUTICOLOR;
    chooseView.titleLabel.text = title;
    chooseView.cntentLabel.text = content;
  chooseView.frame = CGRectMake(0, 0, SCREENWidth-50, 200);

    chooseView.action = ^(){
        action();
    };
    chooseView.cAction = ^(){
        
//        cancelAction();
        
        
    };
    
    [chooseView showAnimation];
    
}
+(void)showChooseViewWithTitle:(NSString *)title ContentText:(NSString *)content SureAction:(Action)sureAction AndCancelAction:(Action)cancelAction{
    
    ChooseAlertView *chooseView = [[NSBundle mainBundle] loadNibNamed:@"ChooseAlertView" owner:nil options:nil].firstObject;
    chooseView.cancleButton.backgroundColor = ZHUTICOLOR;
    chooseView.doneButton.backgroundColor = ZHUTICOLOR;
    chooseView.titleLabel.text = title;
    chooseView.cntentLabel.text = content;
    chooseView.frame = CGRectMake(0, 0, SCREENWidth-50, 200);
    
    
    chooseView.action = ^(){
        sureAction();
    };
    chooseView.cAction = ^(){
  
            cancelAction();
    
       
    };
    
    
    [chooseView showAnimation];

}
+ (void)showChooseViewWithTitle:(NSString *)title ContentText:(NSString *)content SureAction:(Action)sureAction AndCancelAction:(Action)cancelAction SureTitle:(NSString *)sureTitle CancelTitle:(NSString *)cancelTitle{
    ChooseAlertView *chooseView = [[NSBundle mainBundle] loadNibNamed:@"ChooseAlertView" owner:nil options:nil].firstObject;
    chooseView.cancleButton.backgroundColor = ZHUTICOLOR;
    chooseView.doneButton.backgroundColor = ZHUTICOLOR;
    chooseView.titleLabel.text = title;
    chooseView.cntentLabel.text = content;
    chooseView.frame = CGRectMake(0, 0, SCREENWidth-50, 200);
    [chooseView.doneButton setTitle:sureTitle forState:UIControlStateNormal];
    [chooseView.cancleButton setTitle:cancelTitle forState:UIControlStateNormal];
    
    chooseView.action = ^(){
        sureAction();
    };
    chooseView.cAction = ^(){
        
        cancelAction();
        
        
    };
    
    
    [chooseView showAnimation];
}
- (IBAction)candelBtnDidClick:(UIButton *)sender {
    _cAction();
    [self Outanimated];
}
- (IBAction)sureBtnDidClick:(UIButton *)sender {
    
    _action();
    [self Outanimated];
}


@end
