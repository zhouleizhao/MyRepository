//
//  LeftSlideViewController.m
//  Touch
//
//  Created by lanou3g on 15/12/14.
//  Copyright © 2015年 syx. All rights reserved.
//

#import "LeftSlideViewController.h"

@interface LeftSlideViewController ()<UIGestureRecognizerDelegate>{
    CGFloat _scalef;  //实时横向位移
    UIView * rightMaskView;
}
@property (nonatomic,strong) UITableView * leftTableView;
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,assign) CGFloat leftTableViewW;
@end

@implementation LeftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 初始化左视图和右视图
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC{
    self = [super init];
    if (self) {
        self.speedf = 0.7;
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        
        // 滑动手势
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
        [self.mainVC.view addGestureRecognizer:self.pan];
        
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
        
        self.leftVC.view.hidden = YES;
        [self.view addSubview:self.leftVC.view];
        [self.leftVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        // 蒙版
        UIView * view = [[UIView alloc]initWithFrame:self.leftVC.view.bounds];
        view.backgroundColor = [UIColor blackColor];
        self.contentView = view;
        [self.leftVC.view addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.leftVC.view);
        }];
        
        // 获取左侧TableView
        for (UIView * obj in self.leftVC.view.subviews) {
            if ([obj isKindOfClass:[UITableView class]]) {
                self.leftTableView = (UITableView *)obj;
            }
        }
        
        self.leftTableView.backgroundColor = [UIColor clearColor];
        self.leftTableView.frame = CGRectMake(0, 0, WIDTH - 100, HEIGHT);
        
        [self.view addSubview:self.mainVC.view];
        
        self.view.backgroundColor = [UIColor whiteColor];
        [self.mainVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.view);
            make.width.mas_equalTo(SCREENWidth);
        }];
        
        self.closed = YES;//初始时侧滑窗关闭
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    NSLog(@"self.view.frame = %@, %f", NSStringFromCGRect(self.view.frame),[UIApplication sharedApplication].statusBarFrame.size.height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
    self.navigationController.navigationBar.hidden = true;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
}

// 关闭左视图
- (void)closeLeftView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeLeft" object:nil];
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake(WIDTH / 2, HEIGHT / 2);
    self.closed = YES;
    
    for (NSLayoutConstraint * con in self.view.constraints) {
        if (con.firstItem == self.mainVC.view && con.firstAttribute == NSLayoutAttributeLeft) {
            con.constant = 0;
        }
    }
    [self.view layoutIfNeeded];
    
    self.leftTableView.center = CGPointMake(30, HEIGHT * 0.5);
    self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
    self.contentView.alpha = kLeftAlpha;
    
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self->rightMaskView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self->rightMaskView removeFromSuperview];
                         self->rightMaskView = nil;
                     }];
}


// 打开左视图
- (void)openLeftView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openLeft" object:nil];
    
    if (rightMaskView == nil) {
        rightMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
        rightMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.mainVC.view addSubview:rightMaskView];
        /*
         [rightMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.mainVC.view);
         }];*/
        UITapGestureRecognizer * tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeftView)];
        [rightMaskView addGestureRecognizer:tapGr];
    }
    
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
    self.mainVC.view.center = kMainPageCenter;
    
    for (NSLayoutConstraint * con in self.view.constraints) {
        if (con.firstItem == self.mainVC.view && con.firstAttribute == NSLayoutAttributeLeft) {
            con.constant = SCREENWidth - 100;
        }
    }
    [self.view layoutIfNeeded];
    
    self.closed = NO;
    
    self.leftTableView.center = CGPointMake((WIDTH - 100) * 0.5, HEIGHT * 0.5);
    self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.contentView.alpha = 0;
    
    [UIView commitAnimations];
    // [self disableTapButton];
}


/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */
- (void)setPanEnabled: (BOOL) enabled{

    [self.pan setEnabled:enabled];

}

#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.closed = YES;
        
        self.leftTableView.center = CGPointMake(30, HEIGHT * 0.5);
        self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.7,0.7);
        self.contentView.alpha = kLeftAlpha;
        
        [UIView commitAnimations];
        _scalef = 0;
        // [self removeSingleTap];
    }
    
}

// 手势触发事件
- (void)panGestureAction:(UIPanGestureRecognizer *)panAction{

    CGPoint point = [panAction translationInView:self.view];
    _scalef = (point.x * self.speedf + _scalef);

    BOOL needMoveWithTap = YES; // 是否跟随手势移动
    if (((self.mainVC.view.frame.origin.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.frame.origin.x >= (WIDTH - 100 )) && (_scalef >= 0))) {
        //
        _scalef = 0;
        needMoveWithTap = NO;
    }
    
    // 根据视图位置判断是左滑还是右滑
    if (needMoveWithTap && (panAction.view.frame.origin.x >= 0) && (panAction.view.frame.origin.x <= (WIDTH - 100))) {
        CGFloat panCenterX = panAction.view.center.x + point.x * self.speedf;
        if (panCenterX < WIDTH * 0.5 - 2) {
            panCenterX = WIDTH * 0.5;
        }
        CGFloat panCenterY = panAction.view.center.y;
        panAction.view.center = CGPointMake(panCenterX, panCenterY);
        
        // scale
        CGFloat scale = 1;
        panAction.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        [panAction setTranslation:CGPointMake(0, 0) inView:self.view];
        CGFloat leftTabCenterX = 30 + ((WIDTH - 100) * 0.5 - 30) * (panAction.view.frame.origin.x / (WIDTH - 100));
        NSLog(@"%f",leftTabCenterX);
        
        // leftScale
        CGFloat leftScale = 0.7 + (1 - 0.7) * (panAction.view.frame.origin.x / (WIDTH - 100));
        
        self.leftTableView.center = CGPointMake(leftTabCenterX, HEIGHT * 0.5);
        self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
        
        //tempAlpha kLeftAlpha~0
        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (panAction.view.frame.origin.x / (WIDTH - 100));
        self.contentView.alpha = tempAlpha;

    }else{
        //超出范围，
        if (self.mainVC.view.frame.origin.x < 0){
            [self closeLeftView];
            _scalef = 0;
        }
        else if (self.mainVC.view.frame.origin.x > (WIDTH - 100)){
            [self openLeftView];
            _scalef = 0;
        }
    }
    //手势结束后修正位置,超过约一半时向多出的一半偏移
    if (panAction.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > vCouldChangeDeckStateDistance)
        {
            if (self.closed)
            {
                [self openLeftView];
            }
            else
            {
                [self closeLeftView];
            }
        }
        else
        {
            if (self.closed)
            {
                [self closeLeftView];
            }
            else
            {
                [self openLeftView];
            }
        }
        _scalef = 0;
    }

    
}

#pragma mark - Delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    NSLog(@"touch.view.tag = %d", touch.view.tag);
    if (CGRectContainsPoint(CGRectMake(0, 40, SCREENWidth, SCREENHeight - 200), [touch locationInView:self.view]))
    {
                NSLog(@"不响应侧滑");
        return NO;
    }
    else
    {
                NSLog(@"响应侧滑");
        return YES;
    }
}

@end
