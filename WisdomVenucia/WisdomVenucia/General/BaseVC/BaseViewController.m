//
//  BaseViewController.m
//  PaperSource
//
//  Created by Yhoon on 15/10/13.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationVC.h"


@interface BaseViewController ()

@property (nonatomic, copy) GoBackBlock goBack;
@property (nonatomic, copy) NavRightItemButtonBlock rightBarButtonBlock;

@end

@implementation BaseViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentLoginUser = [UserModel readCurLoginUser];
    [self addLoginViewControllerJumpNotificationcCenter];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _currentLoginUser = [UserModel readCurLoginUser];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // TODO:这里做处理UI元素改变处理
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addViewControllerJumpNotificationcCenter]; // 注册跳转通知
    // TODO:这里做通知处理
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeViewControllerJumpNotificationCenter]; // 移除跳转通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"deallce:%@",NSStringFromClass(self.class));
}

#pragma mark - Set NavigationBar
- (void)setRightNavigationItemWithImage:(UIImage *)image selectBlock:(NavRightItemButtonBlock)selectBlock {
    _rightBarButtonBlock = selectBlock;
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = VIEWFRAME(0, 0, 25, 25);
    [messageButton setImage:image forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(rightNavigationItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    [messageButton showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setLeftNavigationItemWithImage:(UIImage *)image selectBlock:(GoBackBlock)selectBlock {
    _goBack = selectBlock;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClicked)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

#pragma mark - NotificationCenter
- (void)addViewControllerJumpNotificationcCenter {
    if ([[self.class description] isEqualToString:@"LeftVC"] || [[self.class description] isEqualToString:@"RightVC"]) {
        return;
    }

    // Present通知注册(等待接收通知)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responsePresentNotification:)
                                                 name:Notification_PRESENT_VIEWCONTROLLER
                                               object:nil];
    
    // Push通知注册(等待接收通知)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(responsePushNotification:)
                                                 name:Notification_PUSH_VIEWCONTROLLER
                                               object:nil];
}

- (void)addLoginViewControllerJumpNotificationcCenter {
    // 登录页面弹出通知注册(等待接收通知)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(presentLoginViewConroller)
                                                 name:Notification_PRESENT_LOGINVIEWCONTROLLER
                                               object:nil];
}

/**
 *  发送页面跳转通知,在继承的子类中使用
 *
 *  @param aName     跳转通知类型
 *  @param className 跳转到的目标控制器名称
 *  @param anObject  通知携带传递的对象,可为空
 *  @param info      通知携带传递的数据,字典或者数组或者是其他数据对象格式
 */
- (void)postViewControllerJumpNotificationByTypeName:(NSString *)aName className:(NSString *)className object:(id)anObject info:(id)info {
    
    NSMutableDictionary *notify = [NSMutableDictionary dictionary];
    [notify setObject:className forKey:@"ClassName"];       // 将需要传递的ClassName放入通知字典中
    if (info != nil) {
        [notify setObject:info forKey:Notification_INFO_KEY]; // 将需要传递的数据放入到通知字典中
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:notify];
}


// 跳转通知移除
- (void)removeViewControllerJumpNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_PUSH_VIEWCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_PRESENT_VIEWCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_PRESENT_LOGINVIEWCONTROLLER object:nil];
}

#pragma mark - NotificationCenter Event Response
// PresentNotification响应事件
- (void)responsePresentNotification:(NSNotification *)notify {
    NSDictionary *info         = notify.userInfo ? notify.userInfo : notify.object;

    NSString *className        = info[@"ClassName"];        // 获取类名
    NSDictionary *notification = info[Notification_INFO_KEY]; // 通知传递的字典

    // 初始化传递进来的类
    Class class                = NSClassFromString( className );
    id pClass                  = [[class alloc] init];
    
    // 将需要传递的值放入notification中
    [pClass performSelector:@selector(setNotificationDict:) withObject:notification];
    [self presentViewController:pClass animated:YES completion:nil];
}

// PushNotification响应事件
- (void)responsePushNotification:(NSNotification *)notify {
    NSDictionary *info         = notify.userInfo ? notify.userInfo : notify.object;

    NSString *className        = info[@"ClassName"];        // 获取类名
    NSDictionary *notification = info[Notification_INFO_KEY]; // 通知传递的字典
    
    // 初始化传递进来的类
    Class class                = NSClassFromString( className );
    id pClass                  = [[class alloc] init];
    
    // 将需要传递的值放入notification中
    [pClass performSelector:@selector(setNotificationDict:) withObject:notification];
    [self.navigationController pushViewController:pClass animated:YES];
}

#pragma mark - NavigationBar Event Response
- (void)rightNavigationItemClicked:(UIButton *)button {
    _rightBarButtonBlock(button);
}

- (void)leftBarButtonClicked {
    _goBack();
}

- (void)popGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissGoback {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LoginNavigationController
- (void)presentLoginViewConroller {
    
}

@end
