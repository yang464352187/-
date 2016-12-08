//
//  RescueDetailVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 16/3/11.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "RescueDetailVC.h"

@interface RescueDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray     *listData;

@end

@implementation RescueDetailVC

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self Adds];
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.tableView];
    
}

#pragma mark -- Data
- (void)initData{
    self.listData = self.notificationDict[@"listData"];
    self.title = self.notificationDict[@"title"];
}

#pragma mark -- UI
- (void)initUI{
    [self setSecLeftNavigation];
}

#pragma mark -- event response

#pragma mark -- UITabelViewDelegate And DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RescueDetailCell"];
    
    cell.textLabel.text      = self.listData[indexPath.row];
    cell.textLabel.font      = SYSTEMFONT(16);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor     = [UIColor clearColor];
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 0;
    
    //背景色和分割线
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = CELL_COLOR_BACKGROUND;
    cell.selectedBackgroundView = back;
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, 60, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64+10, SCREEN_WIDTH, SCREEN_HIGHT-64-10)];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RescueDetailCell"];
        
    }
    return _tableView;
}


@end
