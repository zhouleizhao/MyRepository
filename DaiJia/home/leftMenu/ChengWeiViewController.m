//
//  ChengWeiViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/7/25.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "ChengWeiViewController.h"

@interface ChengWeiViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *nanButton;
@property (weak, nonatomic) IBOutlet UIButton *nvButton;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ChengWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"您的称谓";
    self.view.backgroundColor = CONTROLLERCOLOR
    
    if (!_isPerfectInfo) {
        UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        rightButton.frame = CGRectMake(0, 0, 44, 44);
        [rightView addSubview:rightButton];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        
        self.nextBtn.hidden = true;
        
        self.nameTextField.delegate = self;
        self.nameTextField.text = self.name;
        if ([self.sex isEqualToString:@"0"]) {
            self.nanButton.selected = YES;
        }else if ([self.sex isEqualToString:@"1"]){
            self.nvButton.selected = YES;
        }else{
            self.nanButton.selected = YES;
        }
    }else{
        
        self.nextBtn.hidden = false;
        [self.nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.nameTextField.delegate = self;
        self.nanButton.selected = false;
        self.nvButton.selected = false;
    }

    // Do any additional setup after loading the view from its nib.
}
- (void)nextBtnClicked{
    
    if (self.nanButton.selected == false && self.nvButton.selected == false) {
        
        [App_ZLZ_Helper showErrorMessageAlertAutoGone:@"请选择性别！"];
        return;
    }
    
    if (self.nameTextField.text.length == 0) {
        
        [App_ZLZ_Helper showErrorMessageAlertAutoGone:@"请输入名字！"];
        return;
    }
    
    [self rightClick];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)rightClick{
    
    NSString * str = @"";
    if (self.nanButton.selected) {
        str = @"0";
    }else{
        str = @"1";
    }
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/info/modify" dataDict:@{@"name":self.nameTextField.text,@"sex":str} type:RequestType_Post loadingTitle:@"正在提交..." sucessTitle:@"" sucessBlock:^(NSDictionary *) {
        
        if (self.completeBlock != nil) {
            [self completeBlock];
        }
        
        if (!self.isPerfectInfo) {
            [CommonAlertView showAlertWithMessage:@"保存成功" AndTitle:@"温馨提示" Action:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failedBlock:^(NSError *) {
        
    }];
}
- (IBAction)nanClick:(UIButton *)sender {
    if (sender.selected) {
        [CommonAlertView showAlertWithMessage:@"必须选择一种性别" AndTitle:@"温馨提示" Action:nil];
    }else{
        self.nvButton.selected = NO;
        sender.selected = YES;
    }
}
- (IBAction)nvClick:(UIButton *)sender {
    if (sender.selected) {
        [CommonAlertView showAlertWithMessage:@"必须选择一种性别" AndTitle:@"温馨提示" Action:nil];
    }else{
        self.nanButton.selected = NO;
        sender.selected = YES;
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
