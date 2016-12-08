
//
//  PathListVC.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "PathListVC.h"
#import "PathReShowCell.h"
#import "RPSharedListModel.h"
#import "PathReShowVC.h"

@interface PathListVC ()<UITableViewDataSource, UITableViewDelegate>

{
    NSInteger _pageNo;
    NSInteger _pageSize;
    NSInteger _totalSize;
}

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *sharedLists;

@end

@implementation PathListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self setNaviBar];
}

- (void)initData{
    _pageSize = 10;
    _pageNo   = 1;
    
    self.sharedLists = [NSMutableArray array];
}

- (void)initUI{
    self.tableView                 = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth(self.view), ViewHeight(self.view) - 64)];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshAction)];
    MJRefreshFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshAction)];
    self.tableView.header = header;
    self.tableView.footer = footer;
    
    [self.tableView.header beginRefreshing];

    [self.view addSubview:self.tableView];

}

- (void)setNaviBar{
    _weekSelf(weakSelf);
    self.title = @"历史轨迹";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"GoBack"] selectBlock:^{
        [weakSelf popGoBack];
    }];
}

#pragma mark -RefreshAction
- (void)headerFreshAction{
    _pageNo = 1;
    [self getLocationShared];
}

- (void)footerFreshAction{
    if ((_pageNo - 1) * _pageSize >= _totalSize) {
        [MBProgressHUD showSuccessHudTipStr:@"已全部加载数据"];
        return;
    }
    [self getLocationShared];
    _pageNo += 1;
}

- (void)stopRefresh{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sharedLists.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PathReShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[PathReShowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    LocationShareModel *model = self.sharedLists[indexPath.row];
    [cell configCellDataWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PathReShowVC *reShowVC = [[PathReShowVC alloc]init];
    reShowVC.locationModel = self.sharedLists[indexPath.row];
    [self.navigationController pushViewController:reShowVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    PathReShowCell *cell = (PathReShowCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return [cell getCellHeight];
    return 75;
}

//获取位置共享列表
- (void)getLocationShared{
    _weekSelf(weakSelf);
    NSString *path       = [APP_BASEURL stringByAppendingPathComponent:@"/zhihuiqichen/locationshare/listlocationsharepost"];
    NSDictionary *params = @{@"token"      : self.currentLoginUser.token,
                             @"pageNo"     : @(_pageNo),
                             @"pageSize"   : @(_pageSize),
                             @"orderBy"    : @"createtime",
                             };
    [[NetAPIManager sharedManager]request_common_WithPath:path Params:params succesBlack:^(id data) {
        if ([data[@"code"]integerValue] == 1) {
            [_sharedLists removeAllObjects];
            RPSharedListModel *sharedModel = [MTLJSONAdapter modelOfClass:[RPSharedListModel class] fromJSONDictionary:data error:nil];
            [_sharedLists addObjectsFromArray:sharedModel.locationShares];
            _totalSize = [sharedModel.total integerValue];
            [_tableView reloadData];
        }else{
            [MBProgressHUD showError:data[@"msg"]];
        }
        [weakSelf stopRefresh];
    } failue:^(id data, NSError *error) {
        [weakSelf stopRefresh];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
