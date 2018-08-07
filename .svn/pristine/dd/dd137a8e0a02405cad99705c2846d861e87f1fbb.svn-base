//
//  PreferentialViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/12.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "PreferentialViewController.h"
#import "ZhangHuView.h"
#import "YouHuiQuanViewController.h"
//#import "ChongZhiViewController.h"
@interface PreferentialViewController ()
@property (nonatomic,strong)ZhangHuView * zhangHuView;
@end

@implementation PreferentialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账户";
    self.view.backgroundColor = CONTROLLERCOLOR
    ZhangHuView * zhanghu = [[ZhangHuView alloc] init];
    [zhanghu.topButton addTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
    [zhanghu.bottomButton addTarget:self action:@selector(bottomClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhanghu];
    [zhanghu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(10);
    }];
    self.zhangHuView = zhanghu;
    //[self loadData];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [self loadData];
}
- (void)loadData{
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/info/myWallet" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * resObj) {
        self.zhangHuView.moneyLabel.text = [NSString stringWithFormat:@"%@元",resObj[@"data"][@"balance"]];
        self.zhangHuView.numberLabel.text = [NSString stringWithFormat:@"%@张",resObj[@"data"][@"discountNum"]];
    } failedBlock:^(NSError *) {
        
    }];
}
- (void)topClick{
    ChongZhiViewController * vc = [ChongZhiViewController new];
    vc.yuEStr = self.zhangHuView.moneyLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)bottomClick{
    YouHuiQuanViewController * youhui = [YouHuiQuanViewController new];
    [self.navigationController pushViewController:youhui animated:YES];
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
