//
//  CarConditionVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/18.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "CarConditionVC.h"
#import "BTManager.h"

@interface CarConditionVC ()<BTManagerDelegate>

@property (strong, nonatomic) UIImageView    *imageView1;
@property (strong, nonatomic) UIImageView    *imageView2;
@property (strong, nonatomic) UIImageView    *imageView3;
@property (strong, nonatomic) BTManager      *btmanager;
@property (strong, nonatomic) NSMutableArray *dataArray;
//@property (strong, nonatomic) NSData         *firstData;
@property (strong, nonatomic) NSData         *lastData;
@property (strong, nonatomic) NSMutableData  *firstData;

@end

@implementation CarConditionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"车况查询";
}

#pragma mark -- 初始化数据
- (void)initData{
    
    self.btmanager          = [BTManager sharedManager];
    
    
    self.dataArray          = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.btmanager.delegate = self;
    [self getData];
}
- (void)getData{
    Byte d[] ={ 0X5A, 0xA5,0x05,0x02,0x01,0x00,0xFF,0x03};
    NSData *data = [NSData dataWithBytes:&d length:sizeof(d)];
    [self.btmanager writeDataToPeripheral:data];
}

- (void)initUI{
    [self setSecLeftNavigation];
    [self setRightNavigation];
    [self initImage];
    [self initButton];
    
}

- (void)initImage{
//    CGFloat h = SCREEN_HIGHT == 480? SCREEN_WIDTH*7/12+40 : SCREEN_WIDTH*7/12+60;
//    UIImageView *carBackground = [[UIImageView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, h)];
//    carBackground.image = [UIImage imageNamed:@"CarBackground"];
//    [self.view addSubview:carBackground];
    
    CGFloat w = SCREEN_WIDTH/2 - 40;
    //圆盘
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:VIEWFRAME(20,64+20, w, w)];
    imageview1.image = [UIImage imageNamed:@"CarImage1"];
    
    //指针
    UIImageView *Car1_indicator = [[UIImageView alloc] initWithFrame:imageview1.frame];
    Car1_indicator.image = [UIImage imageNamed:@"Car1_indicator"];
    Car1_indicator.transform = CGAffineTransformMakeRotation(M_PI * -0.65);
    self.imageView1 = Car1_indicator;
    //圆盘
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2+20,64+20,w,w)];
    imageview2.image = [UIImage imageNamed:@"CarImage2"];
    //指针
    UIImageView *Car2_indicator = [[UIImageView alloc] initWithFrame:imageview2.frame];
    Car2_indicator.image = [UIImage imageNamed:@"Car2_indicator"];
    Car2_indicator.transform = CGAffineTransformMakeRotation(M_PI * -0.75);
    self.imageView2 = Car2_indicator;
    
    //圆盘
    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH*3/8-5,64+20+SCREEN_WIDTH/3+5,SCREEN_WIDTH/4+10,SCREEN_WIDTH/4+10)];
    imageview3.image = [UIImage imageNamed:@"CarImage3"];
    //指针
    UIImageView *Car3_indicator = [[UIImageView alloc] initWithFrame:imageview3.frame];
    Car3_indicator.image = [UIImage imageNamed:@"Car3_indicator"];
    Car3_indicator.transform = CGAffineTransformMakeRotation(M_PI * -0.4);
    self.imageView3 = Car3_indicator;
    
    [self.view addSubview:imageview1];
    [self.view addSubview:imageview2];
    [self.view addSubview:imageview3];
    [self.view addSubview:Car1_indicator];
    [self.view addSubview:Car2_indicator];
    [self.view addSubview:Car3_indicator];
}

