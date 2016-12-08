//
//  RightVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/17.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "RightVC.h"
#import "RightCell.h"

@interface RightVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIImageView *HeadImage;
@property (strong, nonatomic) NSArray *imagelist;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) UITableView *tableView;

@end

static NSString * const identifier = @"RightCell";

@implementation RightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"经济车速得分 ( 累计 )",@"急加油 ( 累计 )",@"急刹车 ( 累计 )",@"急转弯 ( 累计 )",@"弯道加速 ( 累计 )",@"频繁变道 ( 累计 )",@"平均热车时间 ( 累计 )",@"停使空转 ( 累计 )",@"下坡加速度 ( 累计 )"];
    self.imagelist = @[@"DriveBehaviour1",@"DriveBehaviour2",@"DriveBehaviour3",@"DriveBehaviour4",@"DriveBehaviour5",@"DriveBehaviour6",@"DriveBehaviour7",@"DriveBehaviour8",@"DriveBehaviour9"];
}

#pragma mark --设置UI
- (void)initUI{
    [self initTableView];
    [self setSecLeftNavigation];
}


#pragma mark --设置表视图
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/3, 64, SCREEN_WIDTH*2/3, SCREEN_HIGHT-64)];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[RightCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
    
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RightCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


@end
