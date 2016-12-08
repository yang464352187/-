//
//  MotifyMyInfoVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/23.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "MotifyMyInfoVC.h"
#import "DatePickerView.h"
#import "ModifyUserInfoModel.h"


@interface MotifyMyInfoVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,DatePickerViewDelegate>

@property (strong, nonatomic) UIImageView     *HeadImage;
@property (strong, nonatomic) NSArray         *valueList;
@property (strong, nonatomic) NSArray         *titleList;
@property (strong, nonatomic) UITableView     *tableView;
@property (strong, nonatomic) NSDictionary    *userInfo;
@property (weak, nonatomic  ) UITableViewCell *birthdayCell;
@property (weak, nonatomic  ) UITableViewCell *sexCell;
@property (strong, nonatomic) UITextField     *username;
@property (strong, nonatomic) UITextField     *nickname;
@property (strong, nonatomic) UITextField     *address;
@property (strong, nonatomic) UITextField     *introduction;
@property (assign, nonatomic) NSInteger       sex;
@property (strong, nonatomic) UILabel         *birthday;
@property (strong, nonatomic) NSString        *avatar;
@property (strong, nonatomic) DatePickerView  *datePicker;
@property (strong, nonatomic) UserInfoModel   *userInfoModel;
@property (strong, nonatomic) ModifyUserInfoModel *modifyModel;

@end

@implementation MotifyMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"修改个人信息";
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"帐号",@"昵称",@"性别",@"出生日期",@"地区",@"个性签名"];
    
    self.userInfo = DEFAULTS_GET_OBJ(mLOGINUSERINFO);
    if (self.userInfo) {
        NSString *str = [self.userInfo[@"sex"] integerValue] == 0? @"男":@"女";
        self.valueList = @[self.userInfo[@"username"],self.userInfo[@"nickname"],str,self.userInfo[@"birthday"],self.userInfo[@"address"],self.userInfo[@"introduction"]];
    }else{
        self.valueList = @[@"",@"",@"",@"",@"",@""];
    }
}

#pragma mark --设置UI
- (void)initUI{
    [self initDatePickerView];
    [self initTableView];
    [self setSecLeftNavigation];
}

- (void)initDatePickerView{
    self.datePicker = [[DatePickerView alloc] initWithFrame:APP_BOUNDS];
    self.datePicker.delegate = self;
    [self.datePicker setinitialDate:self.userInfo[@"birthday"]];
    [self.view addSubview:self.datePicker];
    [self.view sendSubviewToBack:self.datePicker];
}

