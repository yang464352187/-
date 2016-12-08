//
//  BTManager.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/1.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BTManager.h"



#define kServiceUUID                   @"1D5688DE-866D-3AA4-EC46-A1BDDB37ECF6"
#define kCharacteristicUUID            @"AF20FBAC-2518-4998-9AF7-AF42540731B3"
#define kDescriptor                    @"00002902-0000-1000-8000-00805f9b34fb"
#define kBTMANAGER_VALUE               @"kbtmanager_value"


static BTManager * sharedMange = nil;

@interface BTManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (assign, nonatomic) BOOL   isBTOpened;
@property (strong, nonatomic) NSData *heartData;
@property (strong, nonatomic) NSData *sendData;
@property (strong, nonatomic) NSData *firstData;

@end

@implementation BTManager
{
    
    CBCentralManager *_centralManager;// 蓝牙管理中心
    NSTimer *_timer;
    NSInteger _index;
    NSTimer *_datetimer;
}

#pragma mark -- chushihua
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMange = [[BTManager alloc] init];
        [sharedMange initData];
        isManageInited = YES;
    });
    return sharedMange;
}

#pragma mark -- data
- (void)initData{
    self.isBTOpened = NO;
    [sharedMange initCBCentralManager];
    _ServiceUUID        = [CBUUID UUIDWithString:kServiceUUID];
    _CharacteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
    
    Byte b[] ={ 0X5A, 0xA5,0x05,0x01,0xFF,0x00,0x03,0x04};
    self.heartData = [NSData dataWithBytes:&b length:sizeof(b)];
    
}


#pragma mark --  写数据
- (void)writeDataToPeripheral:(NSData *)data{
//    if (_characteristic) {
//        [_currentPeripheral writeValue:data forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
//    }
    if (_characteristic && !self.sendData) {
        self.sendData = data;
    }
}

#pragma mark -- 搜索动作
- (void)SearchPeripheral{
    _peripheralArray = [NSMutableArray array];
    [_timer invalidate];
    _timer             = nil;
    [_datetimer invalidate];
    _datetimer         = nil;
    _currentPeripheral = nil;
    _characteristic    = nil;
    if ([self.delegate respondsToSelector:@selector(updateperipheralArray:)]) {
        [self.delegate updateperipheralArray:_peripheralArray];
    }
    [_centralManager scanForPeripheralsWithServices:@[_ServiceUUID] options:nil];
}


