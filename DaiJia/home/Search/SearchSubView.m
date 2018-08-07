//
//  SearchSubView.m
//  QuickDog
//
//  Created by MyApple on 11/05/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

#import "SearchSubView.h"

@interface SearchSubView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SearchSubView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)closeBtnClicked:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(close_SearchSubViewDelegate)]) {
        [_delegate close_SearchSubViewDelegate];
    }
    /*
    [self.keyTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self->_delegate != nil && [self->_delegate respondsToSelector:@selector(close_SearchSubViewDelegate)]) {
            [self->_delegate close_SearchSubViewDelegate];
        }
    }];*/
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zhouleizhao"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:nil options:nil] firstObject];
    }
   
    
    BMKPoiInfo * point = self.dataArr[indexPath.row];
    NSLog(@"distance = %ld", (long)point.detailInfo.distance);
    cell.topLabel.text = point.name;
    cell.bottomLabel.text = point.address;
    
    return cell;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
    bgV.backgroundColor = [UIColor whiteColor];
    UILabel * l = [[UILabel alloc] init];
    l.font = [UIFont systemFontOfSize:15];
    l.textColor = [App_ZLZ_Helper getMainStyleColor];
    l.text = @"搜索结果:";
    [bgV addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgV);
        make.left.equalTo(bgV).offset(10);
    }];
    
    [l sizeToFit];
    return bgV;
}*/

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(selectedRow_SearchSubViewDelegate:)]) {
        [self closeBtnClicked:nil];
        
        
        BMKPoiInfo * point = self.dataArr[indexPath.row];
        [_delegate selectedRow_SearchSubViewDelegate:point];
    }
}

@end
