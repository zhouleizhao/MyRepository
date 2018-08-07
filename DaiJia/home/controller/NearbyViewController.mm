//
//  NearbyViewController.m
//  DesignateDriver
//
//  Created by MyApple on 03/07/2018.
//  Copyright © 2018 kunya. All rights reserved.
//

#import "NearbyViewController.h"
#import "AppDelegate.h"
#import "SearchSubView.h"
#import "LoginViewController.h"
#import "SendSingleViewController.h"
#import "DaiJiaTwoBottomView.h"
#import "DaiJiaThreeBottomView.h"
#import "DCDataPickerView.h"
#import <JhtMarquee/JhtHorizontalMarquee.h>
//#import "BaiduMapLocationManager.h"

@interface NearbyViewController () <BMKMapViewDelegate, UIGestureRecognizerDelegate, BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,DCDatePickerViewDelegate> {
    BOOL enableCustomMap;
    float zoomLevel;
    BOOL isFirstComeIn;//需要调整地图位置
    
    JhtHorizontalMarquee * marqueeLabel;
}
@property (weak, nonatomic) IBOutlet UIView *enlargeView;
@property (weak, nonatomic) IBOutlet UIView *reduceView;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *twoBottomLineView;
@property (weak, nonatomic) IBOutlet UIView *threeBottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (nonatomic, retain) BMKLocationService * locationService;
@property (nonatomic, retain) NSArray * annotationDataArray;//需要显示的司机大头针
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewBottomConstraint;
@property (nonatomic,strong)UIView * maskView;
@property (nonatomic,strong)DaiJiaBottomView * oneBottomView;
@property (nonatomic,strong)DaiJiaTwoBottomView * twoBottomView;
@property (nonatomic,strong)DaiJiaThreeBottomView * threeBottomView;
@property (nonatomic,assign)CLLocationCoordinate2D loact;
@property (nonatomic,strong)BMKGeoCodeSearch * searcher;
@property (nonatomic,assign)BOOL isRefresh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (nonatomic,strong)BMKPointAnnotation* annotation;//终点大头针
@property (nonatomic,strong)UIButton * currentLoactionButton;
@property (nonatomic,strong)DCDataPickerView * dataPickerView;
@property (nonatomic,strong)NSString * yuYueDate;
@property (nonatomic,assign)CLLocationCoordinate2D daiJiaoLocation;//代叫起点经纬度
@end

@implementation NearbyViewController

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

    if (isFirstComeIn) {
        [_mapView updateLocationData:userLocation];
        _mapView.centerCoordinate = userLocation.location.coordinate;
        CLLocationCoordinate2D loc = [userLocation.location coordinate];
        //放大地图到自身的经纬度位置。
        
        zoomLevel = 16;
        [_mapView setZoomLevel:zoomLevel];
        [_mapView setCenterCoordinate:loc animated:true];
        self.loact = loc;
        
        
        /*
        BMKCoordinateRegion viewRegion = {loc, {0.02f,0.02f}};
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];*/
        isFirstComeIn = false;
    }
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
    [self checkOrder];
    self.isRefresh = YES;
    self.twoBottomLineView.hidden = YES;
    self.threeBottomLineView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeClick) name:@"closeLeft" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openClick) name:@"openLeft" object:nil];
    
    [self setNav];
    [self addRightItemBtnTitle:@"列表" andTitleColor:[UIColor whiteColor]];
    UITapGestureRecognizer * tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeViewClicked)];
    [self.enlargeView addGestureRecognizer:tapGr];
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reduceViewClicked)];
    [self.reduceView addGestureRecognizer:tapGr];
    
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.ChangeCenterWithDoubleTouchPointEnabled = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
    [App_ZLZ_Helper showLoadingView:@"地图加载中..."];
    isFirstComeIn = true;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick1)];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
    [view addGestureRecognizer:tap];
    [self.view insertSubview:view atIndex:1000];
    self.maskView = view;
    self.maskView.hidden = YES;
    UIButton * currenlocButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [currenlocButton setBackgroundImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    [currenlocButton addTarget:self action:@selector(currenLocClick) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:currenlocButton];
    [currenlocButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mapView.mas_right).offset(-20);
        make.width.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.mapView.mas_bottom).offset(-10);
    }];
    self.currentLoactionButton = currenlocButton;
    [self oneButtonClick:nil];
    
    //[self locationBtnClicked:nil];
}
#pragma mark 添加公告
- (void)addNotificationView {

    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/notify/msg" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * responseObj) {
        
        if (self->marqueeLabel == nil) {
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(20, 40 + 10, WIDTH - 20 * 2, 33)];
            view.layer.borderWidth = 1;
            view.layer.borderColor = [App_ZLZ_Helper colorWithHexString:@"f2f2f2"].CGColor;
            view.backgroundColor = [UIColor whiteColor];
            [self.view insertSubview:view atIndex:1001];
            
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (view.frame.size.height - 20)/2, 20, 20)];
            imgView.image = [UIImage imageNamed:@"图层-3"];
            [view addSubview:imgView];

            self->marqueeLabel = [[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(imgView.frame.origin.x + imgView.frame.size.width + 5, 0, view.frame.size.width - (imgView.frame.origin.x + imgView.frame.size.width + 5 + 5), view.frame.size.height) withSingleScrollDuration:5];
            self->marqueeLabel.font = [UIFont systemFontOfSize:13];
            self->marqueeLabel.textColor = [UIColor darkGrayColor];
            [view addSubview:self->marqueeLabel];
            
        }
        
        self->marqueeLabel.text = responseObj[@"data"];
        
    } failedBlock:^(NSError * error) {
        
    }];
}
- (void)handleMarqueeLabel {
    marqueeLabel.backgroundColor = [UIColor whiteColor];
    /*
     marqueeLabel?.backgroundColor = UIColor.white
     marqueeLabel?.verticalTextColor = App_ZLZ_Helper.color(withHexString: "526FF6")
     marqueeLabel?.verticalTextFont = UIFont.systemFont(ofSize: 13)
     marqueeLabel?.verticalNumberOfLines = 1
     let str = "交通广播：2018年3月8号购车有福利大降价购物！"
     let arr = [str,"交通广播：2018年3月8号购车有福利大降价购物！1"]
     marqueeLabel?.sourceArray = arr
     marqueeLabel?.scroll(callbackBlock: { (view, currentIndex) in
     print("滚动到第\(currentIndex)个")
     })
     marqueeLabel?.marqueeOfSetting(withState: MarqueeState_V.start_V)
     */
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addNotificationView];
}
- (void)checkOrder{
    GETUSERINFO
    if (userInfo == nil) {
        return;
    }
    
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/check/unfinished" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * resObj) {
        NSArray * arr = resObj[@"data"];
        if (arr.count>0) {
            NSString * str = @"";
            if ([[NSString stringWithFormat:@"%@",arr[0][@"type"]] isEqualToString:@"1"]) {
                str = @"代驾";
            }else if ([[NSString stringWithFormat:@"%@",arr[0][@"type"]] isEqualToString:@"2"]){
                str = @"预约";
            }else if ([[NSString stringWithFormat:@"%@",arr[0][@"type"]] isEqualToString:@"3"]){
                str = @"代叫";
            }else if ([[NSString stringWithFormat:@"%@",arr[0][@"type"]] isEqualToString:@"4"]){
                str = @"司机主动下订单";
            }
            [ChooseAlertView showChooseViewWithTitle:@"温馨提示" ContentText:[NSString stringWithFormat:@"您有未完成%@订单，是否进入？",str] SureAction:^{
                if ([str isEqualToString:@"代驾"] || [str isEqualToString:@"预约"] || [str isEqualToString:@"司机主动下订单"]) {
                    SendSingleViewController * send = [SendSingleViewController new];
                    send.orderNum = arr[0][@"orderNum"];
                    [self.navigationController pushViewController:send animated:YES];
                }
            } AndCancelAction:^{
                
            } SureTitle:@"进入订单" CancelTitle:@"取消"];
        }
    } failedBlock:^(NSError * error) {
        NSLog(@"=====%@",error);
    }];
}

