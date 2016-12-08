//
//  ResponsibilityVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 16/3/14.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "ResponsibilityVC.h"

@interface ResponsibilityVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray     *listData;
@property (strong, nonatomic) NSArray     *titleList;
@end

@implementation ResponsibilityVC

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self Adds];
    self.title = @"责任认定";
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.tableView];
}

#pragma mark -- Data
- (void)initData{
    
    self.listData = @[@"变更车道与正常车道行驶的车辆发生事故，要负全部责任。",
                      @"在正常行驶状态下，前方车辆无故倒车造成事故的，责任全部要由前车承担。",
                      @"右侧超车发生事故，超车车辆要承担全部责任。",
                      @"中心黄色双实线表示严格禁止车辆跨线超车或压线形式，一旦车辆因超车越线发生事故就要负责全部责任。黄色虚线可以并线，调换车道，但一旦因超车越线发生事故就将负全部责任。",
                      @"在相同车道行驶的机动车发生追尾事故，后方车辆要负全部责任。",
                      @"掉头车辆未让对面直行车，造成事故要由掉头车辆承担全部责任。"];
    self.titleList = @[@"变更车道",@"倒车溜车",@"右侧超车",@"越线超车",@"追尾事故",@"掉头未让行"];
    
}

#pragma mark -- UI
- (void)initUI{
    [self setSecLeftNavigation];
}

#pragma mark -- event response

#pragma mark -- UITabelViewDelegate And DataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResponsiCell"];
    
    cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text      = self.titleList[indexPath.row];
    cell.textLabel.font      = SYSTEMFONT(16);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor     = [UIColor clearColor];
    
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
    NSString *name = self.listData[indexPath.row];
    NSString *title= self.titleList[indexPath.row];
    NSString *image = [NSString stringWithFormat:@"respon_%li",indexPath.row];
    NSDictionary *notify = @{@"title"    : title,
                             @"string"   : name,
                             @"image"    : image};
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ResponsibilityDetailVC" object:nil info:notify];
}

#pragma mark -- getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, SCREEN_HIGHT-64)];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator   = NO;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ResponsiCell"];
    }
    return _tableView;
}



@end
