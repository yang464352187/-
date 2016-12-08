//
//  CarInfoVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/18.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "CarInfoVC.h"
#import "CarModel.h"

static NSString * const identifier = @"MyCell";


@interface CarInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *imagelist;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) CarModel *model;
@property (strong, nonatomic) NSArray *cars;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation CarInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"车辆信息";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getListCars];
}

- (void)getListCars{
    NSDictionary *dic = @{@"token"     :self.currentLoginUser.token,
                          @"pageNo"    :@(1),
                          @"pageSize"  :@(10),
                          @"orderBy"   :@"createtime"};
    _weekSelf(weakSelf);
    [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE__ListCar Params:dic succesBlack:^(id data) {
        self.cars = [MTLJSONAdapter modelsOfClass:[CarModel class] fromJSONArray:data[@"carInfos"] error:nil];
        if (DEFAULTS_GET_OBJ(mCARINFOID)) {
            for (CarModel *model in weakSelf.cars) {
                if ([model.carinfoid isEqualToNumber:DEFAULTS_GET_OBJ(mCARINFOID)]) {
                    weakSelf.model = model;
                    [weakSelf.tableView reloadData];
                    break;
                }
            }
        }else{
            weakSelf.model = [weakSelf.cars firstObject];
            DEFAULTS_SET_OBJ(weakSelf.model.carinfoid, mCARINFOID);
            DEFAULTS_SAVE;
            [weakSelf.tableView reloadData];
        }
        
        
    } failue:^(id data, NSError *error) {
        
    }];
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"车牌号",@"VIN码",@"发动机号",@"车型",@"发动机排量",@"变速箱类型",@"燃油类型",@"当前里程(km)"];
    self.imagelist = @[@"",@"",@"",@"",@"",@"",@"",@""];
}

#pragma mark --设置UI
- (void)initUI{
    [self initTableView];
    [self setSecLeftNavigation];
    [self setSecRightNavigation];
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
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, 80)];
    footView.backgroundColor = [UIColor clearColor];
    
    //按钮
    UIImage *motifyImg = [UIImage imageNamed:@"BaseButton"];
    CGFloat s = (SCREEN_WIDTH-motifyImg.size.width*2)/3;
    
    UIButton *LeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    LeftButton.tag = 105;
    LeftButton.frame = VIEWFRAME(s, 20, motifyImg.size.width, motifyImg.size.height);
    LeftButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    LeftButton.titleLabel.font = SYSTEMFONT(16);
    [LeftButton setTitle:@"切换车辆" forState:UIControlStateNormal];
    [LeftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [LeftButton setBackgroundImage:motifyImg forState:UIControlStateNormal];
    [LeftButton setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
    [LeftButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    RightButton.tag = 106;
    RightButton.frame = VIEWFRAME(SCREEN_WIDTH/2+s/2, 20, motifyImg.size.width, motifyImg.size.height);
    RightButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    RightButton.titleLabel.font = SYSTEMFONT(16);
    [RightButton setTitle:@"添加车辆" forState:UIControlStateNormal];
    [RightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [RightButton setBackgroundImage:motifyImg forState:UIControlStateNormal];
    [RightButton setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
    [RightButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:LeftButton];
    [footView addSubview:RightButton];
    
    self.tableView.tableFooterView = footView;
    
    
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.detailTextLabel.text      = self.imagelist[indexPath.row];
    cell.detailTextLabel.font      = SCREEN_HIGHT > 600? SYSTEMFONT(16) : SYSTEMFONT(14);
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text            = self.titleList[indexPath.row];
    cell.textLabel.font            = SCREEN_HIGHT > 600? SYSTEMFONT(16) : SYSTEMFONT(14);
    cell.textLabel.textColor       = [UIColor whiteColor];
    cell.backgroundColor           = [UIColor clearColor];
    
    if (self.model) {
        switch (indexPath.row) {
            case 0:{
                cell.detailTextLabel.text = self.model.plateNumber;
                break;
            }
            case 1:{
                cell.detailTextLabel.text = self.model.frameNumber;
                break;
            }
            case 2:{
                cell.detailTextLabel.text = self.model.engineCode;
                break;
            }
            case 3:{
                cell.detailTextLabel.text = self.model.model;
                break;
            }
            case 4:{
                cell.detailTextLabel.text = self.model.displacement;
                break;
            }
            case 5:{
                cell.detailTextLabel.text = self.model.gearbox;
                break;
            }
            case 6:{
                cell.detailTextLabel.text = self.model.fuelType;
                break;
            }
            case 7:{
                cell.detailTextLabel.text = self.model.mileage.description;
                break;
            }
            default:
                break;
        }

    }
    
    //背景色和分割线
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = CELL_COLOR_BACKGROUND;
    cell.selectedBackgroundView = back;
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, SCREEN_HIGHT/12-1, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HIGHT/12;
}

#pragma mark --  navigation


- (void)setSecRightNavigation{
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CarInfoRightBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(RightButtonAction)];
    self.navigationItem.rightBarButtonItem = barBtn;
    
}

#pragma mark -- 右上按钮动作
- (void)RightButtonAction{
    NSDictionary *dic = @{@"model" : self.model};
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"MotifyCarInfoVC" object:nil info:dic];
    
}

#pragma mark -- button action

- (void)ButtonClick:(UIButton *)sender{
    if (sender.tag == 105) {
        
        NSDictionary *notify = @{@"cars":self.cars?self.cars:@[]};
        [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ChangeCarVC" object:nil info:notify];
    }else{
        [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"AddCarsVC" object:nil info:nil];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
