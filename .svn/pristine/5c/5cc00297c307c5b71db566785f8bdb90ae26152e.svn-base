//
//  HomeViewController.m
//  DaiJia
//
//  Created by GaoBingnan on 2018/6/9.
//  Copyright © 2018年 GaoBingnan. All rights reserved.
//

#import "HomeViewController.h"
#import "GenerationDrivingViewController.h"//代驾
#import "GenerationCalledViewController.h"//代叫
#import "AppointmentViewController.h"//预约
#import "AppDelegate.h"
#import "NearbyViewController.h"
#import <JhtMarquee/JhtHorizontalMarquee.h>
@interface HomeViewController ()<UIScrollViewDelegate>
{
    JhtHorizontalMarquee * marqueeLabel;
}
//存在子视图控制器的view
@property (nonatomic, strong) UIScrollView *scrollView;
//上面所有按钮的父视图
@property (nonatomic, strong) UIView *titlesView;
/** 标题栏底部的指示器 */ //小红条
@property (nonatomic, strong) UIView *titleBottomView;
/** 存放所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *titleButtons;
/** 当前被选中的按钮 */
@property (nonatomic, strong) UIButton *selectedTitleButton;
@property (nonatomic,strong) NSArray * titleArray;
@property (nonatomic,strong)UIView * maskView;
@end

@implementation HomeViewController
#pragma mark - lazy load
- (NSMutableArray *)titleButtons
{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController pushViewController:[[NearbyViewController alloc] init] animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeClick) name:@"closeLeft" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openClick) name:@"openLeft" object:nil];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    self.titleArray = @[@"代驾",@"代叫",@"预约"];
    [self initSubControllers];
    [self initScrollView];
    [self initTopView];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick1)];

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
    [view addGestureRecognizer:tap];
    [self.view insertSubview:view atIndex:1000];
    self.maskView = view;
    self.maskView.hidden = YES;
    
    // Do any additional setup after loading the view.
    [self addNotificationView];
}

#pragma mark 添加公告
- (void)addNotificationView {

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(20, ZLZStatusBarHeight + ZLZNavBarHeight + 40 + 20, WIDTH - 20 * 2, 40)];
    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(0, 64, self.view.width, 40);
    [self.maskView addSubview:view];
    
//    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (view.frame.size.height - 20)/2, 20, 20)];
//    imgView.image = [UIImage imageNamed:@"图层-3"];
//    [view addSubview:imgView];
//
//    if (marqueeLabel == nil) {
//        marqueeLabel = [[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(imgView.frame.origin.x + imgView.frame.size.width + 5, 0, view.frame.size.width - (imgView.frame.origin.x + imgView.frame.size.width + 5 + 5), view.frame.size.height)];
//        [view addSubview:marqueeLabel];
//    }
//
//    marqueeLabel.text = @"周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊周蕾钊";
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [marqueeLabel marqueeOfSettingWithState:MarqueeStart_H];
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
- (void)setNav{
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"home_left"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 25, 20);
    [leftView addSubview:button];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
}
//抽屉按钮
- (void)leftClick{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.leftSlideVC.closed){
        [tempAppDelegate.leftSlideVC openLeftView];
    }
    else{
        [tempAppDelegate.leftSlideVC closeLeftView];
    }
}
- (void)initSubControllers{
    GenerationDrivingViewController * driving = [[GenerationDrivingViewController alloc]init];
    [self addChildViewController:driving];
    GenerationCalledViewController * call = [[GenerationCalledViewController alloc]init];
    [self addChildViewController:call];
    AppointmentViewController * Appointment = [[AppointmentViewController alloc]init];
    [self addChildViewController:Appointment];
}
- (void)initScrollView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.frame = CGRectMake(0, 64, SCREENWidth, SCREENHeight-64);
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.childViewControllers.count * SCREENWidth, 0);
    [self.view addSubview:_scrollView];
    
    // 默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:_scrollView];
}
- (void)initTopView{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.frame = CGRectMake(0, 64, self.view.width, 40);
    
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    // 标签栏内部的标签按钮
    NSUInteger count = self.childViewControllers.count;
    CGFloat titleButtonH = titlesView.height;
    CGFloat titleButtonW = titlesView.width / count;
    for (int i = 0; i < count; i++) {
        // 创建
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titlesView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        
        // 文字
        NSString *title = self.titleArray[i];
        [titleButton setTitle:title forState:UIControlStateNormal];
        titleButton.tag = 400+i;
        // frame
        titleButton.y = 0;
        titleButton.height = titleButtonH;
        titleButton.width = titleButtonW;
        titleButton.x = i * titleButton.width;
    }
    
    // 标签栏底部的指示器控件
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [self.titleButtons.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.height = 1;
    titleBottomView.y = titlesView.height - titleBottomView.height;
    [titlesView addSubview:titleBottomView];
    self.titleBottomView = titleBottomView;
    
    // 默认点击最前面的按钮
    UIButton *firstTitleButton = self.titleButtons.firstObject;
    [firstTitleButton.titleLabel sizeToFit];
    titleBottomView.width = firstTitleButton.titleLabel.width/2;
    titleBottomView.centerX = firstTitleButton.centerX;
    [self titleClick:firstTitleButton];
}
#pragma mark - 监听
- (void)titleClick:(UIButton *)titleButton
{
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    // 底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.width = titleButton.titleLabel.width;
        self.titleBottomView.centerX = titleButton.centerX;
    }];
    
    // 让scrollView滚动到对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.view.width * [self.titleButtons indexOfObject:titleButton];
    [self.scrollView setContentOffset:offset animated:YES];
}
//为了滑动一页加载一页节省内存
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 取出对应的子控制器
    int index = scrollView.contentOffset.x / scrollView.width;//width是写了一个view 的类目 与 masonry 冲突  可以把自己写的类目的属性名 与 masonry 命名区分开
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    // 如果控制器的view已经被创建过，就直接返回
    if (willShowChildVc.isViewLoaded) return;
    
    // 添加子控制器的view到scrollView身上
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}

/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    int index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titleButtons[index]];
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
