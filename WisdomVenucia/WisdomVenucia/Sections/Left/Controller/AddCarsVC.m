//
//  AddCarsVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "AddCarsVC.h"
#import "FieldView.h"
#import "CarModel.h"

@interface AddCarsVC ()<FieldViewDelegate>

@property (strong, nonatomic) FieldView   *brandName;
@property (strong, nonatomic) FieldView   *model;
@property (strong, nonatomic) FieldView   *number;
@property (strong, nonatomic) FieldView   *VINField;
@property (strong, nonatomic) UIButton    *getVINBtn;
@property (strong, nonatomic) FieldView   *DeviceField;
@property (strong, nonatomic) UIButton    *getDeviceBtn;


@end

@implementation AddCarsVC{
    NSInteger _buttontime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加您的车辆";
    [self initUI];
}




- (void)initUI{
    [self initTextFiledAndButton];
    [self setSecLeftNavigation];
}

- (void)initTextFiledAndButton{
    CGFloat h = SCREEN_WIDTH == 320? 40 : 50;
    CGRect frame = VIEWFRAME(0, 64 + 30, 0, h);
    
    frame.origin.x = SCREEN_WIDTH == 320? 40 : 50;
    frame.size.width = SCREEN_WIDTH-2*frame.origin.x;
    //车牌号码
    self.brandName = [[FieldView alloc] initWithFrame:frame
                                                Image:[UIImage imageNamed:@"AddCarsImg_1"]
                                          Placeholder:@"车辆品牌(预留)"];
    //[self.brandName setMoreButton];
    [self.view addSubview:self.brandName];
    
    //星号
    UILabel *label1 = [[UILabel alloc] initWithFrame:VIEWFRAME(frame.origin.x + frame.size.width + 5, frame.origin.y + 1, 10, frame.size.height)];
    label1.textColor = [UIColor redColor];
    label1.text = @"*";
    [self.view addSubview:label1];
    
    //车牌型号框
    frame.origin.y = frame.origin.y + 20 + h;
    self.model = [[FieldView alloc] initWithFrame:frame
                                               Image:[UIImage imageNamed:@"AddCarsImg_2"]
                                         Placeholder:@"车辆型号"];
    //[self.model setMoreButton];
    [self.view addSubview:self.model];
    
    //星号
    UILabel *label2 = [[UILabel alloc] initWithFrame:VIEWFRAME(frame.origin.x + frame.size.width + 5, frame.origin.y + 1, 10, frame.size.height)];
    label2.textColor = [UIColor redColor];
    label2.text = @"*";
    [self.view addSubview:label2];
    
    //车牌
    frame.origin.y = frame.origin.y + 20 + h;
    self.number = [[FieldView alloc] initWithFrame:frame
                                                Image:[UIImage imageNamed:@"AddCarsImg_3"]
                                          Placeholder:@"车牌（例如:闽D12345）"];

    [self.view addSubview:self.number];
    
    //星号
    UILabel *label3 = [[UILabel alloc] initWithFrame:VIEWFRAME(frame.origin.x + frame.size.width + 5, frame.origin.y + 1, 10, frame.size.height)];
    label3.textColor = [UIColor redColor];
    label3.text = @"*";
    [self.view addSubview:label3];
    
    //车架号输入框
    frame.origin.y = frame.origin.y + 20 + h;
    self.VINField = [[FieldView alloc] initWithFrame:frame
                                          RightImage:[UIImage imageNamed:@"AddCarsImg_4"]
                                         Placeholder:@"车架号条形码输入或扫描"];
    self.VINField.delegate = self;
    [self.view addSubview:self.VINField];
    
    
    //设备号输入框
    frame.origin.y = frame.origin.y + 20 + h;
    
    
    self.DeviceField = [[FieldView alloc] initWithFrame:frame
                                          RightImage:[UIImage imageNamed:@"AddCarsImg_5"]
                                         Placeholder:@"设备号条形码输入或扫描"];
    self.DeviceField.delegate = self;
    [self.view addSubview:self.DeviceField];
    
    
    //
    CGFloat s = SCREEN_HIGHT == 480 ? 0 : 45;
    CGFloat b_y = frame.origin.y + 40 + s;
    UIImage *registerImg = [UIImage imageNamed:@"RegisterButton"];
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame = VIEWFRAME(SCREEN_WIDTH/2-registerImg.size.width/2, b_y, registerImg.size.width, registerImg.size.height);
    CGFloat ttt = SCREEN_HIGHT == 480? 0.8:1.0;
    Button.transform = CGAffineTransformMakeScale(ttt, ttt);
    [Button setImage:registerImg selecetImage:[UIImage imageNamed:@"RegisterButton_Sel"] withTitle:nil];
    [Button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ViewBorderRadius(Button, registerImg.size.width/2, 2, [UIColor whiteColor]);
    [self.view addSubview:Button];
    
    //扫码通知
    [self addNotifycation];
    
#if DEBUG
    [self.brandName setText:@"1231"];
    [self.model setText:@"123123"];
    [self.number setText:@"闽D12345"];
    [self.VINField setText:@"12312312312312312"];
    [self.DeviceField setText:@"123123123"];
#endif
    
}


- (void)addNotifycation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanVINFieldSucceed:) name:@"ADDCAR_VIN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanDeviceFieldSucceed:) name:@"ADDCAR_DEVICE" object:nil];
}

