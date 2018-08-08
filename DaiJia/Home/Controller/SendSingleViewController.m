//
//  SendSingleViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/7/24.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//
//派单跟司机接单、司机到达界面
#import "SendSingleViewController.h"

@interface SendSingleViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic, retain) BMKLocationService * locationService;
@property (nonatomic,strong)BMKPointAnnotation * beginAn;
@property (nonatomic,strong)BMKPointAnnotation * driverAn;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)DriverView * driverView;
@property (nonatomic,strong)NSString * phoneStr;
@property (nonatomic,strong)UILabel * TipLabel;
@end

@implementation SendSingleViewController
+ (void)initialize {
    //设置自定义地图样式，会影响所有地图实例
    //注：必须在BMKMapView对象初始化之前调用
    NSString* path = [[NSBundle mainBundle] pathForResource:@"custom_config_清新蓝" ofType:@""];
    [BMKMapView customMapStyle:path];
}
#pragma mark - 定位相关
- (void)startLocaionService{
    _locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    //启动LocationService
    [_locationService startUserLocationService];
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    NSLog(@"当前位置%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self startLocaionService];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [_mapView setZoomLevel:16];
    _mapView.delegate = self;
    _mapView.showsUserLocation = NO;//显示定位图层
    _mapView.ChangeCenterWithDoubleTouchPointEnabled = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
    [App_ZLZ_Helper showLoadingView:@"地图加载中..."];
    
//    UIImageView * imageview = [UIImageView new];
//    imageview.image = [UIImage imageNamed:@"组-7"];
//    [self.mapView addSubview:imageview];
//    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mapView);
//        make.centerY.mas_equalTo(self.mapView).offset(-(33/2));
//        make.width.mas_equalTo(19);
//        make.height.mas_equalTo(33);
//    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkOrderStatus) userInfo:nil repeats:YES];
    
    self.TipLabel = [UILabel new];
    self.TipLabel.font = [UIFont systemFontOfSize:15];
    self.TipLabel.textColor = [UIColor darkGrayColor];
    self.TipLabel.textAlignment = NSTextAlignmentCenter;
    self.TipLabel.backgroundColor = [UIColor whiteColor];
    [self.mapView addSubview:self.TipLabel];
    [self.TipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(-20);
    }];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)checkOrderStatus{
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/check/normalOrderStatus" dataDict:@{@"orderNum":self.orderNum} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * resObj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double lat1 = [resObj[@"data"][@"latitude"] doubleValue];
            double lon1 = [resObj[@"data"][@"longitude"] doubleValue];
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat1, lon1) animated:YES];
        });
        if (self.isYuYue) {
            if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"-1"]) {
                self.TipLabel.text = @"订单状态：等待派单";
                if (self.beginAn) {
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.beginAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }else{
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"起点";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.beginAn = annotation;
                }
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"0"]) {
                self.TipLabel.text = @"订单状态：司机已接单";
                self.driverView = [[DriverView alloc] init];
                [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                [self.driverView bindDataWithDic:resObj[@"data"]];
                self.phoneStr = resObj[@"data"][@"phone"];
                [self.mapView addSubview:self.driverView];
                [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(10);
                    make.left.mas_equalTo(10);
                    make.right.mas_equalTo(-10);
                    make.height.mas_equalTo(70);
                }];
                if (self.driverAn) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        double lat = [resObj[@"data"][@"latitude"] doubleValue];
                        double lon = [resObj[@"data"][@"longitude"] doubleValue];
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }else{
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }
                
                
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"2"]) {
                self.TipLabel.text = @"订单状态：司机正在前往";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"3"]) {
                self.TipLabel.text = @"订单状态：司机已到达";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"4"]) {
                self.TipLabel.text = @"订单状态：司机已开车";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"5"]) {
                self.TipLabel.text = @"订单状态：中途等待";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"6"]) {
                self.TipLabel.text = @"订单状态：到达目的地";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"7"] || [[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"8"]) {
                self.TipLabel.text = @"订单状态：请求付款信息";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"9"]) {
                self.TipLabel.text = @"订单状态：未支付";
                
                UIViewController * controller = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
                [self.navigationController popViewControllerAnimated:false];
                
                [App_ZLZ_Helper removeLoadingView];
                //跳转支付页面
                PayPageViewController * pay = [PayPageViewController new];
                pay.orderNum = resObj[@"data"][@"orderNum"];
                [controller.navigationController pushViewController:pay animated:YES];
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"10"]) {
                self.TipLabel.text = @"订单状态：完成";
                [self.navigationController popViewControllerAnimated:YES];
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }
        }else{
            if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"0"]) {
                self.TipLabel.text = @"订单状态：等待派单";
                BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                annotation.title = @"起点";
                double lat = [resObj[@"data"][@"latitude"] doubleValue];
                double lon = [resObj[@"data"][@"longitude"] doubleValue];
                annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                annotation.isLockedToScreen = false;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:annotation];
                });
                self.beginAn = annotation;
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"1"]) {
                self.TipLabel.text = @"订单状态：司机已接单";
                self.driverView = [[DriverView alloc] init];
                [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                [self.driverView bindDataWithDic:resObj[@"data"]];
                self.phoneStr = resObj[@"data"][@"phone"];
                [self.mapView addSubview:self.driverView];
                [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(10);
                    make.left.mas_equalTo(10);
                    make.right.mas_equalTo(-10);
                    make.height.mas_equalTo(70);
                }];
                BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                annotation.title = @"司机位置";
                double lat = [resObj[@"data"][@"latitude"] doubleValue];
                double lon = [resObj[@"data"][@"longitude"] doubleValue];
                annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                annotation.isLockedToScreen = false;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:annotation];
                });
                self.driverAn = annotation;
                
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"2"]) {
                self.TipLabel.text = @"订单状态：司机正在前往";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"3"]) {
                self.TipLabel.text = @"订单状态：司机已到达";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"4"]) {
                self.TipLabel.text = @"订单状态：司机已开车";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"5"]) {
                self.TipLabel.text = @"订单状态：中途等待";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"6"]) {
                self.TipLabel.text = @"订单状态：到达目的地";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"7"] || [[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"8"]) {
                self.TipLabel.text = @"订单状态：请求付款信息";
                if (self.driverView == nil) {
                    self.driverView = [[DriverView alloc] init];
                    [self.driverView setStarCountWithStarCount:[[NSString stringWithFormat:@"%@",resObj[@"data"][@"starLevel"]] integerValue]];
                    [self.driverView.phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.driverView bindDataWithDic:resObj[@"data"]];
                    self.phoneStr = resObj[@"data"][@"phone"];
                    [self.mapView addSubview:self.driverView];
                    [self.driverView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(10);
                        make.left.mas_equalTo(10);
                        make.right.mas_equalTo(-10);
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.driverAn == nil) {
                    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
                    annotation.title = @"司机位置";
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    annotation.isLockedToScreen = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView addAnnotation:annotation];
                    });
                    self.driverAn = annotation;
                }else{
                    double lat = [resObj[@"data"][@"latitude"] doubleValue];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.driverAn.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    });
                }
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"9"]) {
                self.TipLabel.text = @"订单状态：未支付";
                
                UIViewController * controller = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
                [self.navigationController popViewControllerAnimated:false];
                
                [App_ZLZ_Helper removeLoadingView];
                //跳转支付页面
                PayPageViewController * pay = [PayPageViewController new];
                pay.orderNum = resObj[@"data"][@"orderNum"];
                [controller.navigationController pushViewController:pay animated:YES];
            }else if ([[NSString stringWithFormat:@"%@",resObj[@"data"][@"status"]] isEqualToString:@"10"]) {
                self.TipLabel.text = @"订单状态：完成";
                [self.navigationController popViewControllerAnimated:YES];
                self.navigationItem.rightBarButtonItem = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:self.beginAn];
                });
            }
        }
        
        
    } failedBlock:^(NSError *) {
        
    }];
}
- (void)phoneClick{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneStr];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
- (void)setNav{
    self.title = @"正在派单";
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    rightButton.frame = CGRectMake(0, 0, 80, 44);
    [view addSubview:rightButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}
- (void)rightClick{
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/order/cacel" dataDict:@{@"orderNum":self.orderNum} type:RequestType_Post loadingTitle:@"正在取消..." sucessTitle:@"取消成功" sucessBlock:^(NSDictionary *) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failedBlock:^(NSError *) {
        
    }];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        if ([annotation.title isEqualToString:@"起点"]) {
            ((BMKPinAnnotationView*)annotationView).image = [UIImage imageNamed:@"组-7"];
        }else{
            ((BMKPinAnnotationView*)annotationView).image = [UIImage imageNamed:@"司机正在路上"];
        }
        
        return annotationView;
    }
    return nil;
    
    //    return nil;
}
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    [App_ZLZ_Helper removeLoadingView];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [BMKMapView enableCustomMapStyle:YES];
    if (self.timer) {
        //开启定时器
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [BMKMapView enableCustomMapStyle:NO];//关闭个性化地图
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    if (self.timer) {
        //关闭定时器
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
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