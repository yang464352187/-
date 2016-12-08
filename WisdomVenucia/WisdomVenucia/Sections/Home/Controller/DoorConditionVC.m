//
//  DoorConditionVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/23.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "DoorConditionVC.h"
#import "BTManager.h"

@interface DoorConditionVC ()<UIScrollViewDelegate,BTManagerDelegate>

@property (strong, nonatomic) UIImageView    *pageLeft;
@property (strong, nonatomic) UIImageView    *pageRight;
@property (strong, nonatomic) UIImage        *pageN;
@property (strong, nonatomic) UIImage        *pageU;
@property (strong, nonatomic) NSArray        *stateList;
@property (strong, nonatomic) NSArray        *titleList;
@property (strong, nonatomic) UIScrollView   *scrollView;
@property (strong, nonatomic) UIImageView    *imageView;
@property (strong, nonatomic) BTManager      *btmanager;
@property (strong, nonatomic) NSMutableArray *buttonArray;

//@property (strong, nonatomic) NSData         *firstData;


@property (strong, nonatomic) NSData         *lastData;
@property (strong, nonatomic) NSMutableData  *firstData;
@property (strong, nonatomic) NSData         *corretData;
@property (strong, nonatomic) NSData         *corretData2;
@property (strong, nonatomic) NSTimer        *timer;

@end

@implementation DoorConditionVC{
    NSInteger FirstIndexOK ,indexOK,FirstIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车况查询";
    [self initData];
    [self initUI];
}
#pragma mark -- 初始化数据
- (void)initData{
    
    self.btmanager          = [BTManager sharedManager];
    //self.btmanager.delegate = self;
    
    self.buttonArray        = [[NSMutableArray alloc] init];
    
    self.titleList = @[@"驾驶门",@"副驾驶门",@"后舱盖",@"左后门",@"右后门",@"天窗",@"左前车窗",@"右前车窗",@"近光灯",@"左车后窗",@"右车后窗",@"空调"];
    //假 数据
    self.stateList = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
    
    FirstIndexOK = indexOK = FirstIndex = 0;
    Byte a[] = { 0X5A, 0xA5,0x0C,0x03};
    Byte b[] = { 0X5A, 0xA5,0x0C,0x43};
    self.corretData = [NSData dataWithBytes:&a length:sizeof(a)];
    self.corretData2 = [NSData dataWithBytes:&b length:sizeof(b)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.btmanager.delegate = self;
    [self getData];
}

- (void)getData{
    Byte d[] ={ 0X5A, 0xA5,0x05,0x03,0x01,0x00,0xFF,0x04};
    NSData *data = [NSData dataWithBytes:&d length:sizeof(d)];
    [self.btmanager writeDataToPeripheral:data];
}
#pragma mark -- 设置UI
- (void)initUI{
    [self InitImageView];
    [self initScrollView];
    //[self setNavgationBarLeftItemWithImage:[UIImage imageNamed:@"NavigationLeft"]];
    [self setSecLeftNavigation];
    [self setRightNavigation];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.002f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}


#pragma mark -- 设置image视图
- (void)InitImageView{
    CGFloat w = SCREEN_HIGHT/3/1.6;
    CGFloat t = SCREEN_WIDTH/28;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-w/2, 64+t, w, SCREEN_HIGHT/3)];
    
    imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    NSInteger isLeft1  = [self.stateList[0] integerValue];
    NSInteger isLeft2  = [self.stateList[3] integerValue];
    NSInteger isRight1 = [self.stateList[1] integerValue];
    NSInteger isRight2 = [self.stateList[4] integerValue];
    NSString *imageName = [NSString stringWithFormat:@"DoorCondition%li%li%li%li",(long)isLeft1,(long)isLeft2,(long)isRight1,(long)isRight2];
    
    imageView.image = [UIImage imageNamed:imageName];
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