- (void)currenLocClick{
    [_mapView setCenterCoordinate:_locationService.userLocation.location.coordinate animated:true];
}
- (void)closeClick{
    self.maskView.hidden = YES;
}
- (void)closeClick1{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC closeLeftView];
    self.maskView.hidden = YES;
}
- (void)openClick{
    self.maskView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.title.length == 0) {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LOGO"]];
        imageView.frame = CGRectMake((WIDTH - self.navigationController.navigationBar.frame.size.height)/2, 0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.height);
        imageView.tag = 100;
        [self.navigationController.navigationBar addSubview:imageView];
    }

    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [BMKMapView enableCustomMapStyle:enableCustomMap];
}
- (void)setNav{
    //self.title = @"首页";

    self.navigationItem.leftBarButtonItem = nil;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftClick)];
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"home_left"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10, 12, 25, 20);
    [leftView addSubview:button];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    [leftView addGestureRecognizer:tap];
}
//抽屉按钮
- (void)leftClick{
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userInfo) {
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (tempAppDelegate.leftSlideVC.closed){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHeader" object:nil];
            [tempAppDelegate.leftSlideVC openLeftView];
        }
        else{
            [tempAppDelegate.leftSlideVC closeLeftView];
        }
    }else{
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
    
}
- (void)requestDataFromServer {
    
}

- (int)getDistance:(double)lat lon:(double)lon{
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lon));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.mapView.region.center.latitude,self.mapView.region.center.longitude));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    return distance;
}
- (void)setNewNav{
    
    self.mapView.scrollEnabled = false;
    
    self.title = @"确认订单";
    self.navigationItem.leftBarButtonItem = nil;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftNewClick)];
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button setTitle:@" 返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftNewClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10, 7, 25, 20);
    [leftView addSubview:button];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    [leftView addGestureRecognizer:tap];
    
    [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
}
- (void)leftNewClick{
    self.mapView.scrollEnabled = true;
    self.topViewHeight.constant = 40;
    self.oneLabel.hidden = NO;
    self.twoLabel.hidden = NO;
    self.threeLabel.hidden = NO;
    isFirstComeIn = true;
    self.oneBottomView.endLocationTextField.text = @"";
    self.oneBottomView.leftImage1.hidden = NO;
    self.oneBottomView.leftImage2.hidden = NO;
    self.oneBottomView.leftImage3.hidden = NO;
    self.oneBottomView.oneInputView.hidden = NO;
    self.oneBottomView.twoInputView.hidden = NO;
    self.oneBottomView.priceLabel.hidden = YES;
    [self.mapView removeAnnotation:self.annotation];
    
    [self setNav];
    self.title = @"";
    self->marqueeLabel.superview.frame = CGRectMake(20, 40 + 10, WIDTH - 20 * 2, 33);
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LOGO"]];
    imageView.frame = CGRectMake((WIDTH - self.navigationController.navigationBar.frame.size.height)/2, 0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.height);
    imageView.tag = 100;
    [self.navigationController.navigationBar addSubview:imageView];
}
- (void)uploadmapCenter:(CLLocationCoordinate2D) loc{
    
}
- (IBAction)locationBtnClicked:(id)sender {
    [_mapView setCenterCoordinate:_locationService.userLocation.location.coordinate animated:true];
    /*
    [App_ZLZ_Helper showLoadingView:@"获取位置中..."];
    [[BaiduMapLocationManager manager] getUserCurrentLocaiton:^(BMKLocation * location, BMKLocationNetworkState state, NSError * error) {
        [self->_mapView setCenterCoordinate:location.location.coordinate];
        [App_ZLZ_Helper removeLoadingView];
    }];*/
}

- (void)rightItemBtnClicked {
    NSLog(@"列表点击了！");

}
- (void)refreshEnlargeReduceViewsState{
    if (zoomLevel >= _mapView.maxZoomLevel) {
        if ([_enlargeView viewWithTag:100]) {
            return;
        }
        UIView * shadeView = [[UIView alloc] initWithFrame:CGRectZero];
        shadeView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        shadeView.tag = 100;
        [_enlargeView addSubview:shadeView];
        [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.enlargeView);
        }];
    }else{
        [[_enlargeView viewWithTag:100] removeFromSuperview];
    }
    if (zoomLevel <= _mapView.minZoomLevel) {
        if ([_reduceView viewWithTag:100]) {
            return;
        }
        UIView * shadeView = [[UIView alloc] initWithFrame:CGRectZero];
        shadeView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        shadeView.tag = 100;
        [_reduceView addSubview:shadeView];
        [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.reduceView);
        }];
    }else{
        [[_reduceView viewWithTag:100] removeFromSuperview];
    }
}
- (void)enlargeViewClicked {
    zoomLevel ++;
    if (zoomLevel > _mapView.maxZoomLevel) {
        zoomLevel = _mapView.maxZoomLevel;
    }
    [_mapView setZoomLevel:zoomLevel];
    [self refreshEnlargeReduceViewsState];
}
- (void)reduceViewClicked {
    zoomLevel --;
    if (zoomLevel < _mapView.minZoomLevel) {
        zoomLevel = _mapView.minZoomLevel;
    }
    [_mapView setZoomLevel:zoomLevel];
    [self refreshEnlargeReduceViewsState];
}

