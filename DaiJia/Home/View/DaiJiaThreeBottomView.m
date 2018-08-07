//
//  DaiJiaThreeBottomView.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/7/27.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "DaiJiaThreeBottomView.h"

@implementation DaiJiaThreeBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"DaiJiaThreeBottomView" owner:self options:nil];
        UIView * view = [arr firstObject];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
