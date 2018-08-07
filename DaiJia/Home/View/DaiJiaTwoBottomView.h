//
//  DaiJiaTwoBottomView.h
//  DaiJia
//
//  Created by GaoBingnan on 2018/7/27.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaiJiaTwoBottomView : UIView
@property (weak, nonatomic) IBOutlet UITextField *beginTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *carPhoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *driverNumberLabel;

@end
