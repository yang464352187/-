//
//  MotifyCarInfoVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/23.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "MotifyCarInfoVC.h"
#import "FieldView.h"
#import "CarModel.h"

static NSString * const identifier = @"MyCell";


@interface MotifyCarInfoVC ()<UITableViewDelegate,UITableViewDataSource,FieldViewDelegate>

@property (strong, nonatomic) NSArray *imagelist;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FieldView *plateNumber;
@property (strong, nonatomic) FieldView *vinCode;
@property (strong, nonatomic) FieldView *engineCode;
@property (strong, nonatomic) FieldView *carmodel;
@property (strong, nonatomic) FieldView *displacement;
@property (strong, nonatomic) FieldView *gearbox;
@property (strong, nonatomic) FieldView *fuelType;
@property (strong, nonatomic) FieldView *mileage;
@property (strong, nonatomic) CarModel  *model;

@end

@implementation MotifyCarInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"修改车辆信息";
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"车牌号",@"VIN码",@"发动机号",@"车型",@"发动机排量",@"变速箱类型",@"燃油类型",@"当前里程(km)"];
    self.imagelist = @[@"SetImage1",@"SetImage2",@"LeftSet",@"SetImage4",@"SetImage5",@"SetImage6",@"SetImage7",@""];
    
    self.model = self.notificationDict[@"model"];
    
    //加入通知VIN扫码成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanVINFieldSucceed:) name:@"ADDCAR_VIN" object:nil];
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
    
    UIView *footView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, 80)];
    footView.backgroundColor = [UIColor clearColor];
    
    //按钮
    UIImage *motifyImg = [UIImage imageNamed:@"BaseButton"];
    
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.tag = 105;
    Button.frame = VIEWFRAME(SCREEN_WIDTH/2-motifyImg.size.width/2, 20, motifyImg.size.width, motifyImg.size.height);
    Button.transform = CGAffineTransformMakeScale(0.9, 0.9);
    Button.titleLabel.font = SYSTEMFONT(16);
    [Button setTitle:@"提交" forState:UIControlStateNormal];
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Button setBackgroundImage:motifyImg forState:UIControlStateNormal];
    [Button setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
    [Button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:Button];
    
    self.tableView.tableFooterView = footView;
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.textLabel.text            = self.titleList[indexPath.row];
    cell.textLabel.font            = SCREEN_HIGHT > 600? SYSTEMFONT(16) : SYSTEMFONT(14);
    cell.textLabel.textColor       = [UIColor whiteColor];
    cell.backgroundColor           = [UIColor clearColor];
    
    CGRect frame = VIEWFRAME(130, 5, SCREEN_WIDTH-150, SCREEN_HIGHT/12-10);
    switch (indexPath.row) {
        case 0:{
            self.plateNumber = [[FieldView alloc] initRectWithFrame:frame
                                                         RightImage:nil
                                                        Placeholder:@""
                                                         MoreButton:NO];
            [self.plateNumber setText:self.model.plateNumber];
            [cell addSubview:self.plateNumber];
            break;
        }
        case 1:{
            self.vinCode = [[FieldView alloc] initRectWithFrame:frame
                                                     RightImage:[UIImage imageNamed:@"AddCarsImg_4"]
                                                    Placeholder:@""
                                                     MoreButton:NO];
            [self.vinCode setText:self.model.frameNumber];
            [self.vinCode setKeyboard:UIKeyboardTypeNumberPad];
            self.vinCode.delegate = self;
            [cell addSubview:self.vinCode];
            break;
        }
        case 2:{
            self.engineCode = [[FieldView alloc] initRectWithFrame:frame
                                                        RightImage:nil
                                                       Placeholder:@""
                                                        MoreButton:NO];
            [self.engineCode setText:self.model.engineCode];
            [cell addSubview:self.engineCode];
            break;
        }
        case 3:{
            self.carmodel = [[FieldView alloc] initRectWithFrame:frame
                                                   RightImage:nil
                                                  Placeholder:@""
                                                   MoreButton:NO];
            [self.carmodel setText:self.model.model];
            //self.carmodel.listData = @[@"拖拉机",@"飞机",@"战斗机",@"红杂技",@"娃娃机"];
            self.carmodel.tag = indexPath.row;
            self.carmodel.delegate = self;
            //self.carmodel.viewController = self;
            [cell addSubview:self.carmodel];
            break;
        }
        case 4:{
            self.displacement = [[FieldView alloc] initRectWithFrame:frame
                                                          RightImage:nil
                                                         Placeholder:@""
                                                          MoreButton:YES];
            [self.displacement setText:self.model.displacement];
            self.displacement.listData = @[@"1.0",@"1.5",@"2.0",@"2.5",@"3.0"];
            self.displacement.tag = indexPath.row;
            self.displacement.delegate = self;
            self.displacement.viewController = self;
            [self.displacement setKeyboard:UIKeyboardTypeDecimalPad];
            [cell addSubview:self.displacement];
            break;
        }
        case 5:{
            self.gearbox = [[FieldView alloc] initRectWithFrame:frame
                                                     RightImage:nil
                                                    Placeholder:@""
                                                     MoreButton:YES];
            [self.gearbox setText:self.model.gearbox];
            self.gearbox.listData = @[@"MT手动变速箱",@"AT自动变速箱",@"AMT机械式自动变速箱",@"DCT双离合器变速箱",@"CVT机械式无级变速器"];
            self.gearbox.viewController = self;
            self.gearbox.tag = indexPath.row;
            
            self.gearbox.delegate = self;
            [cell addSubview:self.gearbox];
            break;
        }
        case 6:{
            self.fuelType = [[FieldView alloc] initRectWithFrame:frame
                                                      RightImage:nil
                                                     Placeholder:@""
                                                      MoreButton:YES];
            [self.fuelType setText:self.model.fuelType];
            self.fuelType.listData = @[@"原油",@"挥发油",@"汽油",@"煤油",@"柴油"];
            self.fuelType.tag = indexPath.row;
            self.fuelType.delegate = self;
            self.fuelType.viewController = self;
            [cell addSubview:self.fuelType];
            break;
        }
        case 7:{
            self.mileage = [[FieldView alloc] initRectWithFrame:frame
                                                     RightImage:nil
                                                    Placeholder:@""
                                                     MoreButton:NO];
            [self.mileage setText:self.model.mileage.description];
            [self.mileage setKeyboard:UIKeyboardTypeDecimalPad];
            [cell addSubview:self.mileage];
            break;
        }
        default:
            break;
    }
    
    //背景色和分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, SCREEN_HIGHT/12-1, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HIGHT/12;
}


