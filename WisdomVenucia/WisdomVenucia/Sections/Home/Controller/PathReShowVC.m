//
//  PathReShowVC.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/24.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "PathReShowVC.h"

@interface PathReShowVC ()

{
    NSInteger _pageNo;
    NSInteger _pageSize;
    NSInteger _totalSize;
}

@end

@implementation PathReShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.frame = CGRectMake(0, 64, ViewWidth(self.view), ViewHeight(self.view) - 64);
    self.mapView.showsUserLocation = NO;
    self.mapView.zoomLevel = self.mapView.maxZoomLevel;
    [self setNaviBar];
    [self initData];
    [self initOverlay];
}

- (void)setNaviBar{
    _weekSelf(weakSelf);
    self.title = @"轨迹回放";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"GoBack"] selectBlock:^{
        [weakSelf popGoBack];
    }];
}

- (void)initData{
    if (self.locationModel.track.count == 0) {
        [MBProgressHUD showInfoHudTipStr:@"该事件没有轨迹回放,请开启事件"];
        return;
    }
    //设置初始位置为轨迹重点位置
    TrackModel *trackModel = self.locationModel.track[self.locationModel.track.count - 1];
    CLLocationCoordinate2D lastCoordinate = CLLocationCoordinate2DMake([trackModel.lat doubleValue], [trackModel.lng doubleValue]);
    self.mapView.centerCoordinate = lastCoordinate;
    
    DebugLog(@"trackCount:%ld",self.locationModel.track.count);
}

- (void)initOverlay{
    if (self.locationModel.track.count == 0) {
        return;
    }
    CLLocationCoordinate2D coordinates[self.locationModel.track.count];
    for (NSInteger i = 0; i < self.locationModel.track.count; i++) {
        TrackModel *track = self.locationModel.track[i];
        coordinates[i].latitude  = [track.lat doubleValue];
        coordinates[i].longitude = [track.lng doubleValue];
    }
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:self.locationModel.track.count];
    [self.mapView addOverlay:polyline];
}

#pragma mark - MAMapViewDelegate
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineView *polylineView = [[MAPolylineView alloc]initWithPolyline:overlay];
        polylineView.lineWidth       = 3.0;
        polylineView.strokeColor     = [UIColor orangeColor];
        polylineView.lineJoinType    = kMALineJoinRound;
        polylineView.lineCapType     = kMALineCapRound;
        polylineView.lineDash        = YES;
        return polylineView;
    }
    return nil;
}

-(void)dealloc{
    
    [self returnAction];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