- (void)ButtonClick:(UIButton *)sender{
//    if ([[self.brandName getText] length] == 0) {
//        [MBProgressHUD showHudTipStr:@"请输入车辆品牌"];
//    }else if ([[self.model getText] length] == 0) {
//        [MBProgressHUD showHudTipStr:@"请输入车辆型号"];
//    }else if ([[self.number getText] length] == 0) {
//        [MBProgressHUD showHudTipStr:@"请输入车牌号码"];
//    }else if ([[self.VINField getText] length] == 0) {
//        [MBProgressHUD showHudTipStr:@"请输入车架号"];
//    }else if ([[self.DeviceField getText] length] == 0) {
//        [MBProgressHUD showHudTipStr:@"请输入设备号"];
//    }else if ([[self.VINField getText] length] != 17) {
//        [MBProgressHUD showHudTipStr:@"请输入正确的车架号"];
//    }else{
//        [self addcar];
//    }
    
    
    if ([[self.brandName getText] length] == 0) {
        [MBProgressHUD showHudTipStr:@"请输入车辆品牌"];
    }else if ([[self.model getText] length] == 0) {
        [MBProgressHUD showHudTipStr:@"请输入车辆型号"];
    }else if ([[self.number getText] length] == 0) {
        [MBProgressHUD showHudTipStr:@"请输入车牌号码"];
    }else if (![self validateCarNo:[self.number getText]]) {
        [MBProgressHUD showHudTipStr:@"请输入正确的车牌号码"];
    }else{
        [self addcar];
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

- (void)addcar{
    CarModel *model = [[CarModel alloc] init];
    model.token = self.currentLoginUser.token;
    model.model = [self.brandName getText];
    model.modelNumber = [self.model getText];
    model.frameNumber = [self.VINField getText];
    model.deviceNumer = [self.DeviceField getText];
    model.plateNumber = [[self.number getText] uppercaseString];
    _weekSelf(weakSelf);
    [SVProgressHUD show];
    [[NetAPIManager sharedManager] request_SetCar_WithParams:model succesBlack:^(id data) {
        [SVProgressHUD dismiss];
        if (weakSelf.notificationDict[@"type"]) {
            [[RootViewController sharedRootVC] ChangeRootVC];
            [MBProgressHUD showHudTipStr:@"添加成功"];
        } else {
            [weakSelf popGoBack];
        }
        
    } failure:^(id data, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

- (void)ScanButtonClick:(FieldView *)fieldView{
    NSDictionary *dic = nil;
    if (fieldView == self.VINField) {
        dic = @{@"name" : @"ADDCAR_VIN"};
    }else{
        dic = @{@"name" : @"ADDCAR_DEVICE"};
    }
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ScanVC" object:nil info:dic];
    
}


- (void)scanVINFieldSucceed:(NSNotification *)notification{
    NSString *str = notification.object;
    [self.VINField setText:str];
}

- (void)scanDeviceFieldSucceed:(NSNotification *)notification{
    NSString *str = notification.object;
    [self.DeviceField setText:str];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