#pragma mark -- 将数据转化为8为bool数组
- (NSMutableArray *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length{
    NSString *a = @"";
    NSMutableArray *test = [[NSMutableArray alloc] init];
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        BOOL ha = tmpid%2? YES:NO;
        [test addObject:@(ha)];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            BOOL ha = NO;
            [test addObject:@(ha)];
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    return test;
    
}

#pragma mark - 初始化蓝牙控制中心和设备保存数组
- (void)initCBCentralManager {
    if (!sharedMange.isBTOpened) {
        _peripheralArray = [NSMutableArray array];
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    }
}

#pragma mark - 连接外设
- (void)ConnectPeripheral:(NSInteger)index{
    
    CBPeripheralState state = [(CBPeripheral *)_peripheralArray[index] state];
    if (state ==  CBPeripheralStateConnecting) {
        
    }else if (state == CBPeripheralStateConnected){
        
    }else{
        // 点击指定蓝牙外设,开始进行连接该外设,在外设保存数组中获取到指定外设
        [_centralManager connectPeripheral:_peripheralArray[index] options:nil];
        _index = index;
    }
    
}
#pragma mark - 退出登录或登录超时 清除蓝牙。
- (void)cleanConnect{
    
    if (_currentPeripheral && _currentPeripheral.state == CBPeripheralStateConnected) {
        [_centralManager cancelPeripheralConnection:_currentPeripheral];
    }
}


#pragma mark - CBCentralManagerDelegate
// 蓝牙状态判断,只有为CBCentralManagerStatePoweredOn才能进行搜索工作
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    switch ([central state])
//    {
//        case CBCentralManagerStateUnsupported:{
//            
//            self.isBTOpened = NO;
//            break;
//        }
//        case CBCentralManagerStateUnauthorized:{
//            self.isBTOpened = NO;
//            break;
//        }
//        case CBCentralManagerStatePoweredOff:{
//            
//            self.isBTOpened = NO;
//            break;
//        }
//        case CBCentralManagerStatePoweredOn:{
//            
//            self.isBTOpened = YES;
//            break;
//        }
//        case CBCentralManagerStateUnknown:
//            self.isBTOpened = NO;
//            break;
//        default:
//            self.isBTOpened = NO;
//            break;
//    }
    
    if ([central state] == CBCentralManagerStatePoweredOn) {
        if (DEFAULTS_GET_BOOL(mBTAUTOCONNECT) && !self.isBTOpened) {
            [self SearchPeripheral];
        }
        self.isBTOpened = YES;
    } else {
        self.isBTOpened = NO;
        if (self.currentPeripheral) {
            if ([self.delegate respondsToSelector:@selector(disConnect)]) {
                [self.delegate disConnect];
            }
            [MBProgressHUD showHudTipStr:@"连接断开"];
            _peripheralArray = [NSMutableArray array];
            [_timer invalidate];
            _timer             = nil;
            [_datetimer invalidate];
            _datetimer         = nil;
            _currentPeripheral = nil;
            _characteristic    = nil;
            if ([self.delegate respondsToSelector:@selector(updateperipheralArray:)]) {
                [self.delegate updateperipheralArray:_peripheralArray];
            }

        }else if(_peripheralArray.count > 0){
            _peripheralArray = [NSMutableArray array];
            if ([self.delegate respondsToSelector:@selector(updateperipheralArray:)]) {
                [self.delegate updateperipheralArray:_peripheralArray];
            }
        }
    }
}

#pragma mark -- 搜索结果回调方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
//    [_peripheralArray addObject:peripheral]; // 将搜索到的蓝牙外设保存到外设保存数组中
//    if ([self.delegate respondsToSelector:@selector(updateperipheralArray:)]) {
//        [self.delegate updateperipheralArray:_peripheralArray];
//    }
    
    //判断是否重名
    if (peripheral.name.length == 0) {
        return;
    }
    
    if (_peripheralArray.count > 0 && peripheral.name.length >0) {
        BOOL isSame = NO;
        for (CBPeripheral *per in _peripheralArray) {
            if ([per.name isEqualToString:peripheral.name]) {
                isSame = YES;
                break;
            }
        }
        if (!isSame) {
            [_peripheralArray addObject:peripheral]; // 将搜索到的蓝牙外设保存到外设保存数组中
            if ([self.delegate respondsToSelector:@selector(updateperipheralArray:)]) {
                [self.delegate updateperipheralArray:_peripheralArray];
            }
            NSString *name = DEFAULTS_GET_OBJ(mBTNAME);
            if (name && [name isEqualToString:peripheral.name] && DEFAULTS_GET_BOOL(mBTAUTOCONNECT)) {
                [self ConnectPeripheral:_peripheralArray.count-1];
            }
        }
    }else{
        [_peripheralArray addObject:peripheral]; // 将搜索到的蓝牙外设保存到外设保存数组中
        if ([self.delegate respondsToSelector:@selector(updateperipheralArray:)]) {
            [self.delegate updateperipheralArray:_peripheralArray];
        }
        NSString *name = DEFAULTS_GET_OBJ(mBTNAME);
        if (name && [name isEqualToString:peripheral.name] && DEFAULTS_GET_BOOL(mBTAUTOCONNECT)) {
            [self ConnectPeripheral:_peripheralArray.count-1];
        }
    }
    
    
}

#pragma mark -- 链接成功回调
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    _currentPeripheral = peripheral;   // 指明连接成功外设为当前使用外设
    peripheral.delegate = self;        // 设置设备协议为当前使用设备
    [central stopScan];                // 停止搜索
    
    [_peripheralArray removeObjectAtIndex:_index];
    [peripheral discoverServices:nil];  //连接成功后搜索服务
    if ([self.delegate respondsToSelector:@selector(ConnectSucceed)]) {
        [self.delegate ConnectSucceed];
    }
    DEFAULTS_SET_OBJ(peripheral.name, mBTNAME);
    DEFAULTS_SAVE;
}

