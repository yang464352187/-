//
//  HomeVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/17.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "HomeVC.h"
#import "LocationUserVC.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface HomeVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;// 头顶滑动视图
@property (strong, nonatomic) UIImageView       *pageLeft;
@property (strong, nonatomic) UIImageView       *pageRight;
@property (strong, nonatomic) UIImage           *pageN;
@property (strong, nonatomic) UIImage           *pageU;
@property (strong, nonatomic) NSArray           *titleList;
@property (strong, nonatomic) UIScrollView      *scrollView;
@property (strong, nonatomic) NSMutableArray    *buttonArray;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"智慧同致";
    [self initData];
    [self initUI];
}



#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"车况查询",@"位置共享",@"快捷控制",@"轨迹回放",@"行车安全",@"驾驶行为",@"车辆诊断",@"保养预约",@"bug",@"bug"];
    self.buttonArray = [[NSMutableArray alloc] init];
}
#pragma mark -- 设置UI
- (void)initUI{
    [self InitImageView];
    [self initScrollView];
    [self setNavgationBarLeftItemWithImage:[UIImage imageNamed:@"NavigationLeft"]];
    //[self setNavgationBarRightItemWithImage:[UIImage imageNamed:@"NavigationRight"]];
    [self getCycleByNetWork];
}

- (void)getCycleByNetWork{
    NSDictionary *dic = @{@"pageNo"   : @1,
                          @"pageSize" : @5,
                          @"orderBy"    : @"createtime"
                          };
    _weekSelf(weakSelf);
    [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_Cycle Params:dic succesBlack:^(id data) {
        NSArray *arr = data[@"viewpages"];
        NSMutableArray *pages = [NSMutableArray array];
        for (NSDictionary *page in arr) {
            NSString *imagepath = [NSString stringWithFormat:@"%@%@",APP_BASEURL,page[@"viewpageKey"]];
            [pages addObject:imagepath];
        }
        [weakSelf.cycleScrollView setImageURLStringsGroup:pages];
    } failue:^(id data, NSError *error) {
        
    }];
}


#pragma mark -- 设置image视图
- (void)InitImageView{
    UIImageView *background = [[UIImageView alloc] initWithFrame:APP_BOUNDS];
    background.image = [UIImage imageNamed:@"HomeBackground"];
    [self.view addSubview:background];
    
    [self.view addSubview:self.cycleScrollView];
}

#pragma mark -- 设置滚动视图
- (void)initScrollView{
    CGFloat h = SCREEN_WIDTH == 320 ?  SCREEN_HIGHT*2/3-64-40 :  SCREEN_HIGHT*2/3-64-80;
    self.scrollView = [[UIScrollView alloc] initWithFrame:VIEWFRAME(0, 64 + SCREEN_HIGHT/3, SCREEN_WIDTH, h)];
    self.scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH*2, 0);
    self.scrollView.pagingEnabled                  = YES;
    self.scrollView.delegate                       = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    self.scrollView.backgroundColor                = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    [self initButtonView];
}
#pragma mark -- 创建8个图文按钮
- (void)initButtonView{
    CGFloat h = ViewHeight(self.scrollView);
    UIView *view1 = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, h)];
    UIView *view2 = [[UIView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH, 0, SCREEN_WIDTH, h)];
    view1.backgroundColor = [UIColor clearColor];
    view2.backgroundColor = [UIColor clearColor];
    CGFloat w = (SCREEN_WIDTH - 225)/6;
    h = (h-200)/3;
    for (int i = 0 ; i < 8; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+2000;
        NSString *imageName = [NSString stringWithFormat:@"HomeButton%d",i+1];
        NSString *imageName_Sel = [NSString stringWithFormat:@"%@_Sel",imageName];
        
        [button setImage:[UIImage imageNamed:imageName]
               withTitle:self.titleList[i]
                forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageName_Sel] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:imageName_Sel] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i< 6) {
            button.frame = VIEWFRAME((i%3*2+1)*w+75*(i%3), (i/3+1)*h+(i/3)*100, 75, 100);
            [view1 addSubview:button];
        }else{
            button.frame = VIEWFRAME((i%3*2+1)*w+75*(i%3), h, 75, 100);
            [view2 addSubview:button];
        }
        [self.buttonArray addObject:button];
    }
    //翻页图片
    self.pageN = [UIImage imageNamed:@"HomePage_n"];
    self.pageU = [UIImage imageNamed:@"HomePage_u"];
    self.pageLeft = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-self.pageN.size.width-3,ViewY(self.scrollView) + ViewHeight(self.scrollView) + 10, self.pageN.size.width, self.pageN.size.height)];
    self.pageLeft.image = self.pageN;
    
    self.pageRight = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2+3, ViewY(self.scrollView) + ViewHeight(self.scrollView) + 10, self.pageN.size.width, self.pageN.size.height)];
    self.pageRight.image = self.pageU;
    [self.view addSubview:self.pageLeft];
    [self.view addSubview:self.pageRight];
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
}

#pragma mark -- 图文按钮动作
- (void)ButtonClick:(UIButton *)sender{
    sender.selected = YES;
    switch (sender.tag) {
        case 2000:{
            //车况查询
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"CarConditionVC" object:nil info:nil];
            break;
        }
        case 2001:{
            //位置共享
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"LocationUserVC" object:nil info:nil];
            break;
        }
        case 2002:{
            //快捷控制
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"QuickControlVC" object:nil info:nil];
            break;
        }
        case 2003:{
            //轨迹回放
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER
                                                     className:@"PathListVC" object:nil info:nil];
            break;
        }
        case 2004:{
            //行车安全
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"DrivingSafeVC" object:nil info:nil];
            break;
        }
        case 2005:{
            //驾驶行为
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"DriveBehaviourVC" object:nil info:nil];
            break;
        }
        case 2006:{
            //车辆诊断
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"DiagnoseVC" object:nil info:nil];
            break;
        }
        case 2007:{
            //保养预约
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"AppointmentVC" object:nil info:nil];
            break;
        }
        default:
            break;
    }
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
}


#pragma mark -- 导航栏按钮
- (void)setNavgationBarLeftItemWithImage:(UIImage *)image {
    UIBarButtonItem *leftItemButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(presentLeftMenuViewController:)];
    //leftItemButton.imageInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    self.navigationItem.leftBarButtonItem = leftItemButton;
}


- (void)setNavgationBarRightItemWithImage:(UIImage *)image {
    UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(presentRightMenuViewController:)];
    //rightItemButton.imageInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    self.navigationItem.rightBarButtonItem = rightItemButton;
}



#pragma mark -- scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > SCREEN_WIDTH/2) {
        self.pageLeft.image = self.pageU;
        self.pageRight.image = self.pageN;
    }else{
        self.pageLeft.image = self.pageN;
        self.pageRight.image = self.pageU;
    }
}


- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, SCREEN_HIGHT/3) imageNamesGroup:@[@"HomeImage"]];
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.backgroundColor = APP_COLOR_BASE_BACKGROUND;
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = APP_COLOR_BASE_BAR;
        _cycleScrollView.autoScroll = NO;
    }
    return _cycleScrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
