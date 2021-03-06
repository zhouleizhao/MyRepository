//
//  OrderTableViewCell.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/12.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)bindData:(NSDictionary *)dic{
    if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"1"]){
        self.orderTypeLabel.text = @"代驾";
    }else if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"2"]){
        self.orderTypeLabel.text = @"预约";
    }else if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"3"]){
        self.orderTypeLabel.text = @"代叫";
    }else if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"4"]){
        self.orderTypeLabel.text = @"司机主动下订单";
    }
    self.dateLabel.text = dic[@"createTime"];
    self.beginAddressLabel.text = dic[@"startAddress"];
    self.endAddressLabel.text = dic[@"endAddress"];
    //等待派单  正常单、代叫是0  预约-1
    if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"-1"]) {
        if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"2"]){
            self.orderStatusLabel.text = @"等待派单";
        }
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"0"]) {
        if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"2"]||[[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"4"]) {
            self.orderStatusLabel.text = @"等待派单";
        }else{
            self.orderStatusLabel.text = @"";
        }
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"1"]) {
        self.orderStatusLabel.text = @"已派单";
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"2"]||[[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"3"]||[[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"4"]||[[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"5"]) {
        self.orderStatusLabel.text = @"服务中";
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"6"]||[[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"7"]||[[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"8"]||[[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"9"]) {
        self.orderStatusLabel.text = @"待付款";
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"10"]) {
        self.orderStatusLabel.text = @"已完成";
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"11"]) {
        self.orderStatusLabel.text = @"本人取消";
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"12"]) {
        self.orderStatusLabel.text = @"司机取消";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
