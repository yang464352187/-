//
//  TyreStateVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/19.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "TyreStateVC.h"
#import "BTManager.h"
#import "TyreStateView.h"

@interface TyreStateVC ()<BTManagerDelegate>

@property (strong, nonatomic) TyreStateView  *tyre1;
@property (strong, nonatomic) TyreStateView  *tyre2;
@property (strong, nonatomic) TyreStateView  *tyre3;
@property (strong, nonatomic) TyreStateView  *tyre4;

@property (strong, nonatomic) UIImageView    *StateImage;
@property (strong, nonatomic) BTManager      *btmanager;
@property (strong, nonatomic) NSMutableArray *dataArray;
//@property (strong, nonatomic) NSData         *firstData;
@property (strong, nonatomic) NSData         *lastData;
@property (strong, nonatomic) NSMutableData  *firstData;

@end

@implementation TyreStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"胎压状态";
}

#pragma mark -- 初始化数据
- (void)initData{
    
    self.btmanager          = [BTManager sharedManager];
    self.btmanager.delegate = self;
    
    self.dataArray          = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}


- (void)getData{
    Byte d[] ={ 0X5A, 0xA5,0x05,0x04,0x01,0x00,0xFF,0x05};
    NSData *data = [NSData dataWithBytes:&d length:sizeof(d)];
    [self.btmanager writeDataToPeripheral:data];
}


- (void)initUI{
    [self initImage];
    [self setSecLeftNavigation];
    [self setSecRightNavigation];
}


- (void)initImage{
    CGFloat t = SCREEN_HIGHT == 480 ? 0.6 : SCREEN_HIGHT == 568?  0.7 : 1;
    UIImage *state_Img = [UIImage imageNamed:@"TyreState0000"];
    self.StateImage = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-state_Img.size.width/2, SCREEN_HIGHT/2-state_Img.size.height/2+15, state_Img.size.width, state_Img.size.height)];
    self.StateImage.image = state_Img;
    self.StateImage.transform = CGAffineTransformMakeScale(t, t);
    [self.view addSubview:self.StateImage];
    
    CGFloat w = (SCREEN_WIDTH-40)/2;
    CGFloat h = w*1.09;
    
    self.tyre1 = [[TyreStateView alloc] initWithFrame:VIEWFRAME(10, 64 + 20, w, h)
                                                State:0.0
                                          Temperature:0
                                                Title:@"右前轮"
                                                place:1];
    [self.view addSubview:self.tyre1];
    
    self.tyre2 = [[TyreStateView alloc] initWithFrame:VIEWFRAME(10, SCREEN_HIGHT-60-h, w, h)
                                                State:0.0
                                          Temperature:0
                                                Title:@"左前轮"
                                                place:1];
    [self.view addSubview:self.tyre2];
    
    self.tyre3 = [[TyreStateView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2 + 10, 64 + 20, w, h)
                                                State:0.0
                                          Temperature:0
                                                Title:@"右后轮"
                                                place:2];
    [self.view addSubview:self.tyre3];
    
    self.tyre4 = [[TyreStateView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2+10, SCREEN_HIGHT-60-h, w, h)
                                                State:0.0
                                          Temperature:0
                                                Title:@"左后轮"
                                                place:2];
    [self.view addSubview:self.tyre4];
    
    
    //提示
    
    UIImage *image = [UIImage imageNamed:@"PassWordWarn"];
    UIImageView *warn = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/4-image.size.width-20, SCREEN_HIGHT-30, image.size.width, image.size.height)];
    warn.image = image;
    [self.view addSubview:warn];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/4-10, SCREEN_HIGHT-30, 260, image.size.height)];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor yellowColor];
    label1.text = @"温馨提示 : 红色轮胎代表异常,请联系厂家";
    label1.font = SYSTEMFONT(12);
    [self.view addSubview:label1];
    
}

- (void)setSecRightNavigation{

    UIBarButtonItem *barbtn =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TyreSet"] style:UIBarButtonItemStylePlain target:self action:@selector(RightButtonAction)];
    self.navigationItem.rightBarButtonItem = barbtn;
    
}

#pragma mark -- 右按钮动作
- (void)RightButtonAction{
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"TyreStateSetVC" object:nil info:nil];
}


//#pragma mark -- btmanager delegate
//- (void)updateValue:(NSData *)data{
//    if (self.dataArray.count == 0) {
//        [self.dataArray addObject:[data copy]];
//        NSMutableData *m_data = [NSMutableData dataWithData:data];
//        [self analyseData:m_data];
//    }else if(self.dataArray.count >= 1){
//        NSInteger num = self.dataArray.count;
//        NSData *firstdata = [self.dataArray[num-1] copy];
//        NSMutableData *m_data = [NSMutableData dataWithData:firstdata];
//        [m_data appendData:[data copy]];
//        [self analyseData:m_data];
//        [self.dataArray addObject:[data copy]];
//    }
//}


