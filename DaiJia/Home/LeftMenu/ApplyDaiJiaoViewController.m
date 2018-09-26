//
//  ApplyDaiJiaoViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/8/7.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "ApplyDaiJiaoViewController.h"

@interface ApplyDaiJiaoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *shopAddressTextField;

@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lon;
@end

@implementation ApplyDaiJiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)chooseAddress:(UIButton *)sender {
    
}
- (IBAction)sendData:(UIButton *)sender {
    
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
