//
//  WebViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/8/27.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//
#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,strong)MBProgressHUD * hud;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView.delegate = self;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVICE,self.jieKou]]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    //[self loadData];
    // Do any additional setup after loading the view.
}
- (void)loadData{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = response;
    [manager GET:[NSString stringWithFormat:@"%@%@",SERVICE,self.jieKou] parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showSuccess:@"加载成功"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"网页加载失败了：%@",error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showSuccess:@"加载失败"];
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
