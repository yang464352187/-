//
//  CreateLocationSharedVC.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "CreateLocationSharedVC.h"
#import "EditLinkPersonVC.h"
#import "RQCreateLocationSharedModel.h"
#import "RPContactModel.h"
#import "LocationSharedListCell.h"
#import "PresetMsgView.h"

@interface CreateLocationSharedVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _pageNo;  //第几页
    NSInteger _pageSize;//每页几条
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) UITextField  *titleFiled;
@property (nonatomic, strong) PresetMsgView *presetView;
@property (nonatomic, strong) UITextField  *distanceFiled;
@property (nonatomic, strong) UITextView   *locationText;
@property (nonatomic, strong) UISwitch     *startSwitch;

@property (nonatomic, strong) NSMutableArray      <ContactInfo *>*contacts;
@property (nonatomic, strong) NSMutableArray      <ContactInfo *>*selectedContacts;
@property (nonatomic, strong) NSMutableArray      *allSeletedPhones; //原先已经选中的所有联系人的电话

@end

@implementation CreateLocationSharedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBar];
    [self initData];
    [self initUI];
    [self getContactList];
}

- (void)initData{
    _pageNo   = 1;
    _pageSize = 10;
    
    self.contacts          = [NSMutableArray array];
    self.selectedContacts  = [NSMutableArray array];
    self.allSeletedPhones  = [NSMutableArray array];

    for (ContactInfoModel *contactInfo in self.shareModel.contacts) {//此处先保存已经选中的联系人模型
        [self.allSeletedPhones addObject:contactInfo.phone];
        ContactInfo *selectContact = [[ContactInfo alloc] init];
        selectContact.address = contactInfo.address;
        selectContact.phone = contactInfo.phone;
        selectContact.name = contactInfo.name;
    }
    
}

- (void)setValues{
    if (!self.shareModel) {
        return;
    }
    self.titleFiled.text          = self.shareModel.title;
    self.presetView.textFile.text = self.shareModel.presetMsg;
    self.locationText.text        = self.shareModel.msg;
    self.distanceFiled.text       = [NSString stringWithFormat:@"%@",self.shareModel.distance];
    [self.startSwitch setOn:([self.shareModel.presetMsgSwitch integerValue] == 1) ? YES : NO];
    
}

- (void)initUI{
    [self initScrollView];
    [self createTopView];
    [self initTableView];
    
    [self setValues];
}

- (void)initScrollView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ViewWidth(self.view), ViewHeight(self.view) - 64)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
}

