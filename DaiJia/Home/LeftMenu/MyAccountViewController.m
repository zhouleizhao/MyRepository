//
//  MyAccountViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/12.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "MyAccountViewController.h"
#import "AccountView.h"
#import "AccountView1.h"
#import "ChengWeiViewController.h"
@interface MyAccountViewController ()<AddImageSubViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray * addressDataArr;
}
@property (nonatomic,strong)AccountView * accountView;
@property (nonatomic,strong)AccountView1 * accountView1;
@property (nonatomic,strong)NSDictionary * dataDic;
@end

@implementation MyAccountViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账户";
    self.view.backgroundColor = CONTROLLERCOLOR
    self.accountView = [AccountView new];
    self.accountView.clipsToBounds = YES;
    self.accountView.layer.cornerRadius = 5;
    [self.accountView.oneButton addTarget:self action:@selector(saveIconClick) forControlEvents:UIControlEventTouchUpInside];
    [self.accountView.twoButton addTarget:self action:@selector(saveSex) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(160);
    }];
    self.accountView1 = [AccountView1 new];
    self.accountView1.clipsToBounds = YES;
    self.accountView1.layer.cornerRadius = 5;
    [self.view addSubview:self.accountView1];
    [self.accountView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.accountView);
        make.top.mas_equalTo(self.accountView.mas_bottom).offset(10);
        make.height.mas_equalTo(120);
    }];
    
    self.accountView1.oneLabel.tag = 1;
    self.accountView1.twoLabel.tag = 2;
    self.accountView1.oneLabel.userInteractionEnabled = true;
    self.accountView1.twoLabel.userInteractionEnabled = true;
    UITapGestureRecognizer * tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressViewClicked:)];
    [self.accountView1.oneLabel addGestureRecognizer:tapGr];
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressViewClicked:)];
    [self.accountView1.twoLabel addGestureRecognizer:tapGr];
    // Do any additional setup after loading the view.
}
- (void)addressViewClicked:(UITapGestureRecognizer *)tapGr {
    CommonAddressViewController * cavc = [[CommonAddressViewController alloc] init];
    cavc.countStr = [NSString stringWithFormat:@"%d",tapGr.view.tag];
    if (tapGr.view.tag == 1) {
        if (addressDataArr.count > 0) {
            cavc.dataDict = addressDataArr[0];
        }
    }
    if (tapGr.view.tag == 2) {
        if (addressDataArr.count > 1) {
            cavc.dataDict = addressDataArr[1];
        }
    }
    [self.navigationController pushViewController:cavc animated:true];
}
- (void)loadData{
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/info/acquire" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * resObj) {
        [[NSUserDefaults standardUserDefaults] setObject:resObj[@"data"] forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSDictionary * dic = resObj[@"data"];
        self.dataDic = dic;
        [self.accountView.userIconImageView sd_setImageWithURLNew:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
        if ([[NSString stringWithFormat:@"%@",dic[@"sex"]] isEqualToString:@"0"]) {
            self.accountView.chengWeiLabel.text = [NSString stringWithFormat:@"%@先生",dic[@"registerName"]];
        }else if ([[NSString stringWithFormat:@"%@",dic[@"sex"]] isEqualToString:@"1"]){
            self.accountView.chengWeiLabel.text = [NSString stringWithFormat:@"%@女士",dic[@"registerName"]];
        }
        self.accountView.accountLabel.text = dic[@"phonenumber"];
    } failedBlock:^(NSError * error) {
        
    }];
    
    self.accountView1.hidden = true;
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/commonAddress/list" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * responseObj) {
        
        self.accountView1.hidden = false;
        
        NSArray * arr = responseObj[@"data"];
        self->addressDataArr = arr;
        if ([arr count] == 1) {
            self.accountView1.oneLabel.text = arr[0][@"address"];
            self.accountView1.oneLeftLabel.text = arr[0][@"alias"];
        }
        if ([arr count] == 2) {
            self.accountView1.oneLabel.text = arr[0][@"address"];
            self.accountView1.oneLeftLabel.text = arr[0][@"alias"];
            self.accountView1.twoLabel.text = arr[1][@"address"];
            self.accountView1.twoLeftLabel.text = arr[1][@"alias"];
        }
    } failedBlock:^(NSError * error) {
        
    }];
}
- (void)saveIconClick{
    [AddImageSubView showView].delegate = self;
}
- (void)saveSex{
    ChengWeiViewController * chengwei = [ChengWeiViewController new];
    chengwei.name = self.dataDic[@"registerName"];
    chengwei.sex = [NSString stringWithFormat:@"%@",self.dataDic[@"sex"]];
    [self.navigationController pushViewController:chengwei animated:YES];
}
- (void)shot_AddImageSubView{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 是否允许编辑（默认为NO）
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
- (void)album_AddImageSubView{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 是否允许编辑（默认为NO）
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"info = %@", info);
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [App_ZLZ_Helper sendImagesAndDataToServerUseUrl:@"user/info/uploadImg" dataDict:@{} type:RequestType_Post loadingTitle:@"处理中..." sucessTitle:@"" sucessBlock:^(NSDictionary * responseObj) {
        self.accountView.userIconImageView.image = image;
        NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSMutableDictionary * dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dic1 setObject:responseObj[@"data"] forKey:@"avatar"];
        dic = dic1;
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
        NSLog(@"个人信息：%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]);
    } failedBlock:^(NSError * error) {
        
    } andImageArr:@[image] andFileName:@"img"];
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
