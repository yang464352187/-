//
//  ChangeCarVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "ChangeCarVC.h"
#import "ChangeCarCell.h"
#import "CarModel.h"

static NSString * const identifier = @"ChangeCarCell";

@interface ChangeCarVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (weak, nonatomic  ) ChangeCarCell  *selectedCell;
@property (strong, nonatomic) UIImage        *selected;
@property (strong, nonatomic) UIImage        *unselected;
@property (strong, nonatomic) NSArray        *titleList;
@property (strong, nonatomic) UITableView    *tableView;

@end

@implementation ChangeCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"车辆切换";
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = self.notificationDict[@"cars"];
    if (self.titleList.count) {
        self.selectedArray = [[NSMutableArray alloc] init];
        NSNumber *carID = DEFAULTS_GET_OBJ(mCARINFOID);
        for (int i = 0; i < self.titleList.count; i++) {
            CarModel *model = self.titleList[i];
            
            BOOL bo = NO;
            if ([model.carinfoid isEqualToNumber:carID]) {
                bo = YES;
            }
            [self.selectedArray addObject:@(bo)];
        }
    }
    
}

#pragma mark --设置UI
- (void)initUI{
    [self initImageView];
    [self initTableView];
    [self setSecLeftNavigation];
}
- (void)initImageView{
    self.selected = [UIImage imageNamed:@"ChangeCar_Sel"];

    self.unselected = [UIImage imageNamed:@"ChangeCar"];
}

#pragma mark --设置表视图
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, SCREEN_HIGHT-64-100)];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.allowsSelection = NO;
    //self.tableView.scrollEnabled   = NO;
    [self.tableView registerClass:[ChangeCarCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
    

    
    UIImage *motifyImg = [UIImage imageNamed:@"BaseButton"];
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame = VIEWFRAME(SCREEN_WIDTH/2-motifyImg.size.width/2, SCREEN_HIGHT-100, motifyImg.size.width, motifyImg.size.height);
    Button.transform = CGAffineTransformMakeScale(0.9, 0.9);
    Button.titleLabel.font = SYSTEMFONT(16);
    [Button setTitle:@"确定" forState:UIControlStateNormal];
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Button setBackgroundImage:motifyImg forState:UIControlStateNormal];
    [Button setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
    [Button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Button];

}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    CarModel *model = self.titleList[indexPath.row];
    cell.titleLabel.text           = model.plateNumber;
    if ([self.selectedArray[indexPath.row] boolValue]) {
        cell.selectImage.image     =  self.selected;
    }else{
        cell.selectImage.image     =  self.unselected;
    }
    
    cell.backgroundColor           = [UIColor clearColor];
    cell.selectionStyle            = UITableViewCellSelectionStyleNone;
    //背景色和分割线
//    UIView *back = [[UIView alloc] init];
//    back.backgroundColor = CELL_COLOR_BACKGROUND;
//    cell.selectedBackgroundView = back;
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, 59, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL bool_sel =[self.selectedArray[indexPath.row] boolValue];
    
    if (!bool_sel) {
        for (int i = 0; i<self.selectedArray.count; i++) {
            if ([self.selectedArray[i] boolValue]) {
                [self.selectedArray replaceObjectAtIndex:i withObject:@(bool_sel)];
                break;
            }
        }
        bool_sel = YES;
        [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:@(bool_sel)];
        [self.tableView reloadData];
    }
}

#pragma mark -- button action

- (void)ButtonClick:(UIButton *)sender{
    if (self.titleList.count==0) {
        [self popGoBack];
        return;
    }
    
    for (int i = 0; i<self.selectedArray.count; i++) {
        if ([self.selectedArray[i] boolValue]) {
            CarModel *model = self.titleList[i];
            DEFAULTS_SET_OBJ(model.carinfoid, mCARINFOID);
            DEFAULTS_SAVE;
            break;
        }
    }
    [self popGoBack];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
