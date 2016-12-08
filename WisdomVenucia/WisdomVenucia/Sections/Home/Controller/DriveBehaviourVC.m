//
//  DriveBehaviourVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "DriveBehaviourVC.h"
#import "DriveBehaviourCell.h"
#import "MCRadarChartView.h"

@interface DriveBehaviourVC ()<MCRadarChartViewDataSource>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) MCRadarChartView *radarChartView;

@end

@implementation DriveBehaviourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self setSecLeftNavigation];
    self.title = @"驾驶行为";
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titles = @[@"经济车速得分 ( 累计 )",@"急加油 ( 累计 )",@"急刹车 ( 累计 )",@"急转弯 ( 累计 )",@"弯道加速 ( 累计 )",@"频繁变道 ( 累计 )",@"平均热车时间 ( 累计 )",@"停使空转 ( 累计 )",@"下坡加速度 ( 累计 )"];
}

#pragma mark --设置UI
- (void)initUI{
    self.view.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:85/255.0 alpha:1.0];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    _titles = @[@"安全", @"时程", @"预判", @"文明", @"操纵"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _titles.count; i ++) {
        [mutableArray addObject:@((arc4random()%100)/100.0)];
    }
    _dataSource = [NSArray arrayWithArray:mutableArray];
    
    _radarChartView = [[MCRadarChartView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 500)];
    _radarChartView.dataSource = self;
    _radarChartView.radius = 100;
    _radarChartView.pointRadius = 2;
    _radarChartView.backgroundColor = [UIColor clearColor];
    _radarChartView.strokeColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
    _radarChartView.fillColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:0.2];
    _radarChartView.transform = CGAffineTransformMakeScale(1.4, 1.4);
    [self.view addSubview:_radarChartView];
    
    [_radarChartView reloadDataWithAnimate:YES];
    
    
    UIView *square = [[UIView alloc] init];
    square.backgroundColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
    [self.view addSubview:square];
    
    
    UILabel *label = [UILabel createLabelWithFrame:VIEWFRAME(0, 0, 16, 16)
                                           andText:@"驾驶行为分析"
                                      andTextColor:[UIColor whiteColor]
                                        andBgColor:[UIColor clearColor]
                                           andFont:SYSTEMFONT(14)
                                  andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.height.mas_offset(20);
    }];
    
    [square mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.right.equalTo(label.mas_left).offset(-10);
    }];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _titles.count; i ++) {
        [mutableArray addObject:@((arc4random()%100)/100.0)];
    }
    _dataSource = [NSArray arrayWithArray:mutableArray];
    [_radarChartView reloadData];
}

- (NSInteger)numberOfValueInRadarChartView:(MCRadarChartView *)radarChartView {
    return _titles.count;
}

- (id)radarChartView:(MCRadarChartView *)radarChartView valueAtIndex:(NSInteger)index {
    return @((arc4random()%100)/100.0);
}

- (NSString *)radarChartView:(MCRadarChartView *)radarChartView titleAtIndex:(NSInteger)index {
    return _titles[index];
}

- (NSAttributedString *)radarChartView:(MCRadarChartView *)radarChartView attributedTitleAtIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:_titles[index] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}


@end