-(void)viewWillDisappear:(BOOL)animated {
    [BMKMapView enableCustomMapStyle:NO];//关闭个性化地图
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];

}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)changeMapAction:(UISegmentedControl *)segment {
    /*
     *注：必须在BMKMapView对象初始化之前设置自定义地图样式，设置后会影响所有地图实例
     *设置方法：+ (void)customMapStyle:(NSString*) customMapStyleJsonFilePath;
     */
    enableCustomMap = segment.selectedSegmentIndex == 1;
    //打开/关闭个性化地图
    [BMKMapView enableCustomMapStyle:enableCustomMap];
}

//添加标注
- (void)addPointAnnotations
{
    self.annotationDataArray = @[@{@"title":@"周蕾钊", @"isBusy":@"1", @"latitude":@"38.051681", @"longitude":@"114.484156"}, @{@"title":@"美丽人生", @"isBusy":@"1", @"latitude":@"38.051561", @"longitude":@"114.484256"},@{@"title":@"周蕾钊", @"isBusy":@"0", @"latitude":@"38.051281", @"longitude":@"114.484056"}];
    int i = 0;
    for (NSDictionary * dict in self.annotationDataArray) {
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = [NSString stringWithFormat:@"%d", i];
        double latitude = [dict[@"latitude"] doubleValue];
        double longitude = [dict[@"longitude"] doubleValue];
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.isLockedToScreen = false;
        [_mapView addAnnotation:annotation];
        i ++;
    }
}

#pragma mark - BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
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
        annotationView.image = [UIImage imageNamed:@"组-7"];
        return annotationView;
    }
    return nil;
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//
//        NSDictionary * dict = self.annotationDataArray[annotation.title.intValue];
//        BOOL isBusy = [dict[@"isBusy"] intValue];
//        NSString * titleStr = dict[@"title"];
//
//        NSString *AnnotationViewID = [NSString stringWithFormat:@"renameMark"];
//
//        BMKPinAnnotationView * newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//
//        // 设置颜色
//        ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
//        // 从天上掉下效果
//        ((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
//        // 设置可拖拽
//        ((BMKPinAnnotationView*)newAnnotation).draggable = NO;
//        //设置大头针图标
//        if (isBusy) {
//            ((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"nearby_busy"];
//        }else{
//            ((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"组-7"];
//        }
//
//        [[newAnnotation viewWithTag:100] removeFromSuperview];
//        UILabel * titleLabel = [[UILabel alloc] init];
//        titleLabel.font = [UIFont systemFontOfSize:11];
//        titleLabel.text = titleStr;
//        titleLabel.tag = 100;
//        titleLabel.frame = CGRectMake(32, 1, 35, 32);
//        //titleLabel.backgroundColor = [UIColor redColor];
//        titleLabel.adjustsFontSizeToFitWidth = true;
//        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        [newAnnotation addSubview:titleLabel];
//
//        return newAnnotation;
//    }
//
//    return nil;
}
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"BMKMapView控件初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    //    [alert show];
    //    alert = nil;
    
    [App_ZLZ_Helper removeLoadingView];
    UIImageView * imageview = [UIImageView new];
    imageview.image = [UIImage imageNamed:@"组-7"];
    [self.mapView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mapView);
        make.centerY.mas_equalTo(self.mapView).offset(-(33/2));
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(33);
    }];

}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
   
    
    if (self.isRefresh) {
        zoomLevel = mapView.zoomLevel;
        //初始化检索对象
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        //发起反向地理编码检索
        //CLLocationCoordinate2D pt = (CLLocationCoordinate2D){39.915, 116.404};
        
        BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
        reverseGeoCodeSearchOption.location = mapView.region.center;
        reverseGeoCodeSearchOption.isLatestAdmin = YES;
        BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        NSLog(@"map zoomlevel = %f", zoomLevel);
    }else{
        self.isRefresh = YES;
    }
    
}
//实现Deleage处理回调结果
//接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        if (result.poiList.count > 0) {
            BMKPoiInfo * point = result.poiList[0];
            //if (self.oneBottomView.beginLocationTextField) {
                self.oneBottomView.beginLocationTextField.text = point.name;
            //}else if (self.threeBottomView.beginTextField){
                self.threeBottomView.beginTextField.text = point.name;
            //}

            [App_ZLZ_Helper sendDataToServerUseUrl:@"user/home/getInfo" dataDict:@{@"longitude":[NSString stringWithFormat:@"%lf",point.pt.longitude], @"latitude":[NSString stringWithFormat:@"%lf",point.pt.latitude]} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * responseObj) {
                
                self.oneBottomView.numbersDriverLabel.text = [NSString stringWithFormat:@"%@名司机", responseObj[@"data"][@"driverNum"]];
                
                if ([NSString stringWithFormat:@"%@", responseObj[@"data"][@"discount"]].intValue > 0) {
                    self.oneBottomView.couponImageView.image = [UIImage imageNamed:@"图层-5_76"];
                    self.oneBottomView.couponLabel.text = [NSString stringWithFormat:@"优惠%@元", responseObj[@"data"][@"discount"]];
                }else {
                    self.oneBottomView.couponImageView.image = [UIImage imageNamed:@""];
                    self.oneBottomView.couponLabel.text = @"暂无优惠券";
                }
            } failedBlock:^(NSError * error) {
                
                self.oneBottomView.numbersDriverLabel.text = @"1名司机";
                
                self.oneBottomView.couponImageView.image = [UIImage imageNamed:@"图层-5"];
                self.oneBottomView.couponLabel.text = @"暂无优惠券";
            }];
        }
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
        
        self.oneBottomView.numbersDriverLabel.text = @"1名司机";
        
        self.oneBottomView.couponImageView.image = [UIImage imageNamed:@"图层-5"];
        self.oneBottomView.couponLabel.text = @"暂无优惠券";
    }
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}

#pragma mark - 添加自定义的手势（若不自定义手势，不需要下面的代码）

