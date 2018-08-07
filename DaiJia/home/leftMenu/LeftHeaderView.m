//
//  LeftHeaderView.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/12.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "LeftHeaderView.h"

@implementation LeftHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"LeftHeaderView" owner:self options:nil];
        UIView * view = [arr firstObject];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self loadData];
        
    }
    return self;
}
- (void)bindData{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    [self.userIconImageView sd_setImageWithURLNew:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.userNameLabel.text = dic[@"registerName"];
    NSString * phone = dic[@"phonenumber"];
    phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.userPhoneLabel.text = phone;
}
- (void)loadData{
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/info/acquire" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * resObj) {
        [[NSUserDefaults standardUserDefaults] setObject:resObj[@"data"] forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self bindData];
    } failedBlock:^(NSError * error) {
        [self bindData];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
