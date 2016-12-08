//
//  LeftVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/17.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "LeftVC.h"
#import "LoginVC.h"
#import "MyInfoVC.h"

#define LeftCellHight  (SCREEN_HIGHT == 480) ? 44 : 52

@interface LeftVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIButton     *headButton;
@property (strong, nonatomic) NSArray      *titleList;
@property (strong, nonatomic) NSArray      *imageList;
@property (strong, nonatomic) UIImageView  *headImage;
@property (strong, nonatomic) UITableView  *tableView;
@property (strong, nonatomic) UILabel      *nickName;

@end

@implementation LeftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}


- (void)initData{
    self.titleList = @[@"首页",@"蓝牙连接",@"常用联系人",@"设置",@"退出登录"];
    self.imageList = @[@"LeftToHome",@"LeftBluetooth",@"LeftFriends",@"LeftSet",@"LeftCancel"];
    [self addNotification];
}


- (void)initUI{
    [self initTableView];
    CGFloat t =  (SCREEN_HIGHT*3/10 + 20 - 135) ;
    self.headButton = [[UIButton alloc] initWithFrame:VIEWFRAME(SCREEN_HIGHT/10, t, 80, 80)];
    ViewRadius(self.headButton, 40);
    self.nickName = [[UILabel alloc] initWithFrame:VIEWFRAME(SCREEN_HIGHT/10-40, 95+t, 160, 20)];
    self.nickName.textAlignment = NSTextAlignmentCenter;
    self.nickName.textColor = [UIColor whiteColor];
    self.nickName.font = SYSTEMFONT(16);
    NSDictionary *userInfo = DEFAULTS_GET_OBJ(mLOGINUSERINFO);
    if (userInfo) {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",APP_BASEURL,userInfo[@"avatar"]];
        //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        //[self.headButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        [self.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:strUrl]
                                             forState:UIControlStateNormal
                                     placeholderImage:[UIImage imageNamed:@"HeadImage"]];
        self.nickName.text = userInfo[@"nickname"];
        
    }else{
        [self.headButton setBackgroundImage:[UIImage imageNamed:@"HeadImage"] forState:UIControlStateNormal];
    }
    [self.headButton addTarget:self action:@selector(headImageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.headButton];
    [self.view addSubview:self.nickName];
}

- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(30, SCREEN_HIGHT*3/10 + 20, SCREEN_WIDTH-30, SCREEN_HIGHT/2)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    [self.view addSubview:self.tableView];
}
#pragma  mark -- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.titleList[indexPath.row];
    cell.textLabel.font = SYSTEMFONT(16);
    
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = CELL_COLOR_BACKGROUND;
    cell.selectedBackgroundView = back;
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, LeftCellHight-1, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:self.imageList[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            //首页
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:{
            //蓝牙连接
            [self.sideMenuViewController hideMenuViewController];
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"BlueToothVC" object:nil info:nil];
            break;
        }
        case 2:{
            //常用联系人
            [self.sideMenuViewController hideMenuViewController];
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ContactManListVC" object:nil info:nil];
            break;
        }
        case 3:{
            //设置
            [self.sideMenuViewController hideMenuViewController];
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"SetVC" object:nil info:nil];
            break;
        }
        case 4:{
            //退出登录
            //[self Logout];
            [self.sideMenuViewController hideMenuViewController];
            [MBProgressHUD showHudTipStr:@"退x出登录成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LoginModel doLoginOut];
                [[RootViewController sharedRootVC] ChangeRootVC];
            });
            break;
        }
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LeftCellHight;
}

#pragma mark -- 注册通知 当个人信息改变时发送通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ModifyUserInfo) name:kLeftVC object:nil];
}

- (void)ModifyUserInfo{
    NSDictionary *userInfo = DEFAULTS_GET_OBJ(mLOGINUSERINFO);
    if (userInfo) {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",APP_BASEURL,userInfo[@"avatar"]];
        //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        //[self.headButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        [self.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:strUrl]
                                             forState:UIControlStateNormal
                                     placeholderImage:[UIImage imageNamed:@"HeadImage"]];
        self.nickName.text = userInfo[@"nickname"];
    }

}

#pragma mark -- 头像点击事件
- (void)headImageClick{
    [self.sideMenuViewController hideMenuViewController];
    //个人信息
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"MyInfoVC" object:nil info:nil];

}


#pragma mark -- 退出登录
- (void)Logout{
    NSDictionary *dict = @{
                           @"token":self.currentLoginUser.token
                           };
    
    _weekSelf(weakSelf);
    [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_Logout Params:dict succesBlack:^(id data) {
        [weakSelf.sideMenuViewController hideMenuViewController];
        [LoginModel doLoginOut];
        [MBProgressHUD showHudTipStr:@"退出登录成功"];
        [[RootViewController sharedRootVC] ChangeRootVC];
    } failue:^(id data, NSError *error) {
        if (data) {
            NSLog(@"退出登录失败");
        }
        
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
