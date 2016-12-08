//
//  RescuSettingVCViewController.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 16/7/7.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "RescuSettingVCViewController.h"
#import "RescuListCell.h"
#import "AddRescuManView.h"

@interface RescuSettingVCViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *rescuMans;

@property (nonatomic, strong) AddRescuManView *addManView;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation RescuSettingVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"救援设置";
    self.rescuMans = [NSMutableArray array];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightItmeAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.tableView];
    
    if (self.rescuMans.count <= 0) {
        self.isShow = YES;
        [self.addManView showAddRescuManView];
    }
}

- (void)rightItmeAction {
    self.isShow = !self.isShow;
    //弹出输入框
    if (self.isShow) {
        [self.addManView showAddRescuManView];
    }else {
        [self.addManView hideRescuManView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = VIEWFRAME(0, 64, ViewWidth(self.view), ViewHeight(self.view) - 64);
}

#pragma mark -- UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rescuMans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RescuListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[RescuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark -- Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 180;
        _tableView.tableFooterView = [[UIView alloc]init];
        
    }
    
    return _tableView;
}

- (AddRescuManView *)addManView {
    if (!_addManView) {
        _addManView = [[AddRescuManView alloc] initWithFrame:APP_BOUNDS];
        _weekSelf(weakSelf);
        _addManView.buttonClickedBlock = ^(NSInteger tag, NSString *name, NSString *phone) {
            if (tag == 101) { //完成,调用接口完成保存数据
                if (name.length <= 0 || phone.length <= 0) {
                    [MBProgressHUD showInfoHudTipStr:@"请输入必要信息"];
                    return ;
                }
            }else if (tag == 102) { //取消
                
            }
            weakSelf.isShow = NO;
            [weakSelf.addManView hideRescuManView];
        };
    }
    return _addManView;
}

@end
