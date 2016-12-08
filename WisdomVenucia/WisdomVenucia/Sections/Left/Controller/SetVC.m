//
//  SetVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/18.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "SetVC.h"

static NSString * const identifier = @"MyCell";

@interface SetVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *imagelist;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"设置";
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"个人信息",@"车辆信息",@"设备信息",@"安防设置",@"修改密码",@"意见反馈",@"关于我们"];
    self.imagelist = @[@"SetImage1",@"SetImage2",@"LeftSet",@"SetImage4",@"SetImage5",@"SetImage6",@"SetImage7"];
}

#pragma mark --设置UI
- (void)initUI{
    [self initTableView];
    [self setSecLeftNavigation];
}

#pragma mark --设置表视图
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
    
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text      = self.titleList[indexPath.row];
    cell.textLabel.font      = SCREEN_HIGHT > 600? SYSTEMFONT(16) : SYSTEMFONT(14);
    cell.imageView.image     = [UIImage imageNamed:self.imagelist[indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor     = [UIColor clearColor];
    
    //背景色和分割线
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = CELL_COLOR_BACKGROUND;
    cell.selectedBackgroundView = back;
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, SCREEN_HIGHT/10-1, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HIGHT/10;
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            //个人信息
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"MyInfoVC" object:nil info:nil];
            break;
        }
        case 1:{
            //车辆信息
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"CarInfoVC" object:nil info:nil];
            break;
        }
        case 2:{
            //设备信息
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"DeviceInfoVC" object:nil info:nil];
            break;
        }
        case 3:{
            //安防设置
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"SafeProtectSetVC" object:nil info:nil];
            break;
        }
        case 4:{
            //修改密码
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"MotifiyPassWordVC" object:nil info:nil];
            break;
        }
        case 5:{
            //意见反馈
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"FeedBackVC" object:nil info:nil];
            break;
        }
        case 6:{
            //关于同致
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"AboutVenuciaVC" object:nil info:nil];
            break;
        }
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