#pragma mark -- 设置滚动视图
- (void)initScrollView{
    CGFloat h = SCREEN_WIDTH == 320 ?  SCREEN_HIGHT*2/3-64-40 :  SCREEN_HIGHT*2/3-64-80;
    self.scrollView = [[UIScrollView alloc] initWithFrame:VIEWFRAME(0, 64 + SCREEN_HIGHT/3, SCREEN_WIDTH, h)];
    self.scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH*2, 0);
    self.scrollView.pagingEnabled                  = YES;
    self.scrollView.delegate                       = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    self.scrollView.backgroundColor                = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    [self initButtonView];
}
#pragma mark -- 创建8个图文按钮
- (void)initButtonView{
    CGFloat h = ViewHeight(self.scrollView);
    UIView *view1 = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, h)];
    UIView *view2 = [[UIView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH, 0, SCREEN_WIDTH, h)];
    view1.backgroundColor = [UIColor clearColor];
    view2.backgroundColor = [UIColor clearColor];
    CGFloat w = (SCREEN_WIDTH - 225)/6;
    h = (h-200)/3;
    for (int i = 0 ; i < 12; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+2000;
        NSString *imageName_Sel = [NSString stringWithFormat:@"DoorLogo%d",i+1];
        NSString *imageName = [NSString stringWithFormat:@"%@_Sel",imageName_Sel];
        
        [button setImage:[UIImage imageNamed:imageName]
               withTitle:self.titleList[i]
                forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageName_Sel] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        [button setSelected:[self.stateList[i] boolValue]];
        if (i< 6) {
            button.frame = VIEWFRAME((i%3*2+1)*w+75*(i%3), (i/3+1)*h+(i/3)*100, 75, 100);
            [view1 addSubview:button];
        }else{
            int t = i - 6;
            button.frame = VIEWFRAME((t%3*2+1)*w+75*(t%3), (t/3+1)*h+(t/3)*100, 75, 100);
            [view2 addSubview:button];
        }
        [self.buttonArray addObject:button];
        
    }
    //翻页图片
    self.pageN = [UIImage imageNamed:@"HomePage_n"];
    self.pageU = [UIImage imageNamed:@"HomePage_u"];
    self.pageLeft = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-self.pageN.size.width-3,ViewY(self.scrollView) + ViewHeight(self.scrollView) + 10, self.pageN.size.width, self.pageN.size.height)];
    self.pageLeft.image = self.pageN;
    
    self.pageRight = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2+3, ViewY(self.scrollView) + ViewHeight(self.scrollView) + 10, self.pageN.size.width, self.pageN.size.height)];
    self.pageRight.image = self.pageU;
    [self.view addSubview:self.pageLeft];
    [self.view addSubview:self.pageRight];
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
}

- (void)disConnect{
    self.firstData = nil;
}

#pragma mark -- right Button
- (void)setRightNavigation{
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(RightbarbuttonAction)];
    self.navigationItem.rightBarButtonItem = bar;
}

#pragma mark -- 导航栏按钮
- (void)setNavgationBarLeftItemWithImage:(UIImage *)image {
    UIBarButtonItem *leftItemButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(presentLeftMenuViewController:)];
    //leftItemButton.imageInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    self.navigationItem.leftBarButtonItem = leftItemButton;
}

- (void)RightbarbuttonAction{
    [self getData];
}

#pragma mark -- scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > SCREEN_WIDTH/2) {
        self.pageLeft.image = self.pageU;
        self.pageRight.image = self.pageN;
    }else{
        self.pageLeft.image = self.pageN;
        self.pageRight.image = self.pageU;
    }
}

