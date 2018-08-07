//
//  DCDataPickerView.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/7/27.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "DCDataPickerView.h"
#define ZY_THEMEColor  [UIColor colorWithRed:((0xfe8a4d & 0xFF0000) >> 16)/255.0 green:((0xfe8a4d & 0xFF00) >> 8)/255.0 blue:((0xfe8a4d & 0xFF)/255.0) alpha:1]

@interface DCDataPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

// 三个pickerView的数据源
@property(strong,nonatomic)NSMutableArray * firstArray;
@property(strong,nonatomic)NSMutableArray * secondArray;
@property(strong,nonatomic)NSMutableArray * thirdArray;
@property(strong,nonatomic)UIView  * pickerView;//用来放pickerView
@end

@implementation DCDataPickerView
{
    UIPickerView * dayPickerView;
    UIPickerView * houPickerView;
    UIPickerView * minPickerView;
    NSInteger      currentHour;   // (当前时间几点钟)
    NSInteger      currentMins;   // (当前点的分钟数)
    
    // 存选中后返回的的内容
    NSString     * dayStr;
    NSString     * houStr;
    NSString     * minStr;
}
// 初始化方法，外界就是用这个方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        dayStr = @"温馨提示,赋值错误";
        houStr = @"温馨提示,赋值错误";
        minStr = @"温馨提示,赋值错误";
        [self setOwn];                    // 设置self
        [self initDataSource];            // 初始化数据源
        [self initAroundTheView];         // UI
        [self initPickerView];            // pickerView
    }
    return self;
}

#pragma mark -- dataSource
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == dayPickerView) {
        return self.firstArray.count;
    }
    if (pickerView == houPickerView) {
        return self.secondArray.count;
    }
    if (pickerView == minPickerView) {
        return self.thirdArray.count;
    }else return 1;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