#pragma mark -- fieldview delegate
- (void)ScanButtonClick:(FieldView *)fieldView{
    NSDictionary *dic = @{@"name" : @"ADDCAR_VIN"};
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ScanVC" object:nil info:dic];
}

#pragma mark -- button action

- (void)ButtonClick:(UIButton *)sender{
    
    if (![self validateEnginCode:self.engineCode.getText]) {
        [MBProgressHUD showHudTipStr:@"请输入正确的发动机号"];
    }else if (self.plateNumber.getText.length == 0) {
        [MBProgressHUD showHudTipStr:@"请输入车牌号"];
    }else if (![self validateCarNo:self.plateNumber.getText]) {
        [MBProgressHUD showHudTipStr:@"请输入正确的车牌号"];
    }else if (self.carmodel.getText.length == 0){
        [MBProgressHUD showHudTipStr:@"请选择车型"];
    }else{
        CarModel *car = [self.model copy];
        car.token = self.currentLoginUser.token;
        car.plateNumber = self.plateNumber.getText;
        car.frameNumber = self.vinCode.getText;
        car.model = self.carmodel.getText;
        car.gearbox = self.gearbox.getText;
        car.fuelType = self.fuelType.getText;
        car.mileage = @(self.mileage.getText.integerValue);
        car.engineCode = self.engineCode.getText;
        car.displacement = [NSString stringWithFormat:@"%.2f",self.displacement.getText.floatValue];
        
        _weekSelf(weakSelf);
        [[NetAPIManager sharedManager] request_SetCar_WithParams:car succesBlack:^(id data) {
            [weakSelf popGoBack];
        } failure:^(id data, NSError *error) {
            
        }];
    }
    
    
}


- (BOOL)validateEnginCode:(NSString *)code{
    if (code.length == 0) {
        return YES;
    }else if(code.length != 8){
        return NO;
    }else{
        NSString *carRegex = @"[A-Z]{1}[A-Z_0-9]{7}";
        NSPredicate *enginTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
        NSLog(@"enginTest is %@",enginTest);
        return [enginTest evaluateWithObject:code];
    }
}

/*车牌号验证 MODIFIED BY HELENSONG*/
- (BOOL) validateCarNo:(NSString *)carNo
{
    carNo = [carNo uppercaseString];
    NSString *head = [carNo substringToIndex:1];
    NSArray *arr = @[ @"京", @"津", @"冀", @"晋", @"辽", @"吉", @"黑",
                      @"沪", @"苏", @"浙", @"皖", @"闽", @"赣", @"鲁", @"豫", @"鄂", @"湘", @"粤", @"桂",
                      @"琼", @"渝", @"川", @"黔", @"滇", @"藏", @"陕", @"甘", @"青", @"宁", @"新", @"港",
                      @"澳", @"蒙" ];
    NSInteger index = [arr indexOfObject:head];
    if (index > 0) {
        NSString *carRegex = @"[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}";
        NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
        NSLog(@"carTest is %@",carTest);
        return [carTest evaluateWithObject:carNo];
    }else{
        return NO;
    }
    
}

- (void)scanVINFieldSucceed:(NSNotification *)notification{
    NSString *str = notification.object;
    [self.vinCode setText:str];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
