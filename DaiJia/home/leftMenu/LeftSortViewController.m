//
//  LeftSortViewController.m
//  Touch
//
//  Created by lanou3g on 15/12/14.
//  Copyright © 2015年 syx. All rights reserved.
//

#import "LeftSortViewController.h"
#import "AppDelegate.h"
#import "OtherViewController.h"
#import "LeftHeaderView.h"
#import "OrderViewController.h"//我的订单
#import "PreferentialViewController.h"//我的钱包
#import "MyAccountViewController.h"//我的账户
#import "ApplyDaiJiaoViewController.h"//申请代叫
//支付密码
@interface LeftSortViewController ()<UITableViewDataSource,UITableViewDelegate>{
    LeftHeaderView * _headView;
    
}

@end

@implementation LeftSortViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refreshHeader" object:nil];
    [self setupUI];
    self.view.backgroundColor = CONTROLLERCOLOR
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 100;
    btn.backgroundColor = ZHUTICOLOR;
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logoutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.width.mas_equalTo(WIDTH - 100 - 20*2);
        make.bottom.equalTo(self.view).offset(-40);
    }];
}
- (void)refresh{
    [_headView bindData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GETUSERINFO
//    if ([userInfo[@"isNo"] isEqualToString:@"0"]) {
//        //未申请代叫
//        return 5;
//    }else{
//        return 4;
//    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    [[cell.contentView viewWithTag:100] removeFromSuperview];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的订单";
        cell.imageView.image = [UIImage imageNamed:@"order"];
        [cell.imageView.leftAnchor constraintEqualToAnchor:cell.imageView.superview.leftAnchor constant:30];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"我的钱包";
        cell.imageView.image = [UIImage imageNamed:@"wallet"];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"我的账户";
        cell.imageView.image = [UIImage imageNamed:@"account"];
    }else if (indexPath.row == 3) {
        cell.textLabel.text = @"支付密码";
        cell.imageView.image = [UIImage imageNamed:@"account"];
    }else if (indexPath.row == 4) {
        //未申请代叫
        cell.textLabel.text = @"申请代叫";
        cell.imageView.image = [UIImage imageNamed:@"account"];
    }
    
    return cell;
}

- (void)logoutBtnClicked {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[App_ZLZ_Helper getAppDelegate].leftSlideVC closeLeftView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC closeLeftView];//关闭左侧抽屉
    if (indexPath.row == 0) {
        OrderViewController * vc = [OrderViewController new];
        [tempAppDelegate.mainNC pushViewController:vc animated:NO];
    }else if (indexPath.row == 1){
        PreferentialViewController * vc = [PreferentialViewController new];
        [tempAppDelegate.mainNC pushViewController:vc animated:NO];
    }else if (indexPath.row == 2){
        MyAccountViewController * vc = [MyAccountViewController new];
        [tempAppDelegate.mainNC pushViewController:vc animated:NO];
    }else if (indexPath.row == 3){
        
        PayPasswordViewController * sppvc = [PayPasswordViewController new];
        [tempAppDelegate.mainNC pushViewController:sppvc animated:NO];

        /*
        [App_ZLZ_Helper sendDataToServerUseUrl:@"user/transPwd/isHasPwd" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * resObj) {
            if ([[NSString stringWithFormat:@"%@",resObj[@"data"]] isEqualToString:@"0"]) {
                SetUpPayPasswordViewController * supvc = [[SetUpPayPasswordViewController alloc] init];
                supvc.title = @"设置密码";
                supvc.subTitleHintLabelStr = @"请输入新密码";
                supvc.completeBlock = ^(NSString * str){
                    
                    SetUpPayPasswordViewController * supvc = [[SetUpPayPasswordViewController alloc] init];
                    supvc.title = @"设置密码";
                    supvc.subTitleHintLabelStr = @"请再次输入新密码";
                    supvc.oldPassword = str;
                    supvc.isAginConfirm = true;
                    supvc.completeBlock = ^(NSString * str){
                        [App_ZLZ_Helper sendDataToServerUseUrl:@"user/transPwd/set" dataDict:@{@"newPwd":str} type:RequestType_Post loadingTitle:@"" sucessTitle:@"设置支付密码成功" sucessBlock:^(NSDictionary *) {
                            [tempAppDelegate.mainNC popViewControllerAnimated:false];
                        } failedBlock:^(NSError *) {
                            
                        }];
                        //请求网络接口
                    };
                    
                    //UIViewController * controller = self.navigationController.viewControllers[1];
                    
                    [tempAppDelegate.mainNC popViewControllerAnimated:false];
                    [tempAppDelegate.mainNC pushViewController:supvc animated:true];
                };
                [tempAppDelegate.mainNC pushViewController:supvc animated:true];
            }else{
                
            }
        } failedBlock:^(NSError *) {
            SetUpPayPasswordViewController * supvc = [[SetUpPayPasswordViewController alloc] init];
            supvc.title = @"设置密码";
            supvc.subTitleHintLabelStr = @"请输入新密码";
            supvc.completeBlock = ^(NSString * str){
                
                SetUpPayPasswordViewController * supvc = [[SetUpPayPasswordViewController alloc] init];
                supvc.title = @"设置密码";
                supvc.subTitleHintLabelStr = @"请再次输入新密码";
                supvc.oldPassword = str;
                supvc.isAginConfirm = true;
                supvc.completeBlock = ^(NSString * str){
                    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/transPwd/set" dataDict:@{@"newPwd":str} type:RequestType_Post loadingTitle:@"" sucessTitle:@"设置支付密码成功" sucessBlock:^(NSDictionary *) {
                        [tempAppDelegate.mainNC popViewControllerAnimated:false];
                    } failedBlock:^(NSError *) {
                        
                    }];
                    //请求网络接口
                };
                
                //UIViewController * controller = self.navigationController.viewControllers[1];
                
                [tempAppDelegate.mainNC popViewControllerAnimated:false];
                [tempAppDelegate.mainNC pushViewController:supvc animated:true];
            };
            [tempAppDelegate.mainNC pushViewController:supvc animated:true];
        }];*/
        
    }else if (indexPath.row == 4){
        ApplyDaiJiaoViewController * djvc = [ApplyDaiJiaoViewController new];
        [tempAppDelegate.mainNC pushViewController:djvc animated:NO];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)setupUI{
    
//    _headView = [[LeftHeaderView alloc]initWithFrame:CGRectMake(0, ZLZStatusBarHeight + 30, [UIScreen mainScreen].bounds.size.width, 90)];
//    _headView.backgroundColor = CONTROLLERCOLOR
//    [self.view addSubview:_headView];
//
//
    UITableView * tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    tableView.frame = self.view.bounds;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    _headView = [[LeftHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
    _headView.backgroundColor = CONTROLLERCOLOR

    self.tableView.tableHeaderView = _headView;
    
    self.tableView.backgroundColor = CONTROLLERCOLOR
    self.tableView.separatorColor = CONTROLLERCOLOR
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