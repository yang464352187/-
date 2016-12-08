//
//  AboutVenuciaVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "AboutVenuciaVC.h"

static NSString * const identifier = @"AboutVenuciaCell";

@interface AboutVenuciaVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AboutVenuciaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"关于智慧同致";
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"  同致，多彩生活，触手可及。",
                       @"  地址：广州市花都区风神大道8号",
                       @"  客服电话：800-830-8899",
                       @"  联系邮箱：customercare@dfl.com.cn",
                       @"  官方网站：www.dongfeng-nissan.com.cn",
                       @"  技术支持：同致电子科技有限公司"];
    
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
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled   = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
}


#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text            = self.titleList[indexPath.row];
    cell.textLabel.font            = SYSTEMFONT(14);
    cell.textLabel.textColor       = [UIColor whiteColor];
    cell.backgroundColor           = [UIColor clearColor];
    
    //背景色和分割线
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, 54, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
