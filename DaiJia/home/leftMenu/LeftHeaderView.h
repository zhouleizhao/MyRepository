//
//  LeftHeaderView.h
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/12.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
- (void)bindData;
@end
