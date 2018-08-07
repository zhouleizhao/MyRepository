//
//  ChongZhiViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/12.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "ChongZhiViewController.h"
#import "ChongZhiView1.h"
@interface ChongZhiViewController ()
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)ChongZhiView1 * chongzhiView;

@end

@implementation ChongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.view.backgroundColor = CONTROLLERCOLOR
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    self.scrollView.contentSize = CGSizeMake(SCREENWidth, 170+SCREENHeight*0.4);
    [self.view addSubview:self.scrollView];
    ChongZhiView1 * view = [[ChongZhiView1 alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 170+SCREENHeight*0.4)];
    view.yuELabel.text = [NSString stringWithFormat:@"账户余额：￥%@",self.yuEStr];
    view.oneButton.selected = YES;
    view.oneButton.backgroundColor = [UIColor darkGrayColor];
    view.textField.text = [view.oneButton.titleLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
    [view.oneButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.twoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.threeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.fourButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:view];
    self.chongzhiView = view;
    // Do any additional setup after loading the view.
}
- (void)buttonClick:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
        sender.backgroundColor = [UIColor whiteColor];
        self.chongzhiView.textField.text = @"";
    }else{
        sender.selected = YES;
        if (sender == self.chongzhiView.oneButton) {
            self.chongzhiView.oneButton.selected = YES;
            self.chongzhiView.twoButton.selected = NO;
            self.chongzhiView.threeButton.selected = NO;
            self.chongzhiView.fourButton.selected = NO;
            self.chongzhiView.oneButton.backgroundColor = [UIColor darkGrayColor];
            self.chongzhiView.twoButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.threeButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.fourButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.textField.text = [self.chongzhiView.oneButton.titleLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
        }else if (sender == self.chongzhiView.twoButton){
            self.chongzhiView.oneButton.selected = NO;
            self.chongzhiView.twoButton.selected = YES;
            self.chongzhiView.threeButton.selected = NO;
            self.chongzhiView.fourButton.selected = NO;
            self.chongzhiView.oneButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.twoButton.backgroundColor = [UIColor darkGrayColor];
            self.chongzhiView.threeButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.fourButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.textField.text = [self.chongzhiView.twoButton.titleLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
        }else if (sender == self.chongzhiView.threeButton){
            self.chongzhiView.oneButton.selected = NO;
            self.chongzhiView.twoButton.selected = NO;
            self.chongzhiView.threeButton.selected = YES;
            self.chongzhiView.fourButton.selected = NO;
            self.chongzhiView.oneButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.twoButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.threeButton.backgroundColor = [UIColor darkGrayColor];
            self.chongzhiView.fourButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.textField.text = [self.chongzhiView.threeButton.titleLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
        }else if (sender == self.chongzhiView.fourButton){
            self.chongzhiView.oneButton.selected = NO;
            self.chongzhiView.twoButton.selected = NO;
            self.chongzhiView.threeButton.selected = NO;
            self.chongzhiView.fourButton.selected = YES;
            self.chongzhiView.oneButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.twoButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.threeButton.backgroundColor = [UIColor whiteColor];
            self.chongzhiView.fourButton.backgroundColor = [UIColor darkGrayColor];
            self.chongzhiView.textField.text = [self.chongzhiView.fourButton.titleLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