- (void)createTopView{
    self.titleFiled = [UITextField createTextFieldWithFrame:CGRectMake(20, 20, ViewWidth(self.scrollView) - 40, 44)
                                                    andName:nil andPlaceholder:@"舟山旅游"
                                           andTextAlignment:NSTextAlignmentLeft
                                                andFontSize:[UIFont systemFontOfSize:16]
                                               andTextColor:nil
                                                andDelegate:nil];
//    self.startFiled = [UITextField createTextFieldWithFrame:CGRectMake(20, GetViewMaxY(self.titleFiled) + 20, ViewWidth(self.titleFiled) * 3 / 4, 44)
//                                                    andName:nil
//                                             andPlaceholder:@"启动预设消息"
//                                           andTextAlignment:NSTextAlignmentLeft
//                                                andFontSize:[UIFont systemFontOfSize:16]
//                                               andTextColor:nil
//                                                andDelegate:nil];
    self.presetView = [[PresetMsgView alloc]init];
    self.presetView.frame = CGRectMake(20, GetViewMaxY(self.titleFiled) + 20, ViewWidth(self.titleFiled) * 3 / 4, 44);
    
    self.startSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(GetViewMaxX(self.presetView ) + 20, GetViewMidY(self.presetView) - 15, 0, 0)];
    self.locationText = [[UITextView alloc]initWithFrame:CGRectMake(20, GetViewMaxY(self.presetView ) + 20, ViewWidth(self.titleFiled), 150)];
    ViewRadius(self.locationText, 5.0);
    self.locationText.text = @"位置预设消息";
    self.locationText.font = [UIFont systemFontOfSize:16];
    self.distanceFiled = [UITextField createTextFieldWithFrame:CGRectMake(20, GetViewMaxY(self.locationText) + 20, ViewWidth(self.presetView) / 1.5 ,44)
                                                    andName:nil
                                             andPlaceholder:@"位置触发距离"
                                           andTextAlignment:NSTextAlignmentLeft
                                                andFontSize:[UIFont systemFontOfSize:16]
                                               andTextColor:nil
                                                andDelegate:nil];
    UILabel *unitLabel = [UILabel createLabelWithFrame:CGRectMake(GetViewMaxX(self.distanceFiled) + 10, GetViewMinY(self.distanceFiled), 20, 44)
                                               andText:@"米"
                                          andTextColor:[UIColor whiteColor]
                                            andBgColor:nil
                                               andFont:[UIFont systemFontOfSize:16]
                                      andTextAlignment:NSTextAlignmentLeft];
    
    UILabel *contactLabel = [UILabel createLabelWithFrame:CGRectMake(20, GetViewMaxY(self.distanceFiled) + 20, 120, 44)
                                                  andText:@"常用联系人"
                                             andTextColor:[UIColor whiteColor]
                                               andBgColor:nil
                                                  andFont:[UIFont systemFontOfSize:16]
                                         andTextAlignment:NSTextAlignmentLeft];
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth(self.scrollView) - 44, GetViewMinY(contactLabel), 44, 44)];
    [addButton setImage:[UIImage imageNamed:@"LocationSharedAdd"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClike) forControlEvents:UIControlEventTouchUpInside];
    UILabel *addLabel = [UILabel createLabelWithFrame:CGRectMake(GetViewMinX(addButton) - 50, GetViewMinY(contactLabel), 40, 44)
                                              andText:@"添加"
                                         andTextColor:[UIColor whiteColor]
                                           andBgColor:nil
                                              andFont:[UIFont systemFontOfSize:16]
                                     andTextAlignment:NSTextAlignmentCenter];
    
    [self.scrollView addSubview:self.titleFiled];
    [self.scrollView addSubview:self.presetView ];
    [self.scrollView addSubview:self.startSwitch];
    [self.scrollView addSubview:self.locationText];
    [self.scrollView addSubview:self.distanceFiled];
    [self.scrollView addSubview:unitLabel];
    [self.scrollView addSubview:contactLabel];
    [self.scrollView addSubview:addLabel];
    [self.scrollView addSubview:addButton];
}

- (void)initTableView{
    self.tableView                 = [[UITableView alloc]initWithFrame:CGRectMake(20, GetViewMaxY(self.distanceFiled) + 20 + 44, ViewWidth(self.titleFiled), 200)];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.scrollView addSubview:self.tableView];
    
    self.scrollView.contentSize    = CGSizeMake(0, GetViewMaxY(self.tableView) + 20);

}

