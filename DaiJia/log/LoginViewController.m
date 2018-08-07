//
//  LoginViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/8.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UITextField * phoneTextField;
@property (nonatomic,strong)UITextField * codeTextfield;
@property (nonatomic,strong)UIButton * codeButton;
@property (strong,nonatomic)UIWebView * webView;
@property (strong,nonatomic)UIView * backView;
@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = CONTROLLERCOLOR
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.width.mas_equalTo(100);
        make.top.mas_equalTo(10);
    }];
    
    UIView * inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(120);
    }];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.delegate = self;
    [inputView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(-100);
        make.top.mas_equalTo(inputView);
    }];
    
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(codeCllick) forControlEvents:UIControlEventTouchUpInside];
    [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.codeButton.backgroundColor = [UIColor whiteColor];
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.codeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [inputView addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneTextField.mas_right);
        make.width.mas_equalTo(100);
        make.top.height.mas_equalTo(self.phoneTextField);
    }];
    
    self.codeTextfield = [[UITextField alloc] init];
    self.codeTextfield.placeholder = @"请输入验证码";
    self.codeTextfield.delegate = self;
    [inputView addSubview:self.codeTextfield];
    [self.codeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(inputView);
    }];
    
    UIView * lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [inputView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.mas_equalTo(inputView);
        make.height.mas_equalTo(1);
    }];
    UIView * lineView1 = [UIView new];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [inputView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneTextField.mas_right);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(self.phoneTextField);
    }];
    
    UIButton * logButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [logButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logButton.backgroundColor = [UIColor blackColor];
    logButton.clipsToBounds = YES;
    logButton.layer.cornerRadius = 5;
    [logButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logButton];
    [logButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.codeTextfield.mas_bottom).offset(30);
    }];
    
    UILabel * TipLabel = [UILabel new];
    TipLabel.text = @"登录即代表您同意";
    TipLabel.textColor = [UIColor darkGrayColor];
    TipLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:TipLabel];
    [TipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logButton);
        make.top.mas_equalTo(logButton.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UIButton * xieYiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xieYiButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [xieYiButton setTitle:@"《使用规则与代驾协议》" forState:UIControlStateNormal];
    xieYiButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [xieYiButton addTarget:self action:@selector(xieYiClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieYiButton];
    [xieYiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TipLabel.mas_right);
        make.top.height.mas_equalTo(TipLabel);
    }];
    
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.codeTextfield.keyboardType = UIKeyboardTypePhonePad;
    
    // Do any additional setup after loading the view.
}
//登录按钮
- (void)login{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在登录...";
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"phone"] = self.phoneTextField.text;
    param[@"verifyCode"] = self.codeTextfield.text;
    //param[@"cid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"cid"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    [manager POST:[NSString stringWithFormat:@"%@user/protal/login",SERVICE] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@登录成功返回:%@",task.currentRequest,responseObject);
        hud.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"] forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [MBProgressHUD showSuccess:@"登录成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@验证码报错:%@",task.currentRequest,error);
        hud.hidden = YES;
        [MBProgressHUD showError:@"网络请求失败" toView:self.view];
    }];

}
//点击协议
- (void)xieYiClick{
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
    self.backView = backView;
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREENWidth-40);
        make.top.mas_equalTo(100);
        make.bottom.mas_equalTo(-50);
    }];
    UIButton * button = [UIButton new];
    [button setBackgroundImage:[UIImage imageNamed:@"icon_find_phone_del"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(guanbi) forControlEvents:UIControlEventTouchUpInside];
    [self.webView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(15);
        make.top.mas_equalTo(-15);
        make.height.width.mas_equalTo(30);
    }];
    [self loadData];
}
- (void)guanbi{
    
    [self.backView removeFromSuperview];
}
- (void)loadData{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = response;
    [manager GET:[NSString stringWithFormat:@"%@users/findAgreementOrDescription.html",SERVICE] parameters:@{@"type":@"1"} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
            NSMutableString * htmlStr = [self webImageFitToDeviceSize:[NSMutableString stringWithString:responseObject[@"data"][@"content"]]];
            [self.webView loadHTMLString:htmlStr baseURL:nil];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络请求失败" toView:self.view];
        
    }];
}
- (NSMutableString *)webImageFitToDeviceSize:(NSMutableString *)strContent
{
    [strContent appendString:@"<html>"];
    [strContent appendString:@"<head>"];
    [strContent appendString:@"<meta charset=\"utf-8\">"];
    [strContent appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width*0.9,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [strContent appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    [strContent appendString:@"<style>img{width:100%;}</style>"];
    [strContent appendString:@"<style>table{width:100%;}</style>"];
    return strContent;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.backView removeFromSuperview];
}
//验证码
- (void)codeCllick{
    if (self.phoneTextField.text.length == 11) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在发送验证码...";
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"phone"] = self.phoneTextField.text;
        param[@"Vcode"] = @"0";
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        manager.responseSerializer = response;
        [manager POST:[NSString stringWithFormat:@"%@user/protal/getVerifyCode",SERVICE] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@验证码成功返回:%@",task.currentRequest,responseObject);
            hud.hidden = YES;
            if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"发送验证码成功" toView:self.view];
                [self.codeTextfield becomeFirstResponder];
                //调用验证码接口获取成功再走倒计时
                [self daojishi];
            }else{
                [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@验证码报错:%@",task.currentRequest,error);
            hud.hidden = YES;
            [MBProgressHUD showError:@"网络请求失败" toView:self.view];
        }];
    }else{
        [MBProgressHUD showError:@"手机号位数不正确" toView:self.view];
    }
}
//倒计时
- (void)daojishi{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
                self.codeButton.backgroundColor = [UIColor whiteColor];
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //让按钮变为不可点击
                self.codeButton.backgroundColor = [UIColor whiteColor];
                self.codeButton.userInteractionEnabled = NO;
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@秒后重新获取",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        [self codeCllick];
        
        return [self.phoneTextField resignFirstResponder];
    }else if (textField == self.codeTextfield){
        [self login];
        return [self.codeTextfield resignFirstResponder];
    }else{
        return [textField resignFirstResponder];
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
