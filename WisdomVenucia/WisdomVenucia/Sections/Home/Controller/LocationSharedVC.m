//
//  LocationSharedVC.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/23.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "LocationSharedVC.h"

@interface LocationSharedVC ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

{
    NSMutableArray *_tips; //搜索提示列表数据
    NSMutableArray *_searchPOIResposes;//POI搜索返回
}

@property (nonatomic, strong) UITextField *searchTextFiled;

@property (nonatomic, strong) UISearchBar   *searchBar;
@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, strong) UIButton *rihgtOneButton;
@property (nonatomic, strong) UIButton *rihgtTwoButton;
@property (nonatomic, strong) UIButton *rihgtThreeButton;

@property (nonatomic, strong) AMapInputTipsSearchRequest   *tipRequest;//搜索提示请求
@property (nonatomic, strong) AMapInputTipsSearchResponse  *tipResponse;//搜索提示返回
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *keywordRequest;//关键字搜索

@property (nonatomic, strong) NSMutableArray *animations;

@end

@implementation LocationSharedVC

#pragma mark - iniliaze
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBar];
    [self initData];
    [self initTopView];
    [self initTableView];
    self.mapView.frame = CGRectMake(0, 64 + 50, ViewWidth(self.view), ViewHeight(self.view) - 114);
}

- (void)setNaviBar{
    _weekSelf(weakSelf);
    self.title = @"位置共享";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"GoBack"] selectBlock:^{
        [weakSelf popGoBack];
        [weakSelf returnAction];
    }];
}

- (void)initData{
    self.tipRequest                            = [[AMapInputTipsSearchRequest alloc]init];
    self.tipResponse                           = [[AMapInputTipsSearchResponse alloc]init];
    self.keywordRequest                        = [[AMapPOIKeywordsSearchRequest alloc]init];

    _searchPOIResposes                         = [NSMutableArray array];
    _animations                                = [NSMutableArray array];
}

- (void)initTopView{
    UIView *topView            = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth(self.view), 50)];
    topView.backgroundColor    = [UIColor cyanColor];
    self.searchBar             = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ViewWidth(self.view) / 2, 50)];
    self.searchBar.placeholder = @"请输入关键字";
    self.searchBar.delegate    = self;
    
    self.rihgtOneButton = [[UIButton alloc]initWithFrame:CGRectMake(GetViewMaxX(self.searchBar) + 20, 10, 30, 30)];
    [self.rihgtOneButton setImage:[UIImage imageNamed:@"LocationSharedOne"] forState:UIControlStateNormal];
    [self.rihgtOneButton setBackgroundColor:[UIColor orangeColor]];
    [self.rihgtOneButton addTarget:self action:@selector(rihgtOneButtonClike:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(self.rihgtOneButton, 5.0);
    self.rihgtTwoButton = [[UIButton alloc]initWithFrame:CGRectMake(GetViewMaxX(self.rihgtOneButton) + 10, 10, 30, 30)];
    [self.rihgtTwoButton setImage:[UIImage imageNamed:@"LocationSharedTwo"] forState:UIControlStateNormal];
    [self.rihgtTwoButton setBackgroundColor:[UIColor orangeColor]];
    [self.rihgtTwoButton addTarget:self action:@selector(rihgtTwoButtonClike:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(self.rihgtTwoButton, 5.0);
    self.rihgtThreeButton = [[UIButton alloc]initWithFrame:CGRectMake(GetViewMaxX(self.rihgtTwoButton) + 10, 10, 30, 30)];
    [self.rihgtThreeButton setImage:[UIImage imageNamed:@"LocationSharedThree"] forState:UIControlStateNormal];
    [self.rihgtThreeButton setBackgroundColor:[UIColor orangeColor]];
    [self.rihgtThreeButton addTarget:self action:@selector(rihgtThreeButtonClike:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(self.rihgtThreeButton, 5.0);
    
    [topView addSubview:self.rihgtOneButton];
    [topView addSubview:self.rihgtTwoButton];
    [topView addSubview:self.rihgtThreeButton];
    [topView addSubview:self.searchBar];
    [self.view addSubview:topView];
    
}

- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 50, ViewWidth(self.searchBar), 0)];
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
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor                  = [self.animations indexOfObject:annotation] % 3;
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view{
    

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
        [self.mapView removeAnnotations:_animations];
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
    [self.mapView addAnnotations:self.animations];
    [self.mapView showAnnotations:self.animations animated:YES];
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    if (response.count == 0) {
        return;
    }
    [_tips removeAllObjects];
    _tips = [[NSArray arrayWithArray:response.tips]mutableCopy];
    [_tableView reloadData];
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)erro{
    DebugLog(@"%@",[erro localizedDescription]);
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

//定位到指定位置
- (void)locationToThePosition:(AMapGeoPoint *)point{
    
}
//重新设置tableView的高度
- (void)reSetTableViewFrameWithText:(NSString *)text{
    CGFloat height = self.tableView.frame.size.height;
    ([text isEqualToString:@""] && _tips) ? (height = 0) : (height = 200);
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = frame;
    }];

}

- (void)setNaviTitle{
    self.navigationItem.title = @"位置共享";
}

#pragma mark - buttonClike
- (void)rihgtOneButtonClike:(UIButton *)sender{

}

- (void)rihgtTwoButtonClike:(UIButton *)sender{
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"LocationSharedListVC" object:nil info:nil];
}

- (void)rihgtThreeButtonClike:(UIButton *)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