#pragma make -- delegate
// 每行高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return (pickerView.frame.size.height-20) / 3;
}
// 选中某行的时候
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    // 滑动第一列清除第二三列数据，重新赋值
    if (pickerView == dayPickerView) {
        if (row == 0) {  // 当选中的row为第一行的时候也就是今天，需要加上现在
            if (![self.secondArray[0] isEqualToString:@"现在"]) { // 数据中没有“现在”
                [self.secondArray removeAllObjects];
                
                [self.secondArray insertObject:@"现在" atIndex:0];
                for (int i = 0; i < 24 ; i++) {  // 24小时，根据当前时间赋值
                    if (i > currentHour) {
                        if (i < 10) {
                            [self.secondArray addObject:[NSString stringWithFormat:@"0%ld点",(long)i]];
                        }else{
                            [self.secondArray addObject:[NSString stringWithFormat:@"%ld点",(long)i]];
                        }
                    }
                }
                
            }
            if (![self.thirdArray[0] isEqualToString:@"现在"]) {
                [self.thirdArray removeAllObjects];
                [self.thirdArray insertObject:@"现在" atIndex:0];
                for (int i = 0; i < 60; i+=10) {
                    if (i > currentMins) {
                        if (i / 10 == 0) {
                            [self.thirdArray addObject:[NSString stringWithFormat:@"0%d分",i]];
                        }else{
                            [self.thirdArray addObject:[NSString stringWithFormat:@"%d分",i / 10 * 10]];
                        }
                    }
                }
            }
        }else{
            // 选中的不是第一行的时候也就是明天后天就需要删除现在，并且改成24小时
            [self.secondArray removeAllObjects];
            [self.thirdArray removeAllObjects];
            for (int i = 0; i < 6; i++) {
                if (i == 0) {
                    [self.thirdArray addObject:[NSString stringWithFormat:@"0%d分",i]];
                }else{
                    [self.thirdArray addObject:[NSString stringWithFormat:@"%d分",i * 10]];
                }
            }
            for (int i = 0; i < 24 ; i++) {
                if (i < 10) {
                    [self.secondArray addObject:[NSString stringWithFormat:@"0%ld点",(long)i]];
                }else{
                    [self.secondArray addObject:[NSString stringWithFormat:@"%ld点",(long)i]];
                }
            }
            
        }
        [houPickerView reloadAllComponents];
        [minPickerView reloadAllComponents];
    }
    if (pickerView == houPickerView) {
        if (row == 0) {  // 当选中的row为第一行的时候也就是今天，需要加上现在
            if (![self.thirdArray[0] isEqualToString:@"现在"]) {
                [self.thirdArray removeAllObjects];
                [self.thirdArray insertObject:@"现在" atIndex:0];
                for (int i = 0; i < 60; i+=10) {
                    if (i > currentMins) {
                        if (i / 10 == 0) {
                            [self.thirdArray addObject:[NSString stringWithFormat:@"0%d分",i]];
                        }else{
                            [self.thirdArray addObject:[NSString stringWithFormat:@"%d分",i / 10 * 10]];
                        }
                    }
                }
            }
        }else{
            [self.thirdArray removeAllObjects];
            for (int i = 0; i < 6; i++) {
                if (i == 0) {
                    [self.thirdArray addObject:[NSString stringWithFormat:@"0%d分",i]];
                }else{
                    [self.thirdArray addObject:[NSString stringWithFormat:@"%d分",i * 10]];
                }
            }
        }
        [minPickerView reloadAllComponents];
    }
    [self reloaData];  // 获取选中的时间
}
// 选中row样式
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // 选中的一行
    UILabel *selectedLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
    selectedLabel.textColor = ZY_THEMEColor;
    
    // 分割线设置
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = ZY_THEMEColor;
        }
    }
    
    UILabel * rowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, (self.frame.size.width - 200) / 3, self.frame.size.height / 3 - 2)];
    rowLabel.textAlignment = NSTextAlignmentCenter;
    rowLabel.backgroundColor = [UIColor whiteColor];
    rowLabel.adjustsFontSizeToFitWidth = YES;
    rowLabel.font = [UIFont systemFontOfSize:15];
    rowLabel.textColor = [UIColor blackColor];
    rowLabel.backgroundColor = [UIColor clearColor];
    [rowLabel sizeToFit];
    
    if (pickerView == dayPickerView) {
        rowLabel.text = self.firstArray[row];
        [self reloaData];
        return rowLabel;
    }
    if (pickerView == houPickerView) {
        rowLabel.text = self.secondArray[row];
        [self reloaData];
        return rowLabel;
    }
    if (pickerView == minPickerView) {
        rowLabel.text = self.thirdArray[row];
        [self reloaData];
        return rowLabel;
    }else return nil;
}
#pragma mark -- 数据
-(void)initDataSource{
    // 第一列的数据源
    self.firstArray = [NSMutableArray arrayWithObjects:@"今天",@"明天",@"后天", nil];
    self.secondArray = [NSMutableArray array];
    self.thirdArray  = [NSMutableArray array];
    
    // 第二第三列的
    NSDate * date = [NSDate date];  // 当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH"]; // 当前几点
    NSInteger currentHh  = [dateFormatter stringFromDate:date].integerValue;
    [dateFormatter setDateFormat:@"mm"];// 当前点几分钟
    NSInteger currentMn  = [dateFormatter stringFromDate:date].integerValue;
    
    currentHour = currentHh;
    currentMins = currentMn;
    
    [self.secondArray addObject:@"现在"];
    for (int i = 0; i < 24 ; i++) {
        if (i > currentHh) {
            if (i < 10) {
                [self.secondArray addObject:[NSString stringWithFormat:@"0%ld点",(long)i]];
            }else{
                [self.secondArray addObject:[NSString stringWithFormat:@"%ld点",(long)i]];
            }
        }
    }
    
    [self.thirdArray addObject:@"现在"];
    for (int i = 0; i < 60; i+=10) {
        if (i > currentMn) {
            if (i / 10 == 0) {
                [self.thirdArray addObject:[NSString stringWithFormat:@"0%d分",i]];
            }else{
                [self.thirdArray addObject:[NSString stringWithFormat:@"%d分",i / 10 * 10]];
            }
        }
    }
}