#pragma mark -- 断开连接进入的回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (error) {
        [self disconnectAction];
    }else{
        [self disconnectAction];
    }
    [MBProgressHUD showHudTipStr:@"连接断开"];
}


- (void)disconnectAction{
    if ([self.delegate respondsToSelector:@selector(disConnect)]) {
        [self.delegate disConnect];
    }
    [self SearchPeripheral];
}

#pragma mark -- 扫描到Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    //  NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error)
    {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        
        //扫描每个service的Characteristics，扫描到后会进入方法： -(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
        if ([service.UUID isEqual:_ServiceUUID] ) {
            NSLog(@"service.UUID : %@",service.UUID);
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

#pragma mark -- 扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:_CharacteristicUUID]) {
            _characteristic = characteristic;
            NSLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(TimerWithSendData) userInfo:nil repeats:YES];
            
            _count = 1;
            _datetimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(dataTimerAction) userInfo:nil repeats:YES];
            
            
        }
    }
}


#pragma mark -- 获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    //NSLog(@"value:%@",characteristic.value);
    
    //[self updateValue:characteristic.value];
    NSLog(@"btmanager : %@",characteristic.value);
    if ([self.delegate respondsToSelector:@selector(updateValue:)]) {
        [self.delegate updateValue:characteristic.value];
    }
    
}

#pragma mark -- btmanager delegate
- (void)updateValue:(NSData *)data{
    if (!self.firstData) {
        
        NSMutableData *m_data = [NSMutableData dataWithData:data];
        [self analyseData:m_data];
        self.firstData = [data copy];
    }else{
        
        NSMutableData *m_data = [NSMutableData dataWithData:[self.firstData copy]];
        [m_data appendData:[data copy]];
        [self analyseData:m_data];
        self.firstData = data;
    }
}
#pragma mark -- 分析数据
- (void)analyseData:(NSMutableData *)data{
    Byte *a = (Byte *)[data bytes];
    if (data.length > 14) {
        for (int i = 0; i<data.length-14; i++) {
            if ([self isCorrectData:a index:i length:data.length]) {
                [self handleData:a index:i];
                
                self.firstData = [data subdataWithRange:NSMakeRange(i, data.length-i)];
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
        if (a[i+5] == 0x43){
            //运行时长
            if (a[i+12] == 0x00 || a[i+12] == 0x10) {
//                if (DEFAULTS_GET_OBJ(mCAERUNINGTIME)) {
//                    DEFAULTS_REMOVE(mCAERUNINGTIME);
//                    DEFAULTS_SAVE;
//                }
                self.startTime = 0;
            }else{
//                if (!DEFAULTS_GET_OBJ(mCAERUNINGTIME)) {
//                    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
//                    DEFAULTS_SET_OBJ(@(start), mCAERUNINGTIME);
//                    DEFAULTS_SAVE;
//                    //判断是否有启动时间
//                    
//                    
//                }
                if (!self.startTime) {
                    self.startTime =  [[NSDate date] timeIntervalSince1970];
                }
            }
        }
    }
}



#pragma mark -- 写入成功的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"error::: %@",error.description);
    }
}


- (void)TimerWithSendData{
    //NSLog(@"蓝牙计时测试");
    if (_characteristic) {
        _count = 1;
//        Byte b[] ={ 0X5A, 0xA5,0x05,0x01,0xFF,0x00,0x03,0x04};
//        NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
//        
//        [_currentPeripheral writeValue:data forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
//        _count = 1;
//        [self writeDataToPeripheral:self.heartData];
    }
}

- (void)dataTimerAction{
    if (_characteristic) {
        
        if (_count>0) {
            _count = 0;
            [_currentPeripheral writeValue:self.heartData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
        }else if (self.sendData){
            [_currentPeripheral writeValue:self.sendData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
            self.sendData = nil;
        }
    }
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
    
    [_datetimer invalidate];
    _datetimer = nil;
}


@end