- (void)addCustomGestures {
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    
    [self.view addGestureRecognizer:doubleTap];
    
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {
    /*
     *do something
     */
    NSLog(@"my handleSingleTap");
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    /*
     *do something
     */
    NSLog(@"my handleDoubleTap");
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (IBAction)oneButtonClick:(id)sender {
    self.mapView.scrollEnabled = YES;
    self.bottomLineView.hidden = NO;
    self.twoBottomLineView.hidden = YES;
    self.threeBottomLineView.hidden = YES;
    //逻辑
    [self.mapView setCenterCoordinate:_locationService.userLocation.location.coordinate animated:YES];
    self.twoBottomView.hidden = YES;
    self.threeBottomView.hidden = YES;
    self.mapViewBottomConstraint.constant = 160;
    self.oneBottomView = [[DaiJiaBottomView alloc] init];
    [self.view addSubview:self.oneBottomView];
    [self.oneBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(160);
        make.top.mas_equalTo(self.mapView.mas_bottom);
    }];
    
    [self.oneBottomView.beginButton addTarget:self action:@selector(beginSearchAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.oneBottomView.endButton addTarget:self action:@selector(endSearchAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.oneBottomView.doneOrderButton addTarget:self action:@selector(xiaDan) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)twoButtonClick:(id)sender {
    GETUSERINFO
    if (!userInfo) {
        [self oneButtonClick:nil];
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        return;
    }
    self.mapView.scrollEnabled = NO;
    self.bottomLineView.hidden = YES;
    self.twoBottomLineView.hidden = NO;
    self.threeBottomLineView.hidden = YES;
    //逻辑:先判断代叫是否开启 然后 请求代叫地址
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/callDriver/checkForOtherCall" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * resObj) {
        //开启
        if ([[NSString stringWithFormat:@"%@",resObj[@"status"]] isEqualToString:@"1"]) {
            self.oneBottomView.hidden = YES;
            self.threeBottomView.hidden = YES;
            self.mapViewBottomConstraint.constant = 200;
            self.twoBottomView = [[DaiJiaTwoBottomView alloc] init];
            [self.view addSubview:self.twoBottomView];
            [self.twoBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.view);
                make.height.mas_equalTo(200);
                make.top.mas_equalTo(self.mapView.mas_bottom);
            }];
            self.twoBottomView.carPhoneTextField.delegate = self;
            [self.twoBottomView.topButton addTarget:self action:@selector(twoBeginClick) forControlEvents:UIControlEventTouchUpInside];
            [self.twoBottomView.bottomButton addTarget:self action:@selector(twoEndClick) forControlEvents:UIControlEventTouchUpInside];
            [self.twoBottomView.sendButton addTarget:self action:@selector(daiJiaoXiaDan) forControlEvents:UIControlEventTouchUpInside];
            [App_ZLZ_Helper sendDataToServerUseUrl:@"user/calledAddress/list" dataDict:@{} type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary * resObj) {
                if ([resObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                    self.twoBottomView.beginTextField.text = resObj[@"data"][@"calladdress"];
                    double lon = [resObj[@"data"][@"longitude"] doubleValue];
                    double lac = [resObj[@"data"][@"latitude"] doubleValue];
                    self.daiJiaoLocation = CLLocationCoordinate2DMake(lac, lon);
                    self.twoBottomView.driverNumberLabel.text = [NSString stringWithFormat:@"%@名司机", resObj[@"data"][@"driverNum"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView setCenterCoordinate:self.daiJiaoLocation animated:YES];
                    });
                }
            } failedBlock:^(NSError * error) {
                
            }];
        }else{
            [self oneButtonClick:nil];
        }
    } failedBlock:^(NSError * erroe) {
        [self oneButtonClick:nil];
    }];
    
}
- (IBAction)threeButtonClick:(id)sender {
    self.mapView.scrollEnabled = YES;
    self.bottomLineView.hidden = YES;
    self.twoBottomLineView.hidden = YES;
    self.threeBottomLineView.hidden = NO;
    //逻辑
    [self.mapView setCenterCoordinate:_locationService.userLocation.location.coordinate animated:YES];
    if (self.isRefresh) {
        zoomLevel = self.mapView.zoomLevel;
        //初始化检索对象
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        //发起反向地理编码检索
        //CLLocationCoordinate2D pt = (CLLocationCoordinate2D){39.915, 116.404};
        
        BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
        reverseGeoCodeSearchOption.location = self.mapView.region.center;
        reverseGeoCodeSearchOption.isLatestAdmin = YES;
        BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        NSLog(@"map zoomlevel = %f", zoomLevel);
    }else{
        self.isRefresh = YES;
    }
    self.oneBottomView.hidden = YES;
    self.twoBottomView.hidden = YES;
    self.mapViewBottomConstraint.constant = 160;
    self.threeBottomView = [[DaiJiaThreeBottomView alloc] init];
    [self.view addSubview:self.threeBottomView];
    [self.threeBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(160);
        make.top.mas_equalTo(self.mapView.mas_bottom);
    }];
    [self.threeBottomView.dateButton addTarget:self action:@selector(chooseDate) forControlEvents:UIControlEventTouchUpInside];
    [self.threeBottomView.topButton addTarget:self action:@selector(yuyueBegin) forControlEvents:UIControlEventTouchUpInside];
    [self.threeBottomView.bottomButton addTarget:self action:@selector(yuyueEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.threeBottomView.sendButton addTarget:self action:@selector(yuyueXiaDan) forControlEvents:UIControlEventTouchUpInside];
    
}
//代驾下单
- (void)xiaDan{
    if (self.oneBottomView.beginLocationTextField.text.length == 0) {
        [CommonAlertView showAlertWithMessage:@"起点不能为空！" AndTitle:@"温馨提示" Action:nil];
        return;
    }
    GETUSERINFO
    if (!userInfo) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }else{
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"longitude"] = [NSString stringWithFormat:@"%f",self.mapView.region.center.longitude];
        dic[@"latitude"] = [NSString stringWithFormat:@"%f",self.mapView.region.center.latitude];
        dic[@"startAddress"] = self.oneBottomView.beginLocationTextField.text;
        dic[@"type"] = @"1";//订单类型（1 正常下单，3 代叫下单）
        dic[@"endAddress"] = self.oneBottomView.endLocationTextField.text;
        [App_ZLZ_Helper sendDataToServerUseUrl:@"user/callDriver/order" dataDict:dic type:RequestType_Post loadingTitle:@"正在下单..." sucessTitle:@"下单完成" sucessBlock:^(NSDictionary * resObj) {
            NSLog(@"下单成功：%@",resObj);
            SendSingleViewController * send = [SendSingleViewController new];
            send.orderNum = resObj[@"data"];
            send.isYuYue = NO;
            [self.navigationController pushViewController:send animated:YES];
        } failedBlock:^(NSError *) {
            
        }];
    }
    
}
- (void)beginSearchAddress{
    __weak typeof(self) weakSelf = self;
    SearchAddressViewController * addressVc = [[SearchAddressViewController alloc] init];
    addressVc.isEnd = NO;
    addressVc.selectedCommonAddressBlock = ^(NSDictionary * dict) {
        self.isRefresh = NO;
        double latitude = ((NSString *)dict[@"latitude"]).doubleValue;
        double longitude = ((NSString *)dict[@"longitude"]).doubleValue;
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latitude, longitude);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //        [weakSelf uploadmapCenter:loc];
            [weakSelf.mapView setCenterCoordinate:loc animated:true];
            
            
        });
        
        self.oneBottomView.beginLocationTextField.text = dict[@"alias"];
    };
    addressVc.selectedCommonAddressBlock = ^(NSDictionary * dict) {
        self.isRefresh = NO;
        double latitude = ((NSString *)dict[@"latitude"]).doubleValue;
        double longitude = ((NSString *)dict[@"longitude"]).doubleValue;
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latitude, longitude);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //        [weakSelf uploadmapCenter:loc];
            [weakSelf.mapView setCenterCoordinate:loc animated:true];
            
            
        });
        
        self.oneBottomView.beginLocationTextField.text = dict[@"alias"];
    };
    addressVc.selectedRowBlock = ^(BMKPoiInfo * info , double lat , double lon , BOOL isEnd) {
        self.isRefresh = NO;
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //        [weakSelf uploadmapCenter:loc];
            [weakSelf.mapView setCenterCoordinate:loc animated:true];
            
            
        });
        
        self.oneBottomView.beginLocationTextField.text = info.name;
    };
    
    [self.navigationController pushViewController:addressVc animated:YES];
}
- (void)endSearchAddress{
    SearchAddressViewController * addressVc = [[SearchAddressViewController alloc] init];
    addressVc.isEnd = YES;
    
    addressVc.selectedCommonAddressBlock = ^(NSDictionary * dict) {
        self.isRefresh = NO;
        double lat = ((NSString *)dict[@"latitude"]).doubleValue;
        double lon = ((NSString *)dict[@"longitude"]).doubleValue;

        self.mapView.showsUserLocation = NO;
        self.topViewHeight.constant = 0;
        self.oneLabel.hidden = YES;
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
        [self setNewNav];
        //计算最小经纬度和最大经纬度两点之间的距离
        int dictance = [self getDistance:lat lon:lon];//单位好像是米
        self.oneBottomView.leftImage1.hidden = YES;
        self.oneBottomView.leftImage2.hidden = YES;
        self.oneBottomView.leftImage3.hidden = YES;
        self.oneBottomView.oneInputView.hidden = YES;
        self.oneBottomView.twoInputView.hidden = YES;
        self.oneBottomView.priceLabel.hidden = NO;
        self.oneBottomView.priceLabel.text = [NSString stringWithFormat:@"约%d元",dictance/1000*10];
        //这个数组就是百度地图比例尺对应的物理距离，其中2000000对应的比例是3，5对应的是21；可能有出入可以根据情况累加
        NSArray *zoomLevelArr = [[NSArray alloc]initWithObjects:@"2000000", @"1000000", @"500000", @"200000", @"100000", @"50000", @"25000", @"20000", @"10000", @"5000", @"2000", @"1000", @"500", @"200", @"100", @"50", @"20", @"10", @"5", nil];
        for (int j=0; j<zoomLevelArr.count; j++) {
            if (j + 1 < zoomLevelArr.count) {
                if (dictance < [zoomLevelArr[j] intValue] && dictance > [zoomLevelArr[j+1] intValue] ) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.mapView setZoomLevel:j+5];
                    });
                    break;
                }
            }
        }
        
        
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = dict[@"alias"];
        double latitude = lat;
        double longitude = lon;
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.isLockedToScreen = false;
        [self.mapView addAnnotation:annotation];
        self.annotation = annotation;
        self.oneBottomView.endLocationTextField.text = dict[@"alias"];
        
        self->marqueeLabel.superview.frame = CGRectMake(20, 10, WIDTH - 20 * 2, 33);
    };
    addressVc.selectedRowBlock = ^(BMKPoiInfo * info , double lat , double lon, BOOL isEnd) {
        self.mapView.showsUserLocation = NO;
        self.topViewHeight.constant = 0;
        self.oneLabel.hidden = YES;
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
        [self setNewNav];
        //计算最小经纬度和最大经纬度两点之间的距离
        int dictance = [self getDistance:lat lon:lon];//单位好像是米
        self.oneBottomView.leftImage1.hidden = YES;
        self.oneBottomView.leftImage2.hidden = YES;
        self.oneBottomView.leftImage3.hidden = YES;
        self.oneBottomView.oneInputView.hidden = YES;
        self.oneBottomView.twoInputView.hidden = YES;
        self.oneBottomView.priceLabel.hidden = NO;
        self.oneBottomView.priceLabel.text = [NSString stringWithFormat:@"约%d元",dictance/1000*10];
        //这个数组就是百度地图比例尺对应的物理距离，其中2000000对应的比例是3，5对应的是21；可能有出入可以根据情况累加
        NSArray *zoomLevelArr = [[NSArray alloc]initWithObjects:@"2000000", @"1000000", @"500000", @"200000", @"100000", @"50000", @"25000", @"20000", @"10000", @"5000", @"2000", @"1000", @"500", @"200", @"100", @"50", @"20", @"10", @"5", nil];
        for (int j=0; j<zoomLevelArr.count; j++) {
            if (j + 1 < zoomLevelArr.count) {
                if (dictance < [zoomLevelArr[j] intValue] && dictance > [zoomLevelArr[j+1] intValue] ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView setZoomLevel:j+5];
                    });
                    break;
                }
            }
        }
        
        
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = info.name;
        double latitude = lat;
        double longitude = lon;
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.isLockedToScreen = false;
        [self.mapView addAnnotation:annotation];
        self.annotation = annotation;
        self.oneBottomView.endLocationTextField.text = info.name;
        
        self->marqueeLabel.superview.frame = CGRectMake(20, 10, WIDTH - 20 * 2, 33);
    };
    
    [self.navigationController pushViewController:addressVc animated:YES];
}
//代叫
- (void)twoBeginClick{

    __weak typeof(self) weakSelf = self;
    if ([self.twoBottomView.beginTextField.text isEqualToString:@""]) {
        SearchAddressViewController * addressVc = [[SearchAddressViewController alloc] init];
        addressVc.isEnd = NO;
        
        addressVc.selectedCommonAddressBlock = ^(NSDictionary * dict) {
            double latitude = ((NSString *)dict[@"latitude"]).doubleValue;
            double longitude = ((NSString *)dict[@"longitude"]).doubleValue;
            NSString * infoName = dict[@"alias"];
            
            self.isRefresh = NO;
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latitude, longitude);
            self.daiJiaoLocation = loc;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //        [weakSelf uploadmapCenter:loc];
                [weakSelf.mapView setCenterCoordinate:loc animated:true];
                
                
            });
            self.twoBottomView.beginTextField.text = infoName;
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            param[@"address"] = infoName;
            param[@"longitude"] = [NSString stringWithFormat:@"%f",longitude];
            param[@"latitude"] = [NSString stringWithFormat:@"%f",latitude];
            [App_ZLZ_Helper sendDataToServerUseUrl:@"user/calledAddress/modify" dataDict:param type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary *) {
                
            } failedBlock:^(NSError *) {
                
            }];
        };
        
        addressVc.selectedRowBlock = ^(BMKPoiInfo * info , double lat , double lon , BOOL isEnd) {
            self.isRefresh = NO;
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
            self.daiJiaoLocation = loc;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //        [weakSelf uploadmapCenter:loc];
                [weakSelf.mapView setCenterCoordinate:loc animated:true];
                
                
            });
            self.twoBottomView.beginTextField.text = info.name;
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            param[@"address"] = info.name;
            param[@"longitude"] = [NSString stringWithFormat:@"%f",lon];
            param[@"latitude"] = [NSString stringWithFormat:@"%f",lat];
            [App_ZLZ_Helper sendDataToServerUseUrl:@"user/calledAddress/modify" dataDict:param type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary *) {
                
            } failedBlock:^(NSError *) {
                
            }];
        };
        [self.navigationController pushViewController:addressVc animated:YES];
    }else{
        [App_ZLZ_Helper sendDataToServerUseUrl:@"user/calledAddress/isNo" dataDict:@{} type:RequestType_Post loadingTitle:@"查询中..." sucessTitle:@"" sucessBlock:^(NSDictionary *resObj) {
            
            __weak typeof(self) weakSelf = self;
            if ([self.twoBottomView.beginTextField.text isEqualToString:@""]) {
                SearchAddressViewController * addressVc = [[SearchAddressViewController alloc] init];
                addressVc.isEnd = NO;
                
                addressVc.selectedCommonAddressBlock = ^(NSDictionary * dict) {
                    double latitude = ((NSString *)dict[@"latitude"]).doubleValue;
                    double longitude = ((NSString *)dict[@"longitude"]).doubleValue;
                    NSString * infoName = dict[@"alias"];
                    
                    self.isRefresh = NO;
                    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latitude, longitude);
                    self.daiJiaoLocation = loc;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //        [weakSelf uploadmapCenter:loc];
                        [weakSelf.mapView setCenterCoordinate:loc animated:true];
                        
                        
                    });
                    
                    self.twoBottomView.beginTextField.text = infoName;
                    NSMutableDictionary * param = [NSMutableDictionary dictionary];
                    param[@"address"] = infoName;
                    param[@"longitude"] = [NSString stringWithFormat:@"%f",longitude];
                    param[@"latitude"] = [NSString stringWithFormat:@"%f",latitude];
                    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/calledAddress/modify" dataDict:param type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary *) {
                        
                    } failedBlock:^(NSError *) {
                        
                    }];
                };
                
                
                addressVc.selectedRowBlock = ^(BMKPoiInfo * info , double lat , double lon , BOOL isEnd) {
                    self.isRefresh = NO;
                    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
                    self.daiJiaoLocation = loc;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //        [weakSelf uploadmapCenter:loc];
                        [weakSelf.mapView setCenterCoordinate:loc animated:true];
                        
                        
                    });
                    
                    self.twoBottomView.beginTextField.text = info.name;
                    NSMutableDictionary * param = [NSMutableDictionary dictionary];
                    param[@"address"] = info.name;
                    param[@"longitude"] = [NSString stringWithFormat:@"%f",lon];
                    param[@"latitude"] = [NSString stringWithFormat:@"%f",lat];
                    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/calledAddress/modify" dataDict:param type:RequestType_Post loadingTitle:@"" sucessTitle:@"" sucessBlock:^(NSDictionary *) {
                        
                    } failedBlock:^(NSError *) {
                        
                    }];
                };
                [self.navigationController pushViewController:addressVc animated:YES];
                
            }
        } failedBlock:^(NSError *) {
            
        }];
    }
}
- (void)twoEndClick{
    if (self.twoBottomView.beginTextField.text.length == 0) {
        [CommonAlertView showAlertWithMessage:@"请先选择起点" AndTitle:@"温馨提示" Action:nil];
        return;
    }
    SearchAddressViewController * addressVc = [[SearchAddressViewController alloc] init];
    addressVc.isEnd = YES;
    
    addressVc.selectedCommonAddressBlock = ^(NSDictionary * dict) {
        double latitude = ((NSString *)dict[@"latitude"]).doubleValue;
        double longitude = ((NSString *)dict[@"longitude"]).doubleValue;
        NSString * infoName = dict[@"alias"];
        
        self.mapView.showsUserLocation = NO;
//        self.topViewHeight.constant = 0;
//        self.oneLabel.hidden = YES;
//        self.twoLabel.hidden = YES;
//        self.threeLabel.hidden = YES;
        //        [self setNewNav];
        //计算最小经纬度和最大经纬度两点之间的距离
        int dictance = [self getDistance:latitude lon:longitude];//单位好像是米
        //        self.oneBottomView.leftImage1.hidden = YES;
        //        self.oneBottomView.leftImage2.hidden = YES;
        //        self.oneBottomView.leftImage3.hidden = YES;
        //        self.oneBottomView.oneInputView.hidden = YES;
        //        self.oneBottomView.twoInputView.hidden = YES;
        //        self.oneBottomView.priceLabel.hidden = NO;
        //        self.oneBottomView.priceLabel.text = [NSString stringWithFormat:@"约%d元",dictance/1000*10];
        //这个数组就是百度地图比例尺对应的物理距离，其中2000000对应的比例是3，5对应的是21；可能有出入可以根据情况累加
        NSArray *zoomLevelArr = [[NSArray alloc]initWithObjects:@"2000000", @"1000000", @"500000", @"200000", @"100000", @"50000", @"25000", @"20000", @"10000", @"5000", @"2000", @"1000", @"500", @"200", @"100", @"50", @"20", @"10", @"5", nil];
        for (int j=0; j<zoomLevelArr.count; j++) {
            if (j + 1 < zoomLevelArr.count) {
                if (dictance < [zoomLevelArr[j] intValue] && dictance > [zoomLevelArr[j+1] intValue] ) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.mapView setZoomLevel:j+5];
                    });
                    break;
                }
            }
        }
        
        
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = infoName;
        double latitude1 = latitude;
        double longitude1 = longitude;
        annotation.coordinate = CLLocationCoordinate2DMake(latitude1, longitude1);
        annotation.isLockedToScreen = false;
        [self.mapView addAnnotation:annotation];
        self.annotation = annotation;
        self.twoBottomView.endTextField.text = infoName;
        
        self->marqueeLabel.superview.frame = CGRectMake(20, 40 + 10, WIDTH - 20 * 2, 33);
    };
    
    addressVc.selectedRowBlock = ^(BMKPoiInfo * info , double lat , double lon, BOOL isEnd) {
        self.mapView.showsUserLocation = NO;
        self.topViewHeight.constant = 0;
        self.oneLabel.hidden = YES;
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
//        [self setNewNav];
        //计算最小经纬度和最大经纬度两点之间的距离
        int dictance = [self getDistance:lat lon:lon];//单位好像是米
//        self.oneBottomView.leftImage1.hidden = YES;
//        self.oneBottomView.leftImage2.hidden = YES;
//        self.oneBottomView.leftImage3.hidden = YES;
//        self.oneBottomView.oneInputView.hidden = YES;
//        self.oneBottomView.twoInputView.hidden = YES;
//        self.oneBottomView.priceLabel.hidden = NO;
//        self.oneBottomView.priceLabel.text = [NSString stringWithFormat:@"约%d元",dictance/1000*10];
        //这个数组就是百度地图比例尺对应的物理距离，其中2000000对应的比例是3，5对应的是21；可能有出入可以根据情况累加
        NSArray *zoomLevelArr = [[NSArray alloc]initWithObjects:@"2000000", @"1000000", @"500000", @"200000", @"100000", @"50000", @"25000", @"20000", @"10000", @"5000", @"2000", @"1000", @"500", @"200", @"100", @"50", @"20", @"10", @"5", nil];
        for (int j=0; j<zoomLevelArr.count; j++) {
            if (j + 1 < zoomLevelArr.count) {
                if (dictance < [zoomLevelArr[j] intValue] && dictance > [zoomLevelArr[j+1] intValue] ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView setZoomLevel:j+5];
                    });
                    break;
                }
            }
        }
        
        
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = info.name;
        double latitude = lat;
        double longitude = lon;
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.isLockedToScreen = false;
        [self.mapView addAnnotation:annotation];
        self.annotation = annotation;
        self.twoBottomView.endTextField.text = info.name;
        
        self->marqueeLabel.superview.frame = CGRectMake(20, 40 + 10, WIDTH - 20 * 2, 33);
    };
    
    [self.navigationController pushViewController:addressVc animated:YES];
}
- (void)daiJiaoXiaDan{
    if (self.twoBottomView.beginTextField.text.length == 0) {
        [CommonAlertView showAlertWithMessage:@"请设置代叫起点位置" AndTitle:@"温馨提示" Action:nil];
        return;
    }
    if (self.twoBottomView.carPhoneTextField.text.length != 11) {
        [CommonAlertView showAlertWithMessage:@"请输入正确的车主电话" AndTitle:@"温馨提示" Action:nil];
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"longitude"] = [NSString stringWithFormat:@"%f",self.daiJiaoLocation.longitude];
    dic[@"latitude"] = [NSString stringWithFormat:@"%f",self.daiJiaoLocation.latitude];
    dic[@"startAddress"] = self.twoBottomView.beginTextField.text;
    dic[@"type"] = @"3";//订单类型（1 正常下单，3 代叫下单）
    dic[@"endAddress"] = self.twoBottomView.endTextField.text;
    dic[@"phone"] = self.twoBottomView.carPhoneTextField.text;
    [App_ZLZ_Helper sendDataToServerUseUrl:@"user/callDriver/order" dataDict:dic type:RequestType_Post loadingTitle:@"正在下单..." sucessTitle:@"下单完成" sucessBlock:^(NSDictionary * resObj) {
        NSLog(@"下单成功：%@",resObj);
        [CommonAlertView showAlertWithMessage:@"下单成功，请等候！" AndTitle:@"温馨提示" Action:nil];
//        SendSingleViewController * send = [SendSingleViewController new];
//        send.orderNum = resObj[@"data"];
//        [self.navigationController pushViewController:send animated:YES];
    } failedBlock:^(NSError *) {
        
    }];
}
//预约
- (void)chooseDate{
    self.dataPickerView = [[DCDataPickerView alloc] initWithFrame:CGRectMake(10,SCREENHeight + 330, SCREENWidth - 20, 330)];
    self.dataPickerView.delegate = self;
    [self.view addSubview:self.dataPickerView];
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerView.frame = CGRectMake(10,SCREENHeight - 330, SCREENWidth - 20, 330);
    }];

}
- (void)yuyueBegin{
    __weak typeof(self) weakSelf = self;
    SearchAddressViewController * addressVc = [[SearchAddressViewController alloc] init];
    addressVc.isEnd = NO;
    
    addressVc.selectedCommonAddressBlock = ^(NSDictionary * dict) {
        double lat = ((NSString *)dict[@"latitude"]).doubleValue;
        double lon = ((NSString *)dict[@"longitude"]).doubleValue;
        NSString * infoName = dict[@"alias"];
        
        self.isRefresh = NO;
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //        [weakSelf uploadmapCenter:loc];
            [weakSelf.mapView setCenterCoordinate:loc animated:true];
            
            
        });
        
        self.threeBottomView.beginTextField.text = infoName;
    };
    
    addressVc.selectedRowBlock = ^(BMKPoiInfo * info , double lat , double lon , BOOL isEnd) {
        self.isRefresh = NO;
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //        [weakSelf uploadmapCenter:loc];
            [weakSelf.mapView setCenterCoordinate:loc animated:true];
            
            
        });
        
        self.threeBottomView.beginTextField.text = info.name;
    };
    
    [self.navigationController pushViewController:addressVc animated:YES];
}
- (void)yuyueEnd{
    SearchAddressViewController * addressVc = [[SearchAddressViewController alloc] init];
    addressVc.isEnd = YES;
    
    addressVc.selectedCommonAddressBlock = ^(NSDictionary * dict) {
        double lat = ((NSString *)dict[@"latitude"]).doubleValue;
        double lon = ((NSString *)dict[@"longitude"]).doubleValue;
        NSString * infoName = dict[@"alias"];
        
        self.mapView.showsUserLocation = NO;
        self.topViewHeight.constant = 0;
        self.oneLabel.hidden = YES;
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
        [self setNewNav];
        //计算最小经纬度和最大经纬度两点之间的距离
        int dictance = [self getDistance:lat lon:lon];//单位好像是米
        //        self.oneBottomView.leftImage1.hidden = YES;
        //        self.oneBottomView.leftImage2.hidden = YES;
        //        self.oneBottomView.leftImage3.hidden = YES;
        //        self.oneBottomView.oneInputView.hidden = YES;
        //        self.oneBottomView.twoInputView.hidden = YES;
        //        self.oneBottomView.priceLabel.hidden = NO;
        //        self.oneBottomView.priceLabel.text = [NSString stringWithFormat:@"约%d元",dictance/1000*10];
        //这个数组就是百度地图比例尺对应的物理距离，其中2000000对应的比例是3，5对应的是21；可能有出入可以根据情况累加
        NSArray *zoomLevelArr = [[NSArray alloc]initWithObjects:@"2000000", @"1000000", @"500000", @"200000", @"100000", @"50000", @"25000", @"20000", @"10000", @"5000", @"2000", @"1000", @"500", @"200", @"100", @"50", @"20", @"10", @"5", nil];
        for (int j=0; j<zoomLevelArr.count; j++) {
            if (j + 1 < zoomLevelArr.count) {
                if (dictance < [zoomLevelArr[j] intValue] && dictance > [zoomLevelArr[j+1] intValue] ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.mapView setZoomLevel:j+5];
                        });
                    });
                    break;
                }
            }
        }
        
        
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = infoName;
        double latitude = lat;
        double longitude = lon;
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.isLockedToScreen = false;
        [self.mapView addAnnotation:annotation];
        self.annotation = annotation;
        self.threeBottomView.endTextfield.text = infoName;
        
        self->marqueeLabel.superview.frame = CGRectMake(20, 10, WIDTH - 20 * 2, 33);
    };
    
    addressVc.selectedRowBlock = ^(BMKPoiInfo * info , double lat , double lon, BOOL isEnd) {
        self.mapView.showsUserLocation = NO;
        self.topViewHeight.constant = 0;
        self.oneLabel.hidden = YES;
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
        [self setNewNav];
        //计算最小经纬度和最大经纬度两点之间的距离
        int dictance = [self getDistance:lat lon:lon];//单位好像是米
//        self.oneBottomView.leftImage1.hidden = YES;
//        self.oneBottomView.leftImage2.hidden = YES;
//        self.oneBottomView.leftImage3.hidden = YES;
//        self.oneBottomView.oneInputView.hidden = YES;
//        self.oneBottomView.twoInputView.hidden = YES;
//        self.oneBottomView.priceLabel.hidden = NO;
//        self.oneBottomView.priceLabel.text = [NSString stringWithFormat:@"约%d元",dictance/1000*10];
        //这个数组就是百度地图比例尺对应的物理距离，其中2000000对应的比例是3，5对应的是21；可能有出入可以根据情况累加
        NSArray *zoomLevelArr = [[NSArray alloc]initWithObjects:@"2000000", @"1000000", @"500000", @"200000", @"100000", @"50000", @"25000", @"20000", @"10000", @"5000", @"2000", @"1000", @"500", @"200", @"100", @"50", @"20", @"10", @"5", nil];
        for (int j=0; j<zoomLevelArr.count; j++) {
            if (j + 1 < zoomLevelArr.count) {
                if (dictance < [zoomLevelArr[j] intValue] && dictance > [zoomLevelArr[j+1] intValue] ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView setZoomLevel:j+5];
                    });
                    break;
                }
            }
        }
        
        
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = info.name;
        double latitude = lat;
        double longitude = lon;
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.isLockedToScreen = false;
        [self.mapView addAnnotation:annotation];
        self.annotation = annotation;
        self.threeBottomView.endTextfield.text = info.name;
        
        self->marqueeLabel.superview.frame = CGRectMake(20, 10, WIDTH - 20 * 2, 33);
    };
    
    [self.navigationController pushViewController:addressVc animated:YES];
}
- (void)yuyueXiaDan{
    if (!self.yuYueDate || self.yuYueDate.length == 0) {
        [CommonAlertView showAlertWithMessage:@"请选择预约时间！" AndTitle:@"温馨提示" Action:nil];
        return;
    }
    if (self.threeBottomView.beginTextField.text.length == 0) {
        [CommonAlertView showAlertWithMessage:@"请选择起点！" AndTitle:@"温馨提示" Action:nil];
        return;
    }
    GETUSERINFO
    if (!userInfo) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }else{
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"longitude"] = [NSString stringWithFormat:@"%f",self.mapView.region.center.longitude];
        dic[@"latitude"] = [NSString stringWithFormat:@"%f",self.mapView.region.center.latitude];
        dic[@"startAddress"] = self.threeBottomView.beginTextField.text;
        dic[@"time"] = self.yuYueDate;
        dic[@"endAddress"] = self.threeBottomView.endTextfield.text;
        [App_ZLZ_Helper sendDataToServerUseUrl:@"user/appointment/order" dataDict:dic type:RequestType_Post loadingTitle:@"正在下单..." sucessTitle:@"下单完成" sucessBlock:^(NSDictionary * resObj) {
            NSLog(@"下单成功：%@",resObj);
            SendSingleViewController * send = [SendSingleViewController new];
            send.orderNum = resObj[@"data"];
            send.isYuYue = YES;
            [self.navigationController pushViewController:send animated:YES];
        } failedBlock:^(NSError *) {
            
        }];
    }
}
- (void)pickerDate:(DCDataPickerView *)pickerArea dayStr:(NSString *)dayStr houStr:(NSString *)houStr minStr:(NSString *)minStr{
    [self.threeBottomView.dateButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",dayStr,houStr,minStr] forState:UIControlStateNormal];
    if ([dayStr isEqualToString:@"今天"] && [houStr isEqualToString:@"现在"] && [minStr isEqualToString:@"现在"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *datenow = [NSDate date];
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        self.yuYueDate = currentTimeString;
    }else if ([houStr isEqualToString:@"现在"] && ![minStr isEqualToString:@"现在"]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *datenow = [NSDate date];
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        NSString * str = [[currentTimeString componentsSeparatedByString:@" "] lastObject];
        minStr = [minStr substringToIndex:[minStr length] - 1];
        str = [[str componentsSeparatedByString:@":"] firstObject];
        self.yuYueDate = [NSString stringWithFormat:@"%@ %@:%@:00",[self getCurrentTime],str,minStr];
    }else{
        houStr = [houStr substringToIndex:[houStr length] - 1];
        minStr = [minStr substringToIndex:[minStr length] - 1];
        if ([dayStr isEqualToString:@"今天"]) {
            self.yuYueDate = [NSString stringWithFormat:@"%@ %@:%@:00",[self getCurrentTime],houStr,minStr];
        }else if ([dayStr isEqualToString:@"明天"]){
            self.yuYueDate = [NSString stringWithFormat:@"%@ %@:%@:00",[self GetTomorrowDay:[self dateFromString:[self getCurrentTime]]],houStr,minStr];
        }else if ([dayStr isEqualToString:@"后天"]){
            self.yuYueDate = [NSString stringWithFormat:@"%@ %@:%@:00",[self GetHouTian:[self dateFromString:[self getCurrentTime]]],houStr,minStr];
        }
    }
    NSLog(@"预约时间：%@",self.yuYueDate);
}
//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//传入今天的时间，返回明天的时间
- (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}
//将字符串转成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
//后天
- (NSString *)GetHouTian:(NSDate *)aDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+2)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

@end