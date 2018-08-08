//
//  PayPageViewController.h
//  DaiJia
//
//  Created by GaoBingnan on 2018/7/26.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *driverImageView;
@property (weak, nonatomic) IBOutlet UILabel *driverNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *driverPhoneButton;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *qiBuJiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *liChengLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet UILabel *youHuiLabel;
@property (weak, nonatomic) IBOutlet UIButton *yuEButton;
@property (weak, nonatomic) IBOutlet UIButton *weiXinButton;
@property (weak, nonatomic) IBOutlet UIButton *zhiFuBaoButton;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fiveImageView;
@property (nonatomic,strong) NSString * orderNum;
@property (weak, nonatomic) IBOutlet UILabel *zongLiShuLabel;
@property (weak, nonatomic) IBOutlet UIButton *youHuiButton;
@property (weak, nonatomic) IBOutlet UILabel *eLieLabel;
@property (weak, nonatomic) IBOutlet UIView *hideView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic,assign) BOOL isOrder;
@end
