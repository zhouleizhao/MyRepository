//
//  CustomNavigationViewController.m
//  重构百思不得姐
//
//  Created by wyzc on 2016/11/10.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "CustomNavigationViewController.h"
@interface CustomNavigationViewController ()<UIGestureRecognizerDelegate>


@end

@implementation CustomNavigationViewController

+ (void)load{
    
}

//初始化方法 nsobject的类方法
+ (void)initialize{
    
//    //创建 bar 实例
//    UINavigationBar * bar = [UINavigationBar appearance];
//    bar.tintColor = [UIColor colorWithRed:31/255.0 green:130/255.0 blue:170/255.0 alpha:0];
    
//    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    dic[NSFontAttributeName] = [UIFont systemFontOfSize:20];
//    //设置文字属性
//    [bar setTitleTextAttributes:dic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //在NavigationController堆栈内的UIViewController可以支持右滑手势，也就是不用点击右上角的返回按钮，轻轻在屏幕右边一滑，屏幕就会返回
    self.interactivePopGestureRecognizer.delegate = self;
    
    // Do any additional setup after loading the view.
}
// 重写push 方法 那么执行子类的方法
// 其实就是拦截了入栈
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    
    //    if (不是第一个push进来的子控制器)
    if (self.childViewControllers.count >= 1) {
        // 左上角的返回
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@" 返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [backButton sizeToFit];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
        
    }
    //到目前为止界面还不能跳转
    
    // 入栈, 转换页面
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    //如果当前显示的是第一个子控制器,就应该禁止掉

    return self.childViewControllers.count > 1;
    
}


@end
