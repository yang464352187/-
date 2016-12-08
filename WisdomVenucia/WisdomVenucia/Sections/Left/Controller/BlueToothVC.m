//
//  BlueToothVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/21.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BlueToothVC.h"
#import "BlueToothCell.h"
#import "BTManager.h"
#import <CoreBluetooth/CoreBluetooth.h>



static NSString *cellIdentifier = @"cellIdentifier";

@interface BlueToothVC () <UITableViewDataSource, UITableViewDelegate,BTManagerDelegate>

@property (strong, nonatomic) UILabel   *label;
@property (strong, nonatomic) UISwitch  *switchControl;
@property (strong, nonatomic) NSString  *PeripheralName;
@property (strong, nonatomic) BTManager *btManager;
@property (strong, nonatomic) UIActivityIndicatorView *activity;

@end

@implementation BlueToothVC
{
    UITableView *_tableView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蓝牙连接";
    [self initData];
    [self initUI];
}

- (void)initData{
    self.btManager          = [BTManager sharedManager];
    [self.btManager initCBCentralManager];
    self.btManager.delegate = self;
}


- (void)initUI{
    [self initTableView];
    [self setSecLeftNavigation];
    
    //蓝牙连接成功标签
    self.label = [[UILabel alloc] initWithFrame:VIEWFRAME(30, 64+15, SCREEN_WIDTH-60, 30)];
    self.label.textColor = [UIColor whiteColor];
    
    
    if (self.btManager.currentPeripheral) {
        NSString *name = self.btManager.currentPeripheral.name.length == 0? @"未知":self.btManager.currentPeripheral.name;
        
        self.label.text = [NSString stringWithFormat:@"已连接设备：%@",name];
    }else{
        self.label.text = @"已连接设备：无";
    }
    self.label.font = CELL_BASE_FONT;
    [self.view addSubview:self.label];
    
    //蓝牙自动连接标签
    UILabel *label1  = [[UILabel alloc] initWithFrame:VIEWFRAME(30, 64+55, 100, 30)];
    label1.textColor = [UIColor whiteColor];
    label1.text      = @"蓝牙自动连接";
    label1.font      = CELL_BASE_FONT;
    [self.view addSubview:label1];
    
    //蓝牙开关
    self.switchControl                 = [[UISwitch alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-80, 64+55, 30, 20)];
    self.switchControl.transform       = CGAffineTransformMakeScale(0.9, 0.9);
    ViewRadius(self.switchControl, 15.5);
    self.switchControl.thumbTintColor  = [UIColor whiteColor];
    //self.switchControl.tintColor = APP_COLOR_SWITCH_GRAY;
    self.switchControl.backgroundColor = APP_COLOR_SWITCH_GRAY;
    [self.switchControl setOn:DEFAULTS_GET_BOOL(mBTAUTOCONNECT)];
    [self.switchControl addTarget:self action:@selector(openBlueTooth:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.switchControl];
    
    
    //蓝牙设备搜索标签
    UILabel *label2 = [[UILabel alloc] initWithFrame:VIEWFRAME(30, 64+95, 100, 30)];
    label2.textColor = [UIColor whiteColor];
    label2.text = @"蓝牙设备搜索";
    label2.font = CELL_BASE_FONT;
    [self.view addSubview:label2];
    
    //搜索按钮
    UIImage *image = [UIImage imageNamed:@"BlueToothLogo"];
    UIButton *button = [[UIButton alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-image.size.width-70, 64+110-image.size.height, image.size.width*4, image.size.height*2)];
    
    [button addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activity.hidesWhenStopped = YES;
    self.activity.frame = VIEWFRAME(SCREEN_WIDTH/2, 64+110-image.size.height, image.size.width*2, image.size.height*2);
    self.activity.center = CGPointMake(SCREEN_WIDTH/2, button.center.y);
    [self.activity stopAnimating];
    [self.view addSubview:self.activity];
    //虚线
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,64+135, SCREEN_WIDTH, 1)];
    [self.view addSubview:imageView1];
    
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[] = {3,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 1.0);    //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH, 1.0);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();

}

#pragma mark -- 打开蓝牙自动连接
- (void)openBlueTooth:(id *)sender{
    DEFAULTS_SET_BOOL([self.switchControl isOn], mBTAUTOCONNECT);
    DEFAULTS_SAVE;
}


#pragma mark -- 搜索动作
- (void)searchButtonClick:(UIButton *)sender{
    self.label.text = @"已连接设备：无";
    [self.activity startAnimating];
    [self.btManager initCBCentralManager];
    [self.btManager SearchPeripheral];
    
}


#pragma mark - InitTableView
- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64+136, SCREEN_WIDTH, SCREEN_HIGHT-150-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[BlueToothCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];
}





#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.btManager.peripheralArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([(CBPeripheral *)self.btManager.peripheralArray[indexPath.row] name] == nil) {
        cell.name.text = @"未知";
    } else {
        cell.name.text = [(CBPeripheral *)self.btManager.peripheralArray[indexPath.row] name];
    }
    CBPeripheralState state = [(CBPeripheral *)self.btManager.peripheralArray[indexPath.row] state];
    if (state ==  CBPeripheralStateConnecting) {
        cell.state.text = @"连接中";
        [cell setImageAndFrame:[UIImage imageNamed:@"BlueToothUnconnect"]];
    }else if (state == CBPeripheralStateConnected){
        cell.state.text = @"已连接";
        [cell setImageAndFrame:[UIImage imageNamed:@"BlueToothConnect"]];
    }else{
        cell.state.text = @"未连接";
        [cell setImageAndFrame:[UIImage imageNamed:@"BlueToothUnconnect"]];
    }
    
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = CELL_COLOR_BACKGROUND;
    cell.selectedBackgroundView = back;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[SVProgressHUD show];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.btManager ConnectPeripheral:indexPath.row];
}

#pragma mark -- btmanager delegate

- (void)updateperipheralArray:(NSMutableArray *)array{
    [_tableView reloadData];
}

- (void)ConnectSucceed{
    NSString *name = self.btManager.currentPeripheral.name.length == 0? @"未知":self.btManager.currentPeripheral.name;
    self.label.text = [NSString stringWithFormat:@"已连接设备：%@",name];
    [self.activity stopAnimating];
    [_tableView reloadData];
}

- (void)disConnect{
    self.label.text = [NSString stringWithFormat:@"已连接设备：无"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