- (void)initButton{
    CGFloat w = SCREEN_WIDTH/16;//间隔
    CGFloat Btn_h = SCREEN_WIDTH*1.36/4 + 50;//按钮高度
    CGFloat h = SCREEN_HIGHT -  SCREEN_WIDTH*7/12 - 104 - 30 - Btn_h;//按钮屏幕高度间隔
    h = h>0? h : 0;
    
    UIButton *carCondition = [self createDateButtonWithFrame:VIEWFRAME(w, SCREEN_WIDTH*7/12+104 + h/2, SCREEN_WIDTH/4, Btn_h) Title:@"车况" setImage:[UIImage imageNamed:@"CarImage4"]];
    [carCondition addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    carCondition.tag = 1;
    [self.view addSubview:carCondition];
    
    UIButton *CenterBtn = [self createDateButtonWithFrame:VIEWFRAME(w*2+SCREEN_WIDTH/4, SCREEN_WIDTH*7/12+104 + h/2, SCREEN_WIDTH/4, Btn_h) Title:@"胎压" setImage:[UIImage imageNamed:@"CarImage5"]];
    [CenterBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    CenterBtn.tag = 2;
   [self.view addSubview:CenterBtn];
    
    UIButton *moreButton = [self createDateButtonWithFrame:VIEWFRAME(w*3+SCREEN_WIDTH/2, SCREEN_WIDTH*7/12+104 + h/2, SCREEN_WIDTH/4, Btn_h) Title:@"更多" setImage:[UIImage imageNamed:@"CarImage6"]];
    moreButton.tag = 3;
    [moreButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreButton];
}

#pragma  mark -- 三个按钮动作
- (void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 1:{
            //车况
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"DoorConditionVC" object:nil info:nil];
            break;
        }
        case 2:{
            //胎压
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"TyreStateVC" object:nil info:nil];
            break;
        }
        case 3:{
            //更多
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"CarConditionMoreVC" object:nil info:nil];
            break;
        }
        default:
            break;
    }
}


#pragma mark -- right Button
- (void)setRightNavigation{
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(RightbarbuttonAction)];
    self.navigationItem.rightBarButtonItem = bar;
    
    
    
}

- (void)RightbarbuttonAction{
    [self getData];
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
//    
//}

//#pragma mark -- btmanager delegate
//- (void)updateValue:(NSData *)data{
//    if (!self.firstData) {
//        
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
    if (a[i]== 0x5a && a[i+1]==0xa5 &&a[i+2]==0x0c && (a[i+3]==0x02 || a[i+3]==0x42) &&(a[i+4]==0x01 || a[i+4]==0x00) &&a[i+5]==0x42 && (length-i)>=15) {
        return YES;
    }
    return NO;
}

#pragma mark -- 处理数据
- (void)handleData:(Byte *)a index:(NSInteger)i{
    Byte check = (a[i+3]+ a[i+4]+a[i+5]+a[i+6]+a[i+7]+ a[i+8]+a[i+9]+a[i+10]+a[i+11]+ a[i+12]+a[i+13])%255;
    if (check == a[i+14]) {
        //转速
        CGFloat inter1 = (a[i+6]*16*16 + a[i+7])/1000.0;
        if (inter1 <= 9.0) {
            inter1 = inter1*1.3/9.0-0.65;
            self.imageView1.transform = CGAffineTransformMakeRotation(M_PI * inter1);
        }else{
            self.imageView1.transform = CGAffineTransformMakeRotation(M_PI * 0.65);
        }
        //车速
        
        CGFloat inter2 = a[i+10]+ ((CGFloat)a[i+11]/10.0);
        if (inter2 <= 210.0) {
            inter2 = inter2/210.0*1.5-0.75;
            self.imageView2.transform = CGAffineTransformMakeRotation(M_PI * inter2);
        }else{
            self.imageView2.transform = CGAffineTransformMakeRotation(M_PI * 0.75);
        }
        //油量
        CGFloat inter3 = a[i+12]/100.0;
        inter3 = inter3 * 0.8 - 0.4;
        self.imageView3.transform = CGAffineTransformMakeRotation(M_PI * inter3);
    }
}

#pragma mark - 创建图文混排按钮

- (UIButton *)createDateButtonWithFrame:(CGRect)frame Title:(NSString *)title setImage:(UIImage *)image{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    [button.imageView setContentMode:UIViewContentModeCenter];
    [button setImageEdgeInsets:UIEdgeInsetsMake(titleSize.height +10,
                                                0.0,
                                                0.0,
                                                -frame.size.width / image.size.width)];
    [button setImage:image forState:UIControlStateNormal];
    [button setContentMode:UIViewContentModeTop];
    CGFloat s = SCREEN_HIGHT == 480 ? 10 : 30;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(-frame.size.width*1.36-s,
                                                -image.size.width,
                                                0.0,
                                                0.0)];
    
    
    [button setImage:image forState:UIControlStateNormal];
    
    [button.titleLabel setBackgroundColor:[UIColor clearColor] ];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0] ];
    [button setTitle:title forState:UIControlStateNormal];
    
    float sw = frame.size.width / image.size.width;
    float sh = frame.size.width*1.36 / image.size.height;
    button.imageView.transform = CGAffineTransformMakeScale(sw,sh);
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