////数据一进入就会进入的函数
//#pragma mark -- btmanager delegate
//- (void)updateValue:(NSData *)data{
//
//    //当数据超过80时 去除前面已循环的65个字节
//    if (self.firstData.length > 80) {
//        self.firstData = [[self.firstData subdataWithRange:NSMakeRange(65, self.firstData.length-65)] mutableCopy];
//    }
//
//
//
//    if (!self.firstData) {
//
//        self.firstData = [data mutableCopy];//如果为空，初始化 并把第一个数据加入
//        [self analyseData:self.firstData];//分析数据
//    }else{
//        [self.firstData appendData:data];//不为空 把数据加入
//        [self analyseData:self.firstData];//分析数据
//    }
//
//
//}
//
//
//
//
//#pragma mark -- 分析数据
//- (void)analyseData:(NSMutableData *)data{
//    Byte *a = (Byte *)[data bytes];//取出data对象里面的字节数组
//
//    if (data.length > 14) {
//        //当长度大于14时才有可能为有效数据 ，循环判断
//        for (int i = 0; i<data.length-14; i++) {
//            if (a[i]== 0x5a && a[i+1]==0xa5 &&a[i+2]==0x0c && (a[i+3]==0x03 || a[i+3]==0x43) &&(a[i+4]==0x01 || a[i+4]==0x00)) {
//
//                //当前面字节数据都对时，截取出数据
//                NSData *now = [data subdataWithRange:NSMakeRange(i, 15)];
//                //判断当前一个正确数据存在并不等于当前数据时，才进行处理，
//                if (self.lastData && [now isEqualToData:self.lastData]) {
//
//                }else{
//
//                    [self handleData:a index:i];//处理数据，传入字节数组中第一个字节的位置
//                    self.lastData = [data subdataWithRange:NSMakeRange(i, 15)];//截取出数据保存，用来判断多次数据相同时是否进行处理
//                }
//                //正确时，把总数据截取至当前数据之后，
//                self.firstData = [[data subdataWithRange:NSMakeRange(i+15, data.length-i-15)] mutableCopy];
//
//                NSLog(@"first Data : %@",self.firstData);//打印当前数据
//                break;
//            }
//        }
//    }
//}
//
//#pragma mark -- 处理数据
//- (void)handleData:(Byte *)a index:(NSInteger )i{
//    //判断checksum 是否正确
//    Byte check = (a[i+3]+ a[i+4]+a[i+5]+a[i+6]+a[i+7]+ a[i+8]+a[i+9]+a[i+10]+a[i+11]+ a[i+12]+a[i+13])%255;
//    if (check == a[i+14]) {
//        //车门和后盖门
//        NSMutableArray *data1 = [self.btmanager decimalTOBinary:a[i+6] backLength:8];
//        NSInteger isLeft1  = [data1[3] integerValue];
//        NSInteger isLeft2  = [data1[5] integerValue];
//        NSInteger isRight1 = [data1[4] integerValue];
//        NSInteger isRight2 = [data1[6] integerValue];
//        NSInteger isOout   = [data1[7] integerValue];
//        NSString *imageName = [NSString stringWithFormat:@"DoorCondition%li%li%li%li",(long)isLeft1,(long)isLeft2,(long)isRight1,(long)isRight2];
//
//        self.imageView.image = [UIImage imageNamed:imageName];
//
//        [(UIButton *)self.buttonArray[0] setSelected:isLeft1];
//        [(UIButton *)self.buttonArray[3] setSelected:isLeft2];
//        [(UIButton *)self.buttonArray[1] setSelected:isRight1];
//        [(UIButton *)self.buttonArray[4] setSelected:isRight2];
//        [(UIButton *)self.buttonArray[2] setSelected:isOout];
//        //suo
//
//
//        //天窗
//        if (a[i+8] == 0x00) {
//            [(UIButton *)self.buttonArray[5] setSelected:NO];
//        }else{
//            [(UIButton *)self.buttonArray[5] setSelected:YES];
//        }
//        //车灯与喇叭
//        NSMutableArray *data4 = [self.btmanager decimalTOBinary:a[i+9] backLength:8];
//        BOOL islighted = [data4[1] boolValue];
//        [(UIButton *)self.buttonArray[8] setSelected:islighted];
//
//        //车窗
//        NSMutableArray *data5 = [self.btmanager decimalTOBinary:a[i+10] backLength:8];
//        [(UIButton *)self.buttonArray[6]  setSelected:[data5[1] boolValue]];
//        [(UIButton *)self.buttonArray[7]  setSelected:[data5[2] boolValue]];
//        [(UIButton *)self.buttonArray[9]  setSelected:[data5[3] boolValue]];
//        [(UIButton *)self.buttonArray[10] setSelected:[data5[4] boolValue]];
//
//        //空调状态与风量等级
//        NSMutableArray *data6 = [self.btmanager decimalTOBinary:a[i+11] backLength:8];
//        [(UIButton *)self.buttonArray[11]  setSelected:[data6[0] boolValue]];
//
//    }
//
//}

#pragma mark -- 分析数据
- (void)analyseData:(NSData *)data{
    
    
    
    
    //        NSRange range = [self.firstData rangeOfData:self.corretData options:NSDataSearchBackwards range:NSMakeRange(0, self.firstData.length)];
    //        if (range.location != NSNotFound && (self.firstData.length - range.location)>14) {
    //            NSData *codata = [self.firstData subdataWithRange:NSMakeRange(range.location, 15)];
    //
    //            if (self.lastData && [self.lastData isEqualToData:codata]) {
    //                //[self handleData:codata];
    //            }else{
    //                 [self handleData:codata];
    //            }
    //            self.firstData = [[self.firstData subdataWithRange:NSMakeRange(range.location+15, data.length-range.location-15)] mutableCopy];
    //
    //        }else{
    //            range = [self.firstData rangeOfData:self.corretData2 options:NSDataSearchBackwards range:NSMakeRange(0, self.firstData.length)];
    //            if (range.location != NSNotFound && (self.firstData.length - range.location)>14) {
    //                NSData *codata = [self.firstData subdataWithRange:NSMakeRange(range.location, 15)];
    //                if (self.lastData && [self.lastData isEqualToData:codata]) {
    //                    //[self handleData:codata];
    //                }else{
    //                    [self handleData:codata];
    //                }
    //                self.firstData = [[self.firstData subdataWithRange:NSMakeRange(range.location+15, data.length-range.location-15)] mutableCopy];
    //            }
    //        }
    //        NSLog(@"first Data : %@",self.firstData);//打印当前数据
    
}


