//
//  EditLinkPersonVC.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "EditLinkPersonVC.h"
#import "LocationUserVC.h"
#import "RQContactModel.h"
#import "RPContactModel.h"
#import "ContactManListVC.h"

@interface EditLinkPersonVC ()

@property (nonatomic, strong) UITextField  *nameFiled;
@property (nonatomic, strong) UITextField  *cellFiled;
@property (nonatomic, strong) UITextField  *locationFiled;
@property (nonatomic, strong) UISwitch     *saveContactSwitch;

@end

@implementation EditLinkPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBar];
    [self initUI];
    [self setValues];
}

- (void)initUI{
    self.nameFiled = [UITextField createTextFieldWithFrame:CGRectMake(20, 64 + 20, ViewWidth(self.view) - 40, 44)
                                                                     andName:nil
                                                              andPlaceholder:@"姓名"
                                                            andTextAlignment:NSTextAlignmentLeft
                                                                 andFontSize:[UIFont systemFontOfSize:16]
                                                                andTextColor:nil
                                                                 andDelegate:nil];
    self.cellFiled = [UITextField createTextFieldWithFrame:CGRectMake(20, GetViewMaxY(self.nameFiled) + 20, ViewWidth(self.view) - 40, 44)
                                                   andName:nil
                                            andPlaceholder:@"联系电话"
                                          andTextAlignment:NSTextAlignmentLeft
                                               andFontSize:[UIFont systemFontOfSize:16]
                                              andTextColor:nil
                                               andDelegate:nil];
    self.locationFiled = [UITextField createTextFieldWithFrame:CGRectMake(20, GetViewMaxY(self.cellFiled) + 20, ViewWidth(self.view) - 40, 44)
                                                   andName:nil
                                            andPlaceholder:@"选择具体位置"
                                          andTextAlignment:NSTextAlignmentLeft
                                               andFontSize:[UIFont systemFontOfSize:16]
                                              andTextColor:nil
                                               andDelegate:nil];
    self.locationFiled.enabled = NO;
    
    UIButton *locationButton       = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth(self.locationFiled) - 150, GetViewMaxY(self.locationFiled) + 10, 150, 44)];
    locationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [locationButton setTitle:@"选择你的具体位置" forState:UIControlStateNormal];
    [locationButton setImage:[UIImage imageNamed:@"LocationSharedOne"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationButtonClike) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *contactLabel = [UILabel createLabelWithFrame:CGRectMake(20, GetViewMaxY(locationButton) + 5, 200, 44)
                                                  andText:@"是否保存到常用联系人"
                                             andTextColor:[UIColor whiteColor]
                                               andBgColor:nil
                                                  andFont:[UIFont systemFontOfSize:16]
                                         andTextAlignment:NSTextAlignmentLeft];
    self.saveContactSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(ViewWidth(self.nameFiled) - 51, GetViewMidY(contactLabel) - 15, 0, 0)];
    
    [self.view addSubview:self.nameFiled];
    [self.view addSubview:self.cellFiled];
    [self.view addSubview:self.locationFiled];
    [self.view addSubview:locationButton];
    [self.view addSubview:contactLabel];
    [self.view addSubview:self.saveContactSwitch];
    

}

- (void)setValues{
    if (!self.contactInfo) {
        return;
    }
    self.nameFiled.text     = self.contactInfo.name;
    self.cellFiled.text     = self.contactInfo.phone;
    self.locationFiled.text = self.contactInfo.address;
}

- (void)setNaviBar{
    _weekSelf(weakSelf);
    self.title = @"编辑共享联系人";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"GoBack"] selectBlock:^{
        [weakSelf popGoBack];
    }];
    UIButton *sumitButton      = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [sumitButton setImage:[UIImage imageNamed:@"CheckSuccess"] forState:UIControlStateNormal];
    [sumitButton addTarget:self action:@selector(sumitButtonClike) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sumitItem = [[UIBarButtonItem alloc]initWithCustomView:sumitButton];
    self.navigationItem.rightBarButtonItem = sumitItem;
}

#pragma mark - buttonClike
- (void)sumitButtonClike{
    _weekSelf(weakSelf);
    ContactInfo *contactModel = [[ContactInfo alloc]init];
    contactModel.name          = self.nameFiled.text;
    contactModel.phone         = self.cellFiled.text;
    contactModel.address       = self.locationFiled.text;
    if (_checkBlock) {
        if (_saveContactSwitch.isOn) {
            [weakSelf addContactWithName:contactModel.name phone:contactModel.phone address:contactModel.address];
            _checkBlock(contactModel);
        }else{
            if ([contactModel checkParams]) {
                [MBProgressHUD showInfoHudTipStr:[contactModel checkParams]];
                return;
            }else{
                _checkBlock(contactModel);
                [weakSelf popGoBack];
            }
        }
    }else{
        [weakSelf addContactWithName:contactModel.name phone:contactModel.phone address:contactModel.address];
    }

}

- (void)locationButtonClike{
    LocationUserVC *locationVC = [[LocationUserVC alloc]init];
    locationVC.selectedLocationBlock = ^(NSString *location){
        
    _locationFiled.text = location;
    
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}

//添加常用联系人 / 修改联系人
- (void)addContactWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address{
    RQContactModel *contactModel = [[RQContactModel alloc]init];
    contactModel.token     = self.currentLoginUser.token;
    contactModel.name      = self.nameFiled.text;
    contactModel.phone     = self.cellFiled.text;
    contactModel.address   = self.locationFiled.text;
    contactModel.contactid = self.contactInfo.contactid;
    if ([contactModel checkParams]) {
        [MBProgressHUD showInfoHudTipStr:[contactModel checkParams]];
        return;
    }
    _weekSelf(weakSelf);
    [[NetAPIManager sharedManager]request_CreateContact_WithParams:contactModel succesBlack:^(id data) {
        if ([data[@"code"] integerValue] == 1) {
            if (_reGetContactBlock) {
                _reGetContactBlock();
            }
            [weakSelf popGoBack];
        }
    } failure:^(id data, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