//#pragma mark -- btmanager delegate
//- (void)updateValue:(NSData *)data{
//    if (!self.firstData) {
//        NSMutableData *m_data = [NSMutableData dataWithData:data];
//        [self analyseData:m_data];
//        self.firstData = [data copy];
//    }else{
//        
//        NSMutableData *m_data = [NSMutableData dataWithData:[self.firstData copy]];
//        [m_data appendData:[data copy]];
//        [self analyseData:m_data];
//        self.firstData = data;
//    }
//}

#pragma mark -- btmanager delegate
- (void)updateValue:(NSData *)data{
    
    if (self.firstData.length > 40) {
        self.firstData = [[self.firstData subdataWithRange:NSMakeRange(25, self.firstData.length-25)] mutableCopy];
    }
    
    if (!self.firstData) {
        //        NSMutableData *m_data = [data mutableCopy];
        //        [self analyseData:m_data];
        self.firstData = [data mutableCopy];
        [self analyseData:self.firstData];
    }else{
        [self.firstData appendData:data];
        //NSMutableData *m_data = [self.firstData mutableCopy];
        [self analyseData:self.firstData];
    }
    
}



#pragma mark -- 分析数据
- (void)analyseData:(NSMutableData *)data{
    Byte *a = (Byte *)[data bytes];
    if (data.length > 14) {
        for (int i = 0; i<data.length-14; i++) {
            if ([self isCorrectData:a index:i length:data.length]) {
                //NSLog(@"firstData %@",self.firstData);
                NSData *now = [data subdataWithRange:NSMakeRange(i, 15)];
                if (self.lastData && [now isEqualToData:self.lastData]) {
                    
                }else{
                    [self handleData:a index:i];
                    self.lastData = [data subdataWithRange:NSMakeRange(i, 15)];
                }
                self.firstData = [[data subdataWithRange:NSMakeRange(i+15, data.length-i-15)] mutableCopy];
                break;
            }
        }
    }
}

/**
 *
 *
 *  @gram data    byte数组
 *  @gram index   位置
 *  @gram length  长度
 **/
- (BOOL)isCorrectData:(Byte *)a index:(NSInteger)i length:(NSInteger)length{
    if (a[i]== 0x5a && a[i+1]==0xa5 &&a[i+2]==0x0c && (a[i+3]==0x04 || a[i+3]==0x44) &&(a[i+4]==0x01 || a[i+4]==0x00) && (length-i)>=15) {
        return YES;
    }
    return NO;
}

#pragma mark -- 处理数据
- (void)handleData:(Byte *)a index:(NSInteger)i{
    Byte check = (a[i+3]+ a[i+4]+a[i+5]+a[i+6]+a[i+7]+ a[i+8]+a[i+9]+a[i+10]+a[i+11]+ a[i+12]+a[i+13])%255;
    if (check == a[i+14]) {
        if (a[i+5] == 0x21) {
            //温度
            NSInteger tem3 = a[i+6] - 50;
            [self.tyre3 setTemperatureText:tem3];
            
            NSInteger tem4 = a[i+7] - 50;
            [self.tyre4 setTemperatureText:tem4];
            NSInteger tem1 = a[i+8] - 50;
            [self.tyre1 setTemperatureText:tem1];
            NSInteger tem2 = a[i+9] - 50;
            [self.tyre2 setTemperatureText:tem2];
            [self setCarImage];
            
        }else if (a[i+5] == 0x22){
            //压力
            CGFloat state3 = a[i+6]+(a[i+7]/10.0);
            [self.tyre3 setStateText:state3];
            
            CGFloat state4 = a[i+8]+(a[i+9]/10.0);
            [self.tyre4 setStateText:state4];
            
            CGFloat state1 = a[i+10]+(a[i+11]/10.0);
            [self.tyre1 setStateText:state1];
            
            CGFloat state2 = a[i+12]+(a[i+13]/10.0);
            [self.tyre2 setStateText:state2];
            [self setCarImage];
        }
        
        
    }
}

- (void)setCarImage{
    NSInteger up1  = self.tyre1.isnormal? 0 : 1;
    NSInteger up2  = self.tyre3.isnormal? 0 : 1;
    NSInteger down1 = self.tyre2.isnormal? 0 : 1;
    NSInteger down2 = self.tyre4.isnormal? 0 : 1;
    NSString *imageName = [NSString stringWithFormat:@"TyreState%li%li%li%li",(long)up1,(long)up2,(long)down1,(long)down2];
    
    self.StateImage.image = [UIImage imageNamed:imageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
