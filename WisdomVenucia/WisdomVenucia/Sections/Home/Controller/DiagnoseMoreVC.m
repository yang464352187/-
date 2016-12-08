//
//  DiagnoseMoreVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/21.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "DiagnoseMoreVC.h"

static NSString * const identifier = @"DiagnoseCell";

@interface DiagnoseMoreVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *imagelist;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation DiagnoseMoreVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"诊断详情";
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"燃油供给系统",@"总线系统",@"点火系统",@"冷却系统",@"制动系统",@"胎压监测"];
    self.imagelist = @[@"DiagnoseMore1",@"DiagnoseMore2",@"DiagnoseMore3",@"DiagnoseMore4",@"DiagnoseMore5",@"DiagnoseMore6"];
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
    [self.view addSubview:self.tableView];
    
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text      = self.titleList[indexPath.row];
    cell.textLabel.font      = SCREEN_HIGHT > 600? SYSTEMFONT(16) : SYSTEMFONT(14);
    cell.imageView.image     = [UIImage imageNamed:self.imagelist[indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = SCREEN_HIGHT > 600? SYSTEMFONT(16) : SYSTEMFONT(14);
    cell.backgroundColor     = [UIColor clearColor];
    
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = @"2项";
    }else{
        cell.detailTextLabel.text = @"正常";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    //背景色和分割线
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = CELL_COLOR_BACKGROUND;
    cell.selectedBackgroundView = back;
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, 59, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
