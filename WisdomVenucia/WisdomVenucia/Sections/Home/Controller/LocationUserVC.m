//
//  LocationUserVC.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/27.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "LocationUserVC.h"
#import "EditLinkPersonVC.h"
#import "LocationSharedListVC.h"
#import "CreateLocationSharedVC.h"

@interface LocationUserVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

{
    NSMutableArray *_tips; //搜索提示列表数据
    NSMutableArray *_searchPOIResposes;//POI搜索返回
    
    BOOL           _isTouchPoi;  //是否是点击搜索
}

@property (nonatomic, strong) UISearchBar   *searchBar;
@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, strong) AMapInputTipsSearchRequest   *tipRequest;//搜索提示请求
@property (nonatomic, strong) AMapInputTipsSearchResponse  *tipResponse;//搜索提示返回
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *keywordRequest;//关键字搜索

@property (nonatomic, strong) NSMutableArray *animations; //保存大头针

@end

@implementation LocationUserVC

#pragma mark - iniliaze
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBar];
    [self initData];
    [self initUI];
    [self initSearchBar];
    [self initTableView];
    self.mapView.frame = CGRectMake(0, 64 + 44, ViewWidth(self.view), ViewHeight(self.view) - 64 - 44);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.showsUserLocation = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.showsUserLocation = NO;
    [self returnAction];
}

- (void)setNaviBar{
    _weekSelf(weakSelf);
    self.title = @"位置共享";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"GoBack"] selectBlock:^{
        [weakSelf popGoBack];
    }];
    
    UIButton *rihgtButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 30, 30)];
    [rihgtButton setImage:[UIImage imageNamed:@"LocationSharedAdd"] forState:UIControlStateNormal];
    [rihgtButton addTarget:self action:@selector(rihgtButtonClike:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rihgtButton];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)initData{
    self.tipRequest     = [[AMapInputTipsSearchRequest alloc]init];
    self.tipResponse    = [[AMapInputTipsSearchResponse alloc]init];
    self.keywordRequest = [[AMapPOIKeywordsSearchRequest alloc]init];

    self.animations    = [NSMutableArray array];
    _searchPOIResposes = [NSMutableArray array];
    _tips              = [NSMutableArray array];
}

- (void)initUI{
    UIButton *listButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth(self.view) - 60, ViewHeight(self.view) - 150, 40, 40)];
    [listButton setBackgroundColor:[UIColor blueColor]];
    [listButton setImage:[UIImage imageNamed:@"LocationSharedTwo"] forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(listButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:listButton aboveSubview:self.mapView];
}

- (void)initSearchBar{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, ViewWidth(self.view), 44)];
    self.searchBar.placeholder = @"请输入关键字";
    self.searchBar.delegate = self;
    
    [self.view addSubview:self.searchBar];
}

- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 44, ViewWidth(self.searchBar), 0)];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView   = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout            = YES;
        annotationView.draggable                 = YES;
        annotationView.animatesDrop              = YES;
        annotationView.pinColor                  = [self.animations indexOfObject:annotation] % 3;
        UIButton *accessaryButton                = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = accessaryButton;
        return annotationView;
    }
    
    return nil;
}

//单击地图回调
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //得到经纬度，逆地理编码得到地名
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.searchAPI AMapReGoecodeSearch:request];
}

//逆地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    DebugLog(@"address:::::::::::%@",response.regeocode.formattedAddress);
    [self.mapView removeAnnotations:self.animations];
    [self.animations removeAllObjects];
    if (!response) {
        [MBProgressHUD showInfoHudTipStr:@"没有搜索到合适的位置"];
        return;
    }
    MAPointAnnotation *annomation = [[MAPointAnnotation alloc]init];
    annomation.coordinate = CLLocationCoordinate2DMake(response.regeocode.addressComponent.streetNumber.location.latitude,
                                                       response.regeocode.addressComponent.streetNumber.location.longitude);
    annomation.title      = response.regeocode.formattedAddress;
    [_animations addObject:annomation];
    [self.mapView addAnnotations:self.animations];
    [self.mapView showAnnotations:self.animations animated:YES];
}