//数据一进入就会进入的函数
#pragma mark -- btmanager delegate
- (void)updateValue:(NSData *)data{
    if (!self.firstData) {
        self.firstData = [data mutableCopy];//如果为空，初始化 并把第一个数据加入
    }else{
        [self.firstData appendData:data];//不为空 把数据加入
    }
    
    
}
#pragma mark -- 处理数据
- (void)handleData:(NSData *)data{

    Byte *a = (Byte *)[data bytes];//取出data对象里面的字节数组
    if (a[0]== 0x5a && a[1]==0xa5 &&a[2]==0x0c && (a[3]==0x03 || a[3]==0x43) &&(a[4]==0x01 || a[4]==0x00)){
        //判断checksum 是否正确
        Byte check = (a[3]+ a[4]+a[5]+a[6]+a[7]+ a[8]+a[9]+a[10]+a[11]+ a[12]+a[13])%255;
        if (check == a[14]) {
            //车门和后盖门
            NSMutableArray *data1 = [self.btmanager decimalTOBinary:a[6] backLength:8];
            NSInteger isLeft1  = [data1[3] integerValue];
            NSInteger isLeft2  = [data1[5] integerValue];
            NSInteger isRight1 = [data1[4] integerValue];
            NSInteger isRight2 = [data1[6] integerValue];
            NSInteger isOout   = [data1[7] integerValue];
            NSString *imageName = [NSString stringWithFormat:@"DoorCondition%li%li%li%li",(long)isLeft1,(long)isLeft2,(long)isRight1,(long)isRight2];
            
            self.imageView.image = [UIImage imageNamed:imageName];
            
            [(UIButton *)self.buttonArray[0] setSelected:isLeft1];
            [(UIButton *)self.buttonArray[3] setSelected:isLeft2];
            [(UIButton *)self.buttonArray[1] setSelected:isRight1];
            [(UIButton *)self.buttonArray[4] setSelected:isRight2];
            [(UIButton *)self.buttonArray[2] setSelected:isOout];
            //suo
            
            
            //天窗
            if (a[8] == 0x00) {
                [(UIButton *)self.buttonArray[5] setSelected:NO];
            }else{
                [(UIButton *)self.buttonArray[5] setSelected:YES];
            }
            //车灯与喇叭
            NSMutableArray *data4 = [self.btmanager decimalTOBinary:a[9] backLength:8];
            BOOL islighted = [data4[1] boolValue];
            [(UIButton *)self.buttonArray[8] setSelected:islighted];
            
            //车窗
            NSMutableArray *data5 = [self.btmanager decimalTOBinary:a[10] backLength:8];
            [(UIButton *)self.buttonArray[6]  setSelected:[data5[1] boolValue]];
            [(UIButton *)self.buttonArray[7]  setSelected:[data5[2] boolValue]];
            [(UIButton *)self.buttonArray[9]  setSelected:[data5[3] boolValue]];
            [(UIButton *)self.buttonArray[10] setSelected:[data5[4] boolValue]];
            
            //空调状态与风量等级
            NSMutableArray *data6 = [self.btmanager decimalTOBinary:a[11] backLength:8];
            [(UIButton *)self.buttonArray[11]  setSelected:[data6[0] boolValue]];
        }else{
            [self getData];
        }
    }
    
    
}

- (void)timerAction{
    if(self.firstData.length >45)
    {
        Byte *a = (Byte *)[self.firstData bytes];//取出data对象里面的字节数组
        for (int i = 0; i<45; i++)
        {
            if((a[i]== 0x5A)&&(a[i+1]== 0xA5)&& (a[i+2]==0x0c) && (self.firstData.length-i)>14)
            {
                //记录当前的索引
                //                FirstIndexOK ++;
                //                if (FirstIndexOK == 1) {
                //                    FirstIndex = i;
                //                }
                NSData *data = [self.firstData subdataWithRange:NSMakeRange(i, 15)];//截取待分析的数据
                [self handleData:data];
                self.firstData = [[self.firstData subdataWithRange:NSMakeRange(i+15, self.firstData.length-i-15)] mutableCopy];//删除前面已循环的字节
                return;
            }
            
            //            if(FirstIndexOK == 2)
            //            {
            //
            //                indexOK = i;//记录记录当前的索引 i
            //                NSData *data = [self.firstData subdataWithRange:NSMakeRange(FirstIndex, indexOK - FirstIndex)];//截取待分析的数据
            //                if (data.length >= 15) {
            ////                    if (self.lastData && [self.lastData isEqualToData:data]) {
            ////
            ////                    }else{
            ////                        [self handleData:data];
            ////                        self.lastData = data;
            ////                    }
            //
            //                    NSLog(@"ttt");
            //                    [self handleData:data];
            //                }
            //
            //                //删除前面已循环的字节
            //                self.firstData = [[self.firstData subdataWithRange:NSMakeRange(indexOK, self.firstData.length-indexOK)] mutableCopy];//删除前面已循环的字节
            //                FirstIndexOK = 0;
            //
            //                return;  //退出for循环
            //            }
            
        }
        self.firstData = [[self.firstData subdataWithRange:NSMakeRange(45, self.firstData.length-45)] mutableCopy];
    }
}


- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}



#pragma mark -- event response


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