- (void)setNaviBar{
    _weekSelf(weakSelf);
    self.title = @"创建位置共享";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"GoBack"] selectBlock:^{
        [weakSelf popGoBack];
    }];
    UIButton *sumitButton      = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [sumitButton setImage:[UIImage imageNamed:@"CheckSuccess"] forState:UIControlStateNormal];
    [sumitButton addTarget:self action:@selector(sumitButtonClike) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sumitItem = [[UIBarButtonItem alloc]initWithCustomView:sumitButton];
    self.navigationItem.rightBarButtonItem = sumitItem;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LocationSharedListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[LocationSharedListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ContactInfo *contactInfo  = self.contacts[indexPath.row];
    for (NSString *phone in self.allSeletedPhones) {
        if ([phone isEqualToString:contactInfo.phone]) { //已经打勾了
            contactInfo.isSelected = YES;
            if (![self.selectedContacts containsObject:contactInfo]) {
                [self.selectedContacts addObject:contactInfo];
            }
        }
    }
    
    [cell configCellDataWithModel:contactInfo];
    
    _weekSelf(weakSelf);
    cell.cellSelectBlock = ^(UIButton *sender){//选择按钮block
        if (contactInfo.isSelected) { //已经包含
            [weakSelf.allSeletedPhones removeObject:contactInfo.phone];
            [weakSelf.selectedContacts removeObject:contactInfo];
            contactInfo.isSelected = NO;
        }else {
            [weakSelf.allSeletedPhones addObject:contactInfo.phone];
            [weakSelf.selectedContacts addObject:contactInfo];
            contactInfo.isSelected = YES;
        }
        [weakSelf.tableView reloadData];
    };
    
    cell.editSharedBlock = ^(UIButton *sender){//编辑按钮block
        if (weakSelf.contacts) {
            EditLinkPersonVC *editVC     = [[EditLinkPersonVC alloc]init];
            editVC.contactInfo           = weakSelf.contacts[indexPath.row];
            
            editVC.reGetContactBlock = ^(void){
                [weakSelf getContactList];
            };
            [weakSelf.navigationController pushViewController:editVC animated:YES];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//获取常用联系人列表
- (void)getContactList{
    NSString *path = [APP_BASEURL stringByAppendingString:@"/zhihuiqichen/contact/listcontactpost"];
    NSDictionary *params = @{@"token"    :self.currentLoginUser.token,
                             @"pageNo"   :@(_pageNo),
                             @"pageSize" :@(_pageSize),
                             @"orderBy"  :@"name"
                             };
    [[NetAPIManager sharedManager]request_common_WithPath:path Params:params succesBlack:^(id data) {
        if (data) {
            [_contacts removeAllObjects];
        }
        [MTLJSONAdapter modelOfClass:[RPContactModel class] fromJSONDictionary:data error:nil];
        [_contacts addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[ContactInfo class] fromJSONArray:data[@"contacts"] error:nil]];
        [_tableView reloadData];
    } failue:^(id data, NSError *error) {
        
    }];
}


#pragma mark - buttonClike
- (void)sumitButtonClike{
    //创建位置共享 / 修改位置共享
    NSNumber *locationshareid = nil;
    if (self.shareModel) {
        locationshareid = self.shareModel.locationshareid;
    }else{
        locationshareid = nil;
    }
    RQCreateLocationSharedModel *createShareModel = [[RQCreateLocationSharedModel alloc]init];
    createShareModel.token           = self.currentLoginUser.token;
    createShareModel.title           = self.titleFiled.text;
    createShareModel.presetMsg       = self.presetView.textFile.text;
    createShareModel.msg             = self.locationText.text;
    createShareModel.distance        = @([self.distanceFiled.text integerValue]);
    NSMutableArray *contacts = [NSMutableArray array];
    for (ContactInfo *model in self.selectedContacts) {
        ContactModel *contactModel = [[ContactModel alloc] init];
        contactModel.address = model.address;
        contactModel.phone = model.phone;
        contactModel.name = model.name;
        [contacts addObject:contactModel];
    }
    
    createShareModel.contacts        = contacts;
    createShareModel.presetMsgSwitch = @(self.startSwitch.isOn == YES ? 1 : 0);
    createShareModel.locationshareid = locationshareid;
    
    if ([createShareModel checkParams]) {
        [MBProgressHUD showInfoHudTipStr:[createShareModel checkParams]];
        return;
    }
    _weekSelf(weakSelf);
   [[NetAPIManager sharedManager]request_CreateLocationShared_WithParams:createShareModel succesBlack:^(id data) {
       if (data) {
           if (_reGetDataBlock) {
               _reGetDataBlock();
           }
           [weakSelf.navigationController popViewControllerAnimated:YES];
       }else{
           [MBProgressHUD showInfoHudTipStr:data[@"msg"]];
       }
       
   } failure:^(id data, NSError *error) {
       [MBProgressHUD showError:error];
   }];
    
}

- (void)addButtonClike{
    EditLinkPersonVC *editLinkVC = [[EditLinkPersonVC alloc]init];
    editLinkVC.checkBlock = ^(ContactInfo *contact){
        if (contact != nil && ![_contacts containsObject:contact]) {
            [_contacts insertObject:contact atIndex:0];
            [_tableView reloadData];
            [_contacts replaceObjectAtIndex:[_contacts indexOfObject:contact] withObject:contact];
            
        }
    };
    _weekSelf(weakSelf);
    editLinkVC.reGetContactBlock = ^(void){
        [weakSelf getContactList];
    };
    [self.navigationController pushViewController:editLinkVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
