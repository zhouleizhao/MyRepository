//
//  BaseOCViewController.m
//  DaiJia
//
//  Created by MyApple on 29/06/2018.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

#import "BaseOCViewController.h"

@interface BaseOCViewController ()

@end

@implementation BaseOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightItemBtnClicked{
    
}
- (void)leftItemBtnClicked{
    
}

- (void)addRightItemBtnTitle:(NSString *)btnTitle andTitleColor:(UIColor *)color{
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:btnTitle forState:UIControlStateNormal];
    [rightBtn setTitleColor:color forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)addRightItemBtnUseImg:(UIImage *)img andImageInsets:(UIEdgeInsets)insets{
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 38, 38);
    rightBtn.imageEdgeInsets = insets;
    [rightBtn setImage:img forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)addLeftItemBtnUseImg:(UIImage *)img andImageInsets:(UIEdgeInsets)insets{
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 38, 38);
    leftBtn.imageEdgeInsets = insets;
    [leftBtn setImage:img forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftItemBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)requestDataFromServer {
    
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