#pragma mark -- 点击弹出视图选择地点
- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view{
    if (_selectedLocationBlock) {
        _selectedLocationBlock(view.annotation.title);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//调起高德地图导航
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]])
    {
        //配置导航参数
        MANaviConfig * config = [[MANaviConfig alloc] init];
        config.destination    = view.annotation.coordinate;//终点坐标，Annotation的坐标
        config.appScheme      = [self getApplicationScheme];//返回的Scheme，需手动设置
        config.appName        = [self getApplicationName];//应用名称，需手动设置
        config.strategy       = MADrivingStrategyShortest;
        //若未调起高德地图App,引导用户获取最新版本的
        if(![MAMapURLSearch openAMapNavigation:config]){
            [MAMapURLSearch getLatestAMapApp];
        }else{
            NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=applicationName&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=1&style=2",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchPOIByKeyword];
    [self reSetTableViewFrameWithText:@""];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.tipRequest.keywords = searchText;
    [self.searchAPI AMapInputTipsSearch:self.tipRequest];
    [self reSetTableViewFrameWithText:searchBar.text];
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有搜索到数据" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return;
    }else {
        [self.animations removeAllObjects];
        [self.mapView removeAnnotations:self.animations];
    }
    [_searchPOIResposes removeAllObjects];
    [_searchPOIResposes addObjectsFromArray:response.pois];
    [_searchPOIResposes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMapPOI *mapPOI = (AMapPOI *)obj;
        MAPointAnnotation *annomation = [[MAPointAnnotation alloc]init];
        
        annomation.coordinate = CLLocationCoordinate2DMake(mapPOI.location.latitude, mapPOI.location.longitude);
        annomation.title      = mapPOI.name;
        [_animations addObject:annomation];
        
    }];
    _isTouchPoi = YES;
    [self.mapView addAnnotations:self.animations];
    [self.mapView showAnnotations:self.animations animated:YES];
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    if (response.count == 0) {
        return;
    }
    [_tips removeAllObjects];
    [_tips addObjectsFromArray:response.tips];
    [_tableView reloadData];
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)erro{
    DebugLog(@"%@",[erro localizedDescription]);
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    
}

//关键字搜索
- (void)searchPOIByKeyword{
    self.keywordRequest                  = [[AMapPOIKeywordsSearchRequest alloc]init];
    self.keywordRequest.keywords         = self.searchBar.text;
    self.keywordRequest.requireExtension = YES;
    [self.searchAPI AMapPOIKeywordsSearch:self.keywordRequest];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    AMapTip *mapTip = _tips[indexPath.row];
    cell.textLabel.text = mapTip.name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapTip *mapTip = _tips[indexPath.row];
    self.searchBar.text = mapTip.name;
    [_tips removeAllObjects];
    [self searchPOIByKeyword];
    [self reSetTableViewFrameWithText:@""];
    [self resignFirstResponder];
}

//重新设置tableView的高度
- (void)reSetTableViewFrameWithText:(NSString *)text{
    CGFloat height = self.tableView.frame.size.height;
    ([text isEqualToString:@""] && _tips) ? (height = 0) : (height = ViewHeight(self.view) - 64 - 50);
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = frame;
    }];
    
}

#pragma mark - buttonClike
- (void)rihgtButtonClike:(UIButton *)sender{
    CreateLocationSharedVC *createShareVC = [[CreateLocationSharedVC alloc]init];
    [self.navigationController pushViewController:createShareVC animated:YES];
}

- (void)listButtonCliked:(UIButton *)sender{
    LocationSharedListVC *sharedListVC = [[LocationSharedListVC alloc]init];
    [self.navigationController pushViewController:sharedListVC animated:YES];

}

@end
