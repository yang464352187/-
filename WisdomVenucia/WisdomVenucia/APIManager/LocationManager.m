//
//  LocationManager.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 16/7/13.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "LocationManager.h"
#import "UploadLocation.h"

@interface LocationManager()<AMapLocationManagerDelegate, AMapSearchDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager; //后台定位管理对象
@property (nonatomic, strong) AMapSearchAPI       *search;          //搜索对象
@property (nonatomic, strong) AMapGeocode         *geocode;         //地理编码返回model

@property (nonatomic, assign) BOOL hasSendMsg;

@end

@implementation LocationManager

+ (instancetype)sharedManager {
    static dispatch_once_t predicate;
    static id sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[LocationManager alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc {
    _locationManager.delegate = nil;
    _search.delegate = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        _geocode = [[AMapGeocode alloc]init];
        
        _search  = [[AMapSearchAPI alloc]init];
        _search.delegate = self;
        
        [AMapLocationServices sharedServices].apiKey = MAMapKey;
        _locationManager = [[AMapLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager setPausesLocationUpdatesAutomatically:NO];//设置允许后台定位参数，保持不会被系统挂起
        [_locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
//        [_locationManager setDistanceFilter:300];//设置300米更新一次
    
    }
    return self;
}

- (void)startLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocation {
    [self.locationManager stopUpdatingLocation];
}

//位置更新回调(location)
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    //没有登录，直接return
    if (![LoginModel isLogin]) {
        return;
    }
    
    //上传经纬度
    [[UploadLocation sharedManager] uploadLocationWithSharedid:self.selectShareMode.locationshareid
                                                           lat:location.coordinate.latitude
                                                           lng:location.coordinate.longitude];
    
    //此处每上传一个经纬度，判断是否进入范围
    for (NSInteger i = 0; i < self.selectShareMode.contacts.count; i++) {
        //地理编码
        AMapGeocodeSearchRequest *requestModel = [[AMapGeocodeSearchRequest alloc]init];
        ContactInfoModel *contactInfo          = self.selectShareMode.contacts[i];
        requestModel.address                   = contactInfo.address;
        [self.search  AMapGeocodeSearch:requestModel];
        CLLocationCoordinate2D point = (CLLocationCoordinate2DMake(self.geocode.location.latitude, self.geocode.location.longitude));
        //判断点是否在圆内，类似地理围栏
        BOOL isContains = MACircleContainsCoordinate(point, location.coordinate, [self.selectShareMode.distance floatValue]);
        if (isContains) {
            if (self.hasSendMsg) {
                return;
            }
            [[UploadLocation sharedManager]sendLocationShareMsg];  //此处发送事件消息
            self.hasSendMsg = YES;
        }
    }
}

//地理编码回调(search)
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if (response.geocodes.count == 0) {
        [MBProgressHUD showHudTipStr:@"没有找到联系人地址"];
        return;
    }
    self.geocode = (AMapGeocode *)[response.geocodes objectAtIndex:0];
    DebugLog(@"geocode:>>>>%@",describe(response.geocodes));
}



@end