#pragma mark --设置表视图
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, SCREEN_HIGHT-64)];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled   = NO;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, 80)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIImage *motifyImg = [UIImage imageNamed:@"BaseButton"];
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame = VIEWFRAME(SCREEN_WIDTH/2-motifyImg.size.width/2, 20, motifyImg.size.width, motifyImg.size.height);
    Button.transform = CGAffineTransformMakeScale(0.9, 0.9);
    Button.titleLabel.font = SYSTEMFONT(18);
    [Button setTitle:@"提交" forState:UIControlStateNormal];
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Button setBackgroundImage:motifyImg forState:UIControlStateNormal];
    [Button setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
    [Button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:Button];
    
    self.tableView.tableFooterView = footView;
    
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyCell%li",(long)indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:[NSString stringWithFormat:@"MyCell%li",(long)indexPath.row]];
    }
    cell.textLabel.text            = self.titleList[indexPath.row];
    cell.textLabel.font            = CELL_BASE_FONT;
    cell.textLabel.textAlignment   = NSTextAlignmentLeft;
    cell.textLabel.textColor       = [UIColor whiteColor];
    cell.backgroundColor           = [UIColor clearColor];
    cell.selectionStyle            = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.font      = CELL_BASE_FONT;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    CGRect frame = VIEWFRAME(112, 19 , 200 , 17);
    switch (indexPath.row) {
        case 0:{
            cell.detailTextLabel.text = self.valueList[indexPath.row];
            [cell addSubview:self.username];
            break;
        }
        case 1:{
            self.nickname = [[UITextField alloc] initWithFrame:frame];
            self.nickname.textColor = [UIColor whiteColor];
            self.nickname.font = CELL_BASE_FONT;
            self.nickname.placeholder = @"昵称(最短4个字符)";
            self.nickname.text = self.valueList[indexPath.row];
            [self.nickname setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [cell addSubview:self.nickname];
            break;
        }
        case 2:{
            cell.detailTextLabel.text = self.valueList[indexPath.row];
            _sexCell = cell;
            cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 3:{
            cell.detailTextLabel.text = self.valueList[indexPath.row];
            _birthdayCell = cell;
            cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 4:{
            self.address = [[UITextField alloc] initWithFrame:frame];
            self.address.textColor = [UIColor whiteColor];
            self.address.font = CELL_BASE_FONT;
            self.address.placeholder = @"设置地区(福建厦门)";
            self.address.text = self.valueList[indexPath.row];
            [self.address setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [cell addSubview:self.address];
            break;
        }
        case 5:{
            self.introduction = [[UITextField alloc] initWithFrame:frame];
            self.introduction.textColor = [UIColor whiteColor];
            self.introduction.font = CELL_BASE_FONT;
            self.introduction.placeholder = @"编辑个人签名";
            self.introduction.text = self.valueList[indexPath.row];
            [self.introduction setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            [cell addSubview:self.introduction];
            break;
        }
        default:
            break;
    }
    //背景色和分割线
    
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, 54, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 2:{
            //性别
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择性别"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"男"
                                                  otherButtonTitles:@"女", nil];
            
            [alert show];
            break;
        }
        case 3:{
            //出生日期
            [self.datePicker bringSubviewToFrontAction];
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    _sexCell.detailTextLabel.textColor = [UIColor whiteColor];
    self.sex = buttonIndex;
    if (buttonIndex == 0) {
        _sexCell.detailTextLabel.text = @"男";
        
    }else{
        _sexCell.detailTextLabel.text = @"女";
    }
}

#pragma mark -- datepicker delegate
- (void)didSaveClick:(NSString *)date{
    _birthdayCell.detailTextLabel.text = date;
}


#pragma mark -- 提交按钮动作
- (void)ButtonClick:(id)sender{
    [SVProgressHUD show];
    
    self.userInfoModel = [[UserInfoModel alloc] init];
    self.userInfoModel.token = self.currentLoginUser.token;
    self.userInfoModel.username = self.userInfo[@"username"];
    self.userInfoModel.nickname = self.nickname.text;
    self.userInfoModel.birthday = _birthdayCell.detailTextLabel.text;
    self.userInfoModel.introduction = self.introduction.text;
    self.userInfoModel.address = self.address.text;
    self.userInfoModel.avatar = self.userInfo[@"avatar"];
    self.userInfoModel.sex = @(self.sex);
    
//    self.modifyModel = [[ModifyUserInfoModel alloc] init];
//    self.modifyModel.token = self.currentLoginUser.token;
//    self.modifyModel.username = self.userInfo[@"username"];
//    self.modifyModel.nickname = self.nickname.text;
//    self.modifyModel.birthday = _birthdayCell.detailTextLabel.text;
//    self.modifyModel.introduction = self.introduction.text;
//    self.modifyModel.address = self.address.text;
//    self.modifyModel.sex = @(self.sex);
    
    NSLog(@"%@",_birthdayCell.detailTextLabel.text);
    
    _weekSelf(weakSelf);
    [[NetAPIManager sharedManager] request_ModifyUserInfo_WithParams:self.userInfoModel succesBlack:^(id data) {
        [SVProgressHUD dismiss];
        [weakSelf popGoBack];
        [MBProgressHUD showHudTipStr:@"修改信息成功"];
         [[NSNotificationCenter defaultCenter] postNotificationName:kLeftVC object:nil];
    } failue:^(id data, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}


@end
