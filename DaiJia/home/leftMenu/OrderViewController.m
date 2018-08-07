//
//  OrderViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/12.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "SendSingleViewController.h"
#import "EvaluationDriverViewController.h"
@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,assign)int page;
@property (nonatomic,assign)int totalPage;
@end

@implementation OrderViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    //[self refresh];
    // Do any additional setup after loading the view.
}
- (void)refresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getMoreDate];
    }];
}
-(void)getData{
    self.page = 1;
    self.totalPage = 0;
    self.dataSource = [NSMutableArray array];
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] =  [NSString stringWithFormat:@"%d",self.page];
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/order/list" dataDict:dic type:RequestType_Post loadingTitle:@"正在加载" sucessTitle:@"" sucessBlock:^(NSDictionary * responseObj) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:responseObj[@"data"][@"record"]];
        NSString * str = responseObj[@"data"][@"totalPage"];
        self.totalPage = str.intValue;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failedBlock:^(NSError * error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络请求失败请重试" toView:self.view];
    }];
}
- (void)getMoreDate{
    self.page++;
    if (self.page > self.totalPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] =  [NSString stringWithFormat:@"%d",self.page];
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/order/list" dataDict:dic type:RequestType_Post loadingTitle:@"正在加载" sucessTitle:@"加载成功" sucessBlock:^(NSDictionary * responseObj) {
        [self.dataSource addObjectsFromArray:responseObj[@"data"][@"record"]];
        NSString * str = responseObj[@"data"][@"totalPage"];
        self.totalPage = str.intValue;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } failedBlock:^(NSError * error) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络请求失败请重试" toView:self.view];
    }];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"saveCell"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"OrderTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        
    }
    NSDictionary * dic = self.dataSource[indexPath.row];
    [cell bindData:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataSource[indexPath.row];
    if ([[NSString stringWithFormat:@"%@",dic[@"type"]] isEqualToString:@"3"]){
        [CommonAlertView showAlertWithMessage:@"该订单为代叫订单，暂不支持查看详情！" AndTitle:@"温馨提示" Action:nil];
        return;
    }
    if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"9"]) {
        PayPageViewController * vc = [PayPageViewController new];
        vc.orderNum = [NSString stringWithFormat:@"%@",dic[@"orderNum"]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"10"]) {
        PayPageViewController * vc = [PayPageViewController new];
        vc.orderNum = [NSString stringWithFormat:@"%@",dic[@"orderNum"]];
        vc.isOrder = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        EvaluationDriverViewController * vc = [EvaluationDriverViewController new];
//        vc.orderNum = [NSString stringWithFormat:@"%@",dic[@"orderNum"]];
//        [self.navigationController pushViewController:vc animated:YES];
    }else if ([[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"11"] || [[NSString stringWithFormat:@"%@",dic[@"status"]] isEqualToString:@"12"]) {
        
    }else{
        SendSingleViewController * send = [SendSingleViewController new];
        send.orderNum = [NSString stringWithFormat:@"%@",dic[@"orderNum"]];
        [self.navigationController pushViewController:send animated:YES];
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
