//
//  CarConditionMoreVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/19.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "CarConditionMoreVC.h"
#import "CarConditionMoreCell.h"
#import "BTManager.h"

static NSString * const reuseIdentifier = @"MoreCell";

@interface CarConditionMoreVC ()<UICollectionViewDataSource,UICollectionViewDelegate,BTManagerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray          *titleList;
@property (strong, nonatomic) NSMutableArray   *valueList;
@property (strong, nonatomic) BTManager        *btmanager;
@property (strong, nonatomic) NSMutableArray   *dataArray;
@property (strong, nonatomic) NSMutableData    *firstData;
@property (strong, nonatomic) NSData           *lastData;
@property (strong, nonatomic) NSTimer          *timer;

@end

@implementation CarConditionMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"更多";
}

#pragma mark -- 初始化数据
- (void)initData{
    
    self.btmanager          = [BTManager sharedManager];
    self.btmanager.delegate = self;
    
    self.dataArray          = [[NSMutableArray alloc] init];
    self.valueList = [NSMutableArray arrayWithObjects:@"0L/km",@"0KM",@"0KM",@"0RPM",@"0°C",@"发动机停止",@"0KM",@"0%",@"0%",@"0%",@"0L/100KM",@"0°C",@"0v",@"0时0分0秒", nil];
    if (self.btmanager.startTime) {
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970] - self.btmanager.startTime;
        int hour = now/3600.0;
        int mine = now/60.0 - hour*60;
        int sec  = (int)now%60;
        NSString *time = [NSString stringWithFormat:@"%d时%d分%d秒",hour,mine,sec];
        [self.valueList replaceObjectAtIndex:13 withObject:time];
    }
    self.titleList = @[@"平均油耗",@"续航里程",@"历史里程",@"转速",@"水温",@"发动机状态",@"速度",@"剩余油量",@"负荷",@"气节门开度",@"瞬时油耗",@"进气温度",@"汽车电压",@"运行时长"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}
- (void)getData{
    Byte d[] ={ 0X5A, 0xA5,0x05,0x02,0x01,0x00,0xFF,0x03};
    NSData *data = [NSData dataWithBytes:&d length:sizeof(d)];
    [self.btmanager writeDataToPeripheral:data];
}

- (void)initUI{
    
    [self initCollectionView];
    
    [self setSecLeftNavigation];
}

- (void)initCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.0];
    [flowLayout setMinimumLineSpacing:0.0];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HIGHT-64) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[CarConditionMoreCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.collectionView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

#pragma mark -- collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CarConditionMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row >= 0) {
        cell.titleLabel.text = self.titleList[indexPath.row];
        cell.valueLabel.text = self.valueList[indexPath.row];
        NSString *imageName = [NSString stringWithFormat:@"MoreImg_%li",indexPath.row+1];
        [cell setImage:[UIImage imageNamed:imageName]];
    }
    
    cell.backgroundColor = HEXCOLOR(0xe6eaf0);
    return cell;
    
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
//        
//        NSMutableData *m_data = [data mutableCopy];
//        [self analyseData:m_data];
//        self.firstData = [data copy];
//    }else{
//        
//        NSMutableData *m_data = [self.firstData mutableCopy];
//        [m_data appendData:[data copy]];
//        [self analyseData:m_data];
//        if (m_data.length < 15) {
//            self.firstData = m_data;
//        }else{
//            
//            self.firstData = data;
//        }
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
    if (a[i]== 0x5a && a[i+1]==0xa5 &&a[i+2]==0x0c && (a[i+3]==0x02 || a[i+3]==0x42) &&(a[i+4]==0x01 || a[i+4]==0x00) && (length-i)>=15) {
        return YES;
    }
    return NO;
}

