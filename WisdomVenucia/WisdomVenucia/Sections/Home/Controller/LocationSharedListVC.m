//
//  LocationSharedListVC.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "LocationSharedListVC.h"
#import "CreateLocationSharedVC.h"
#import "RPSharedListModel.h"
#import "LocationSharedCell.h"
#import "LocationManager.h"

@interface LocationSharedListVC ()<UITableViewDataSource, UITableViewDelegate>

{
    NSInteger      _pageNo;
    NSInteger      _pageSize;
    NSInteger      _totalSize;
}

@property (nonatomic, strong) LocationShareModel *selectShareMode; //选中的事件，用于距离计算
@property (nonatomic, strong) UITableView         *tableView;
@property (nonatomic, strong) NSMutableArray      *dataSource; //列表数据源
@property (nonatomic, strong) NSMutableArray      *switchs;

@property (nonatomic, assign) NSInteger currentEvent; //当前事件

@end

@implementation LocationSharedListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBar];
    [self initData];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.currentEvent == [DEFAULTS_GET_OBJ(@"row")integerValue] && [DEFAULTS_GET_OBJ(@"row")integerValue] != 0) {
        return;
    }
    //重新刷新数据状态
    [self.tableView.header beginRefreshing];
}

- (void)initData{
    self.dataSource  = [NSMutableArray array];
    self.switchs     = [NSMutableArray array];
    
    _pageSize = 10;
    _pageNo   = 1;
}

- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth(self.view), ViewHeight(self.view) - 64) style:UITableViewStylePlain];
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
    self.title = @"位置共享列表";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"GoBack"] selectBlock:^{
        [weakSelf popGoBack];
    }];
    
    UIButton *homeButton                    = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [homeButton setImage:[UIImage imageNamed:@"LocationSharedHome"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeButtonClike) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem               = [[UIBarButtonItem alloc]initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItems = @[homeItem];
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
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationSharedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[LocationSharedCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [_switchs addObject:cell.uploadLocationSwitch];
    LocationShareModel *shareModel = self.dataSource[indexPath.row];
    if (DEFAULTS_GET_OBJ(@"row") && indexPath.row == [DEFAULTS_GET_OBJ(@"row")integerValue]) {
        shareModel.isLocation = YES;
    }
    [cell configCellDataWithModel:shareModel];
    
    _weekSelf(weakSelf);
    cell.uploadLocationBlock = ^(UISwitch *sender){
        weakSelf.selectShareMode = weakSelf.dataSource[indexPath.row];
        for (UISwitch *uploadSwitch in weakSelf.switchs) {
            if (sender == uploadSwitch) {
                if (sender.isOn) {
                    [MBProgressHUD showInfoHudTipStr:@"事件启动"];
                    weakSelf.currentEvent = indexPath.row;
                    DEFAULTS_SET_OBJ(@(indexPath.row), @"row");
                    [LocationManager sharedManager].selectShareMode = weakSelf.selectShareMode;
                    [[LocationManager sharedManager] startLocation];//开始持续定位
                }else{
                    [MBProgressHUD showInfoHudTipStr:@"事件结束"];
                    [[LocationManager sharedManager] stopLocation];//停止持续定位
                    DEFAULTS_REMOVE(@"row");
                }

            }else{
                [uploadSwitch setOn:NO];
            }
        }
    };

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    LocationShareModel *shareModel = self.dataSource[indexPath.row];
    if (shareModel) {
        _weekSelf(weakSelf);
        CreateLocationSharedVC *createVC = [[CreateLocationSharedVC alloc]init];
        createVC.shareModel              = shareModel;
        createVC.reGetDataBlock          = ^(void){
            [weakSelf.tableView.header beginRefreshing];
        };
        [self.navigationController pushViewController:createVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LocationShareModel *shareModel = (LocationShareModel *)self.dataSource[indexPath.row];
        [self deleteLocationSharedWithID:shareModel.locationshareid];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - ButtonClick
- (void)homeButtonClike{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - httpRequest
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
            [weakSelf.dataSource removeAllObjects];
            RPSharedListModel *sharedModel = [MTLJSONAdapter modelOfClass:[RPSharedListModel class] fromJSONDictionary:data error:nil];
            [weakSelf.dataSource addObjectsFromArray:sharedModel.locationShares];
            _totalSize = [sharedModel.total integerValue];
            [weakSelf.tableView reloadData];
        }else{
            [MBProgressHUD showError:data[@"msg"]];
        }
        [weakSelf stopRefresh];
    } failue:^(id data, NSError *error) {
        [weakSelf stopRefresh];
    }];
}

//删除某条位置共享
- (void)deleteLocationSharedWithID:(NSNumber *)locationshareid{
    NSString *path       = [APP_BASEURL stringByAppendingPathComponent:@"/zhihuiqichen/locationshare/dellocationsharepost"];
    NSDictionary *params = @{@"token"           : self.currentLoginUser.token,
                             @"locationshareid" : locationshareid,
                             };
    [[NetAPIManager sharedManager]request_common_WithPath:path Params:params succesBlack:^(id data) {
        if ([data[@"code"]integerValue] == 1) {
            [MBProgressHUD showSuccessHudTipStr:@"删除成功"];
        }else{
            [MBProgressHUD showError:data[@"msg"]];
        }
    } failue:^(id data, NSError *error) {
        
    }];
}

@end