#pragma mark -- UI绘制
-(void)initPickerView{
    
    CGFloat intervalSize = 50;
    CGFloat pickerWidth = (self.pickerView.frame.size.width - 200) /3;
    CGFloat pickerHeigh = self.pickerView.frame.size.height - 20;
    
    dayPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(50, 10, pickerWidth,pickerHeigh)];
    dayPickerView.delegate = self;
    dayPickerView.dataSource = self;
    [self.pickerView addSubview:dayPickerView];
    
    houPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dayPickerView.frame)+intervalSize, 10, pickerWidth, pickerHeigh)];
    houPickerView.delegate = self;
    houPickerView.dataSource = self;
    [self.pickerView addSubview:houPickerView];
    
    minPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(houPickerView.frame)+intervalSize, 10, pickerWidth, pickerHeigh)];
    minPickerView.delegate = self;
    minPickerView.dataSource = self;
    [self.pickerView addSubview:minPickerView];
}


-(void)initAroundTheView{
    
    CGFloat  titW    = self.frame.size.width;
    CGFloat  titH    = self.frame.size.height * 0.15;
    CGFloat  pickerH = self.frame.size.height *0.5;
    CGFloat  lineH   = 1;
    //CGFloat  bottomH = self.frame.size.height - titH - pickerH - lineH * 2;
    
    
    // 标题View
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,titW, titH)];
    lab.text = @"选择预约时间";
    lab.textColor = [UIColor darkGrayColor];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    
    
    // 上边的分割线
    UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0,titH, titW, 1)];
    topLine.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
    [self addSubview:topLine];
    
    
    // pickerView
    self.pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, topLine.frame.origin.y+1, titW, pickerH)];
    [self addSubview:self.pickerView];
    
    
    // 下边的分割线
    UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.pickerView.frame.origin.y+pickerH, titW, 1)];
    bottomLine.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
    [self addSubview:bottomLine];
    
    
    // 最下边装btn的View
    CGFloat bottomViewHeight = self.frame.size.height * 0.21;
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,bottomLine.frame.origin.y+1, titW, bottomViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    
    // 两个btn之间的分割线
    UIView * verticalLine = [[UIView alloc]initWithFrame:CGRectMake(titW / 2 -0.5,0, 1,bottomViewHeight)];
    verticalLine.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
    [bottomView addSubview:verticalLine];
    
    // 左边的btn
    CGFloat btnW = (self.frame.size.width -1)/2;
    UIButton * leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    [leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    leftBtn.tag = 100000;
    leftBtn.frame = CGRectMake(0,0, btnW, bottomViewHeight);
    [leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:leftBtn];
    
    // 右边的btn
    UIButton * rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:ZY_THEMEColor forState:(UIControlStateNormal)];
    [rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    rightBtn.tag = 100001;
    rightBtn.frame = CGRectMake(btnW + 1,0, btnW, bottomViewHeight);
    [rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:rightBtn];
}

// btn事件
-(void)btnAction:(UIButton *)btn{
    
    if (btn.tag == 100000) {
        [self removeFromSuperview];
    }else{
        
        if (_delegate) {
            [_delegate pickerDate:self dayStr:dayStr houStr:houStr minStr:minStr];
        }
        [self removeFromSuperview];
    }
}

#pragma mark -- 自己的设置
-(void)setOwn{
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

#pragma mark -- 获取数据
-(void)reloaData{
    
    NSInteger dayIndex = [dayPickerView selectedRowInComponent:0];
    NSInteger houIndex = [houPickerView selectedRowInComponent:0];
    NSInteger minIndex = [minPickerView selectedRowInComponent:0];
    
    dayStr   = self.firstArray[dayIndex];
    houStr   = self.secondArray[houIndex];
    minStr = self.thirdArray[minIndex];
    
}
@end
