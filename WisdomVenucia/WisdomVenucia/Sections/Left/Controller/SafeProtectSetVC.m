//
//  SafeProtectSetVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "SafeProtectSetVC.h"

static NSString * const identifier = @"MyInfoCell";

@interface SafeProtectSetVC ()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) UISwitch    *switchControl;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SafeProtectSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    self.title = @"安防设置";
    
}



- (void)initUI{
    //安全防护开关

    [self initTableView];
    
    [self setSecLeftNavigation];
}

#pragma mark --设置表视图
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, SCREEN_HIGHT)];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled   = NO;
    [self.view addSubview:self.tableView];
    
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text            = @"快捷密码保护";
        cell.imageView.image           = [UIImage imageNamed:@"SetImage4"];
        self.switchControl = [[UISwitch alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-80, 15, 30, 20)];
        self.switchControl.transform = CGAffineTransformMakeScale(0.9, 0.9);
        ViewRadius(self.switchControl, 15.5);
        self.switchControl.thumbTintColor = [UIColor whiteColor];
        //self.switchControl.tintColor = APP_COLOR_SWITCH_GRAY;
        self.switchControl.backgroundColor = APP_COLOR_SWITCH_GRAY;
        [cell addSubview:self.switchControl];
    } else {
        cell.textLabel.text            = @"快捷控制密码修改";
        cell.imageView.image           = [UIImage imageNamed:@"CarInfoRightBtn"];
        cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *cut1 = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, 1)];
        cut1.backgroundColor = CELL_COLOR_CUT;
        [cell addSubview:cut1];
        
        UIView *cut2 = [[UIView alloc] initWithFrame:VIEWFRAME(0, 59, SCREEN_WIDTH, 1)];
        cut2.backgroundColor = CELL_COLOR_CUT;
        [cell addSubview:cut2];
    }
    
    cell.textLabel.font            = SYSTEMFONT(14);
    cell.textLabel.textColor       = [UIColor whiteColor];
    cell.backgroundColor           = [UIColor clearColor];
    
    //背景色和分割线
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = CELL_COLOR_BACKGROUND;
    cell.selectedBackgroundView = back;

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (self.switchControl.isOn) {
            [self.switchControl setOn:NO animated:YES];
        }else{
            [self.switchControl setOn:YES animated:YES];
        }
    }else{
        [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"MotifyQuickVC" object:nil info:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
