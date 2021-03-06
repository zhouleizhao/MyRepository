//
//  EvaluationDriverViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/7/26.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "EvaluationDriverViewController.h"

@interface EvaluationDriverViewController ()
@property (nonatomic,strong)NSString * startLev;
@property (nonatomic,strong)NSString * phoneNumber;
@end

@implementation EvaluationDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价司机";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // 左上角的返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
    self.startLev = @"5";
    self.pingJiaTextView.layer.borderWidth = 1;
    self.pingJiaTextView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
- (void)phoneClick{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)getData{
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/evaluate/page" dataDict:@{@"orderNum":self.orderNum} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary *resObj) {
        [self.driverImageView sd_setImageWithURLNew:[NSURL URLWithString:resObj[@"data"][@"avatar"]] placeholderImage:[UIImage imageNamed:@"logo1"]];
        self.driverNameLabel.text = resObj[@"data"][@"name"];
        self.phoneNumber = resObj[@"data"][@"phone"];
        self.allPriceLabel.text = [NSString stringWithFormat:@"%@元",resObj[@"data"][@"cost"]];
    } failedBlock:^(NSError * error) {
        
    }];
}
- (IBAction)startClick:(UIButton *)sender {
    if (sender == self.firstButton) {
        self.startLev = @"1";
        self.firstButton.selected = YES;
        self.twoButton.selected = NO;
        self.threeButton.selected = NO;
        self.fourButton.selected = NO;
        self.fiveButton.selected = NO;
    }else if (sender == self.twoButton){
        self.startLev = @"2";
        self.firstButton.selected = YES;
        self.twoButton.selected = YES;
        self.threeButton.selected = NO;
        self.fourButton.selected = NO;
        self.fiveButton.selected = NO;
    }else if (sender == self.threeButton){
        self.startLev = @"3";
        self.firstButton.selected = YES;
        self.twoButton.selected = YES;
        self.threeButton.selected = YES;
        self.fourButton.selected = NO;
        self.fiveButton.selected = NO;
    }else if (sender == self.fourButton){
        self.startLev = @"4";
        self.firstButton.selected = YES;
        self.twoButton.selected = YES;
        self.threeButton.selected = YES;
        self.fourButton.selected = YES;
        self.fiveButton.selected = NO;
    }else if (sender == self.fiveButton){
        self.startLev = @"5";
        self.firstButton.selected = YES;
        self.twoButton.selected = YES;
        self.threeButton.selected = YES;
        self.fourButton.selected = YES;
        self.fiveButton.selected = YES;
    }
}
- (void)back{
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
}
- (IBAction)sendClick:(id)sender {
    [self.view endEditing:YES];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"orderNum"] = self.orderNum;
    param[@"content"] = self.pingJiaTextView.conentTextView.text;
    param[@"starLevel"] = self.startLev;
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/order/comment" dataDict:param type:RequestType_Post loadingTitle:@"正在提交..." sucessTitle:@"评论成功" sucessBlock:^(NSDictionary * res) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
    } failedBlock:^(NSError * error) {
        
    }];
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
