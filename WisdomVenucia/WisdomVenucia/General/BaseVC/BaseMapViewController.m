//
//  BaseMapViewController.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BaseMapViewController.h"

@interface BaseMapViewController ()

@end

@implementation BaseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    [self initSearch];
}

- (void)returnAction
{
    [self clearMapView];
    
    [self clearSearch];
}

- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = MAMapKey;
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(self.view), ViewHeight(self.view))];
    
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    
    self.mapView.delegate = self;
    
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    self.mapView.showsUserLocation = YES;
    
    self.mapView.zoomEnabled = YES;
    
    [self.view addSubview:self.mapView];
    
}

- (void)initSearch
{
    [AMapSearchServices sharedServices].apiKey = MAMapKey;
    
    self.searchAPI = [[AMapSearchAPI alloc] init];
    
    self.searchAPI.delegate = self;
}

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.searchAPI.delegate = nil;
}

#pragma mark - Handle URL Scheme

- (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"] ?: [bundleInfo valueForKey:@"CFBundleName"];
}

- (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    
    return scheme;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [request class], error);
}

- (void)dealloc
{
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
}


@end
