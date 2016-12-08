//
//  RootViewController.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/17.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationVC.h"
#import "LeftVC.h"
#import "HomeVC.h"
#import "RightVC.h"
#import "LoginVC.h"
#import "DoorConditionVC.h"

static RootViewController * sharedVC = nil;

@interface RootViewController ()<RESideMenuDelegate>

@property (nonatomic, strong) HomeVC     *homeVC;// 主视页面

@property (nonatomic, strong) LeftVC     *leftMenuVC;// 左侧抽屉栏

@property (nonatomic, strong) RightVC    *rightMenuVC;// 右侧抽屉栏

@property (nonatomic, strong) RESideMenu *resideMenu;

@property (nonatomic, weak)  AppDelegate *appdelegate;

@end

@implementation RootViewController

+(instancetype)sharedRootVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVC = [[RootViewController alloc] init];
        [sharedVC initResideMenu];
    });
    return sharedVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate   = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![LoginModel isLogin]) {
        BOOL firstFix = DEFAULTS_GET_BOOL(mAPPFIRSTFIX);
        if (!firstFix) {
            DEFAULTS_SET_BOOL(YES, mAPPFIRSTFIX);
            MainPageVC *vc = [[MainPageVC alloc] init];
            appDelegate.window.rootViewController = vc;
        }else{
            LoginVC *loginVC = [[LoginVC alloc]init];
            BaseNavigationVC *navi = [[BaseNavigationVC alloc] initWithRootViewController:loginVC];
            appDelegate.window.rootViewController = navi;
        }
        
    }else{
        appDelegate.window.rootViewController = self.resideMenu;
    }
    
    

}



- (void)initResideMenu{
    // 左侧抽屉栏视图
    _leftMenuVC  = [[LeftVC alloc] init];
    
    // 右侧抽屉栏视图
    _rightMenuVC = [[RightVC alloc] init];
    
    // 主视图
    _homeVC      = [[HomeVC alloc] init];
    BaseNavigationVC *nav = [[BaseNavigationVC alloc] initWithRootViewController:_homeVC];
    
    // 初始化滑动栏并添加各个视图
    RESideMenu *reSideMenu = [[RESideMenu alloc] initWithContentViewController:nav
                                                        leftMenuViewController:_leftMenuVC
                                                       rightMenuViewController:_rightMenuVC];
    // 设置RESideMenu各项属性
    reSideMenu.delegate = self;
    reSideMenu.backgroundImage             = [UIImage imageNamed:@"LeftBackground"];      // 背景图片
    reSideMenu.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;            // 状态栏样式
    reSideMenu.contentViewShadowEnabled    = NO;                                     // 开启背景阴影
    reSideMenu.contentViewShadowColor      = [UIColor blackColor];                    // 阴影颜色
    reSideMenu.contentViewShadowOffset     = CGSizeMake(0, 0);                        // 阴影大小
    reSideMenu.contentViewShadowOpacity    = 0.6;
    reSideMenu.contentViewShadowRadius     = 12;
    //reSideMenu.contentViewScaleValue       = 1.0;
    //reSideMenu.contentViewShadowOffset     = CGSizeMake(0, 0);
    //reSideMenu.parallaxContentMinimumRelativeValue = 0.3;
    //reSideMenu.scaleMenuView = NO;
    //reSideMenu.menuViewControllerTransformation = CGAffineTransformMakeScale(0.8, 1.0);
    self.resideMenu = reSideMenu;
}

- (void)ChangeRootVC{
    AppDelegate *appDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![LoginModel isLogin]) {
        BaseNavigationVC *navi = [[BaseNavigationVC alloc] initWithRootViewController:[[LoginVC alloc]init]];
        appDelegate.window.rootViewController = navi;
    }else{
        
        appDelegate.window.rootViewController = self.resideMenu;
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
