//
//  DrivingSafeVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/19.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "DrivingSafeVC.h"

static NSString * const identifier = @"MySafeCell";

@interface DrivingSafeVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *imagelist;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation DrivingSafeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"行车安全";
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"责任认定",@"停车计时",@"碰撞救援",@"救援电话",@"未锁提醒"];
    self.imagelist = @[@"DrivingSafe1",@"DrivingSafe2",@"DrivingSafe3",@"DrivingSafe4",@"DrivingSafe5"];
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
            //责任认定
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ResponsibilityVC" object:nil info:nil];
            break;
        }
        case 1:{
            //停车计时
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"StopTimeVC" object:nil info:nil];
            break;
        }
        case 2:{
            //碰撞救援
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"RescuSettingVCViewController" object:nil info:nil];
            break;
        }
        case 3:{
            //救援电话
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"RescueVC" object:nil info:nil];
            break;
        }
        case 4:{
            //未锁提醒
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"UnLockVC" object:nil info:nil];
            break;
        }
        
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
