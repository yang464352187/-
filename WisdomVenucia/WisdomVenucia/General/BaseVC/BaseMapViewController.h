//
//  BaseMapViewController.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "WVBaseVC.h"

@interface BaseMapViewController : WVBaseVC <AMapSearchDelegate, MAMapViewDelegate>

@property (nonatomic, strong) MAMapView     *mapView;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;

- (void)returnAction;
- (NSString *)getApplicationName;
- (NSString *)getApplicationScheme;

@end