#pragma mark -- 处理数据
- (void)handleData:(Byte *)a index:(NSInteger)i{
    Byte check = (a[i+3]+ a[i+4]+a[i+5]+a[i+6]+a[i+7]+ a[i+8]+a[i+9]+a[i+10]+a[i+11]+ a[i+12]+a[i+13])%255;
    if (check == a[i+14]) {
        if (a[i+5] == 0x41) {
            //平均油耗  续航里程  历史里程
            CGFloat inter1 = a[i+6]+ ((CGFloat)a[i+7]/10);
            NSString *str1 = [NSString stringWithFormat:@"%.1fL/100KM",inter1];
            [self.valueList replaceObjectAtIndex:0 withObject:str1];
            
            
            NSInteger inter2 = (a[i+8]*16*16 + a[i+9]);
            NSString *str2 = [NSString stringWithFormat:@"%liKM",inter2];
            [self.valueList replaceObjectAtIndex:1 withObject:str2];
            
            CGFloat inter3 = (a[i+10]*16*16*16*16 + a[i+11]*16*16 + a[i+12] + a[i+13]/10.0);
            NSString *str3 = [NSString stringWithFormat:@"%.1fKM",inter3];
            [self.valueList replaceObjectAtIndex:2 withObject:str3];
            
            
        }else if (a[i+5] == 0x42){
            //发动机转速  发动机水温  发动机状态 车速 剩余油量 发动机负荷
            //转速
            NSInteger inter1 = (a[i+6]*16*16 + a[i+7]);
            NSString *str1 = [NSString stringWithFormat:@"%liRPM",(long)inter1];
            [self.valueList replaceObjectAtIndex:3 withObject:str1];
            //发动机水温
            NSUInteger inter2 = a[i+8]-40;
            NSString *str2 = [NSString stringWithFormat:@"%li°C",(long)inter2];
            [self.valueList replaceObjectAtIndex:4 withObject:str2];
            //发动机状态
            NSString *str3;
            if (a[i+9] == 0x00) {
                str3 = @"发动机停止";
            }else if (a[i+9] == 0x01){
                str3 = @"发动机熄火";
            }else if (a[i+9] == 0x02){
                str3 = @"发动机运行";
            }else if (a[i+9] == 0x03){
                str3 = @"发动机启动";
            }else{
                str3 = @"";
            }
            [self.valueList replaceObjectAtIndex:5 withObject:str3];
            //车速
            CGFloat inter4 = a[i+10]+ ((CGFloat)a[i+11]/10);
            NSString *str4 = [NSString stringWithFormat:@"%.1fKM/h",inter4];
            [self.valueList replaceObjectAtIndex:6 withObject:str4];
            
            //油量
            NSInteger inter5 = a[i+12];
            NSString *str5 = [NSString stringWithFormat:@"%li％",(long)inter5];
            [self.valueList replaceObjectAtIndex:7 withObject:str5];
            //发动机负荷
            NSInteger inter6 = a[i+13];
            NSString *str6 = [NSString stringWithFormat:@"%li％",(long)inter6];
            [self.valueList replaceObjectAtIndex:8 withObject:str6];
            
        }else if (a[i+5] == 0x43){
            //节气门开度  瞬时油耗 进气温度 汽车电压 运行时长
            //节气门开度
            NSInteger inter1 = a[i+6];
            NSString *str1 = [NSString stringWithFormat:@"%li％",(long)inter1];
            [self.valueList replaceObjectAtIndex:9 withObject:str1];
            //瞬时油耗
            CGFloat inter2 = a[i+7]+ (a[i+8]/10.0);
            NSString *str2 = [NSString stringWithFormat:@"%.1fL/100KM",inter2];
            [self.valueList replaceObjectAtIndex:10 withObject:str2];
            //进气温度
            NSInteger inter3 = a[i+9];
            NSString *str3 = [NSString stringWithFormat:@"%li％",(long)inter3];
            [self.valueList replaceObjectAtIndex:11 withObject:str3];
            //汽车电压
            CGFloat inter4 = a[i+10]+ (a[i+11]/10.0);
            NSString *str4 = [NSString stringWithFormat:@"%.1fV",inter4];
            [self.valueList replaceObjectAtIndex:12 withObject:str4];
            //运行时长
            NSString *str5;
            if (a[i+12] == 0x00 || a[i+12] == 0x10) {
                str5 = @"0时0分0秒";
                [self.valueList replaceObjectAtIndex:13 withObject:str5];
            }else{
//                str5 = @"0时0分0秒";
            }
            
        }
        [self.collectionView reloadData];
        
        
    }
}

- (void)timerAction{
    if (self.btmanager.startTime > 1000) {
        NSLog(@"进入计时");
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970] - self.btmanager.startTime;
        int hour = now/3600.0;
        int mine = now/60.0 - hour*60;
        int sec  = (int)now%60;
        NSString *time = [NSString stringWithFormat:@"%d时%d分%d秒",hour,mine,sec];
        [self.valueList replaceObjectAtIndex:13 withObject:time];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:13 inSection:0]]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

@end
