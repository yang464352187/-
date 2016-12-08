//
//  BTManager.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/1.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

static BOOL isManageInited = NO;

@protocol BTManagerDelegate <NSObject>

@optional
- (void)updateValue:(NSData *)data;
- (void)updateperipheralArray:(NSMutableArray *)array;
- (void)ConnectSucceed;
- (void)disConnect;
@end

@interface BTManager : NSObject

//单例初始化
+ (instancetype)sharedManager;

// 初始化蓝牙控制中心和设备保存数组
- (void)initCBCentralManager;
//扫描
- (void)SearchPeripheral;
//连接外设
- (void)ConnectPeripheral:(NSInteger)index;
//写数据
- (void)writeDataToPeripheral:(NSData *)data;
//将数据转化为8为bool数组
- (NSMutableArray *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length;
//退出登录或登录超时 清除蓝牙。
- (void)cleanConnect;


@property (weak,   nonatomic) id<BTManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *peripheralArray; // 蓝牙外设管理数组
@property (strong, nonatomic) CBPeripheral *currentPeripheral; // 当前选中蓝牙外设
@property (strong, nonatomic) CBCharacteristic *characteristic;
@property (strong, nonatomic) CBUUID *ServiceUUID;
@property (strong, nonatomic) CBUUID *CharacteristicUUID;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSTimeInterval startTime;


@end
