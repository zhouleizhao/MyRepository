//
//  YouHuiQuanViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/8/1.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "YouHuiQuanViewController.h"
#import "YouHuiTableViewCell.h"
@interface YouHuiQuanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation YouHuiQuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"YouHuiTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getData];
    // Do any additional setup after loading the view.
}
- (void)getData{
    [App_ZLZ_Helper sendDataToServerUseUrl:@"/user/discount/list" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * resObj) {
        self.dataArray = resObj[@"data"];
        [self.tableView reloadData];
    } failedBlock:^(NSError * error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YouHuiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.youhuiTitleLabel.text = [NSString stringWithFormat:@"%@",dic[@"remark"]];
    cell.mianZhiLabel.text = [NSString stringWithFormat:@"%@",dic[@"balance"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@至%@",[[dic[@"createTime"] componentsSeparatedByString:@" "] firstObject] , [[dic[@"overTime"] componentsSeparatedByString:@" "] firstObject]];
    cell.numberLabel.text = [NSString stringWithFormat:@"%@",dic[@"numbers"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dic = self.dataArray[indexPath.row];
    if (self.selectedRowBlock != nil) {
        [self.navigationController popViewControllerAnimated:true];
        self.selectedRowBlock(dic[@"sumId"], dic[@"balance"]);
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
