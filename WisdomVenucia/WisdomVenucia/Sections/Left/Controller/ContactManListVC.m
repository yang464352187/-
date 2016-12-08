//
//  ContactManListVC.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/26.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "ContactManListVC.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "RPContactModel.h"
#import "EditLinkPersonVC.h"
#import "ChineseString.h"

@interface ContactManListVC ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, ABPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate,UISearchBarDelegate>

{
    NSInteger _pageNo;  //第几页
    NSInteger _pageSize;//每页几条
}

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) UISearchBar    *searchBar;

@property (nonatomic, strong) NSMutableArray *listContacts;

@property (nonatomic,retain) NSMutableArray *indexArray;

@end

@implementation ContactManListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setNaviBar];
//    [self initSearchBar];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)initData{
    self.listContacts    = [NSMutableArray array];
    self.indexArray      = [NSMutableArray array];
    
    _pageNo = 1;
    _pageSize = 10;
    
}

- (void)setNaviBar{
    _weekSelf(weakSelf);
    self.title = @"常用联系人";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"GoBack"] selectBlock:^{
        [weakSelf popGoBack];
    }];
    UIButton *addLinkPersonButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [addLinkPersonButton setImage:[UIImage imageNamed:@"LocationSharedAdd"] forState:UIControlStateNormal];
    [addLinkPersonButton addTarget:self action:@selector(addLinkPersonButtonClike) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:addLinkPersonButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)initSearchBar{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, ViewWidth(self.view), 44)];
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.searchBar];
}

- (void)initTableView{
    self.tableView                 = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                                  64,
                                                                                  ViewWidth(self.view),
                                                                                  ViewHeight(self.view) - 64)
                                                                 style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    MJRefreshFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    self.tableView.header = header;
    self.tableView.footer = footer;
    
    [self.tableView.header beginRefreshing];
}

#pragma mark -RefreshAction
- (void)headerRefreshAction{
    _pageNo = 1;
    [self getContactList];
}

- (void)footerRefreshAction{
    _pageNo += 1;
    [self getContactList];
}

- (void)stopRefresh{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyCell"];
    }
    ContactInfo *contactInfo       = self.listContacts[indexPath.row];
    cell.textLabel.text            = contactInfo.name;
    cell.detailTextLabel.text      = contactInfo.phone;
    cell.backgroundColor           = [UIColor clearColor];
    cell.textLabel.textColor       = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.listContacts) {
        EditLinkPersonVC *editVC     = [[EditLinkPersonVC alloc]init];
        editVC.contactInfo = self.listContacts[indexPath.row];
        _weekSelf(weakSelf);
        editVC.reGetContactBlock = ^(void){
            [weakSelf.tableView.header beginRefreshing]; //重新获取数据
        };
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactInfo *contact = self.listContacts[indexPath.row];
    [self.listContacts removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self deleteContact:contact.contactid];
    
}

#pragma mark - httpRequest
//获取常用联系人列表
- (void)getContactList{
    NSString *path = [APP_BASEURL stringByAppendingString:@"/zhihuiqichen/contact/listcontactpost"];
    NSDictionary *params = @{@"token"    :self.currentLoginUser.token,
                             @"pageNo"   :@(_pageNo),
                             @"pageSize" :@(_pageSize),
                             @"orderBy"  :@"name"
                             };
    _weekSelf(weakSelf);
    [[NetAPIManager sharedManager]request_common_WithPath:path Params:params succesBlack:^(id data) {
        if (data) {
            [_listContacts removeAllObjects];
            [MTLJSONAdapter modelOfClass:[RPContactModel class] fromJSONDictionary:data error:nil];
            [_listContacts addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[ContactInfo class] fromJSONArray:data[@"contacts"] error:nil]];
            [_tableView reloadData];
            [weakSelf stopRefresh];
        }
    } failue:^(id data, NSError *error) {
        [weakSelf stopRefresh];
    }];
}

//删除常用联系人
- (void)deleteContact:(NSNumber *)contactid{
    NSString *path       = [APP_BASEURL stringByAppendingString:@"/zhihuiqichen/contact/delcontactpost"];
    NSDictionary *params = @{@"token"     : self.currentLoginUser.token,
                             @"contactid" : contactid,
                             };
    [[NetAPIManager sharedManager]request_common_WithPath:path Params:params succesBlack:^(id data) {
        if ([data[@"code"]integerValue] == 1) {
            [MBProgressHUD showSuccessHudTipStr:@"删除成功"];
        }else{
            [MBProgressHUD showError:data[@"msg"]];
        }
    } failue:^(id data, NSError *error) {
        
    }];
}

//添加常用联系人
- (void)addContactWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address{
    _weekSelf(weakSelf);
    NSString *path = [APP_BASEURL stringByAppendingString:@"/zhihuiqichen/contact/setcontactpost"];
    NSDictionary *params = @{@"token"   : self.currentLoginUser.token,
                             @"name"    : name,
                             @"phone"   : phone,
                             @"address" : address,
                             };
    [[NetAPIManager sharedManager]request_common_WithPath:path Params:params succesBlack:^(id data) {
        if ([data[@"code"]integerValue] == 1) {
            [weakSelf getContactList];
            [MBProgressHUD showSuccessHudTipStr:@"添加成功"];
        }else{
            [MBProgressHUD showError:data[@"msg"]];
        }
    } failue:^(id data, NSError *error) {
        
    }];
    
}


//联系人分组
- (void)filterContactName{
    
}

#pragma mark - AddButtonClike
- (void)addLinkPersonButtonClike{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请选择" message:@"选择导入联系人" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从通讯录添加",@"创建联系人", nil];
    [alertView show];

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self accessTheAddress]; //授权
    }else if (buttonIndex == 2){
        EditLinkPersonVC *editVC = [[EditLinkPersonVC alloc]init];
        _weekSelf(weakSelf);
        editVC.reGetContactBlock = ^(void){
            [weakSelf getContactList]; //重新获取数据
        };
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person{
    NSString *name = CFBridgingRelease(ABRecordCopyCompositeName(person));
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSMutableString *phone = (__bridge NSMutableString*)ABMultiValueCopyValueAtIndex(phoneMulti, 0);
    NSArray *strings = [phone componentsSeparatedByString:@"-"];
//    NSLog(@">>>>>>>>%@",name);
//    NSLog(@">>>>>>>>%@",phone);
    if (strings.count == 3) {
        phone = [[NSString stringWithFormat:@"%@%@%@",strings[0],strings[1],strings[2]]mutableCopy];
    }
//    NSLog(@">>>>>>>>%@",name);
//    NSLog(@">>>>>>>>%@",phone);
    [self addContactWithName:name phone:phone address:@"厦门"];
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

//通讯录授权
- (void)accessTheAddress
{
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    __block BOOL accessGranted = NO;
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // ios6之后
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
            //此处访问通讯录
            ABPeoplePickerNavigationController *pickerNavigationController  = [[ABPeoplePickerNavigationController alloc] init];
            pickerNavigationController.peoplePickerDelegate = self;
            [self presentViewController:pickerNavigationController animated:YES completion:nil];
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { //ios6及之前版本
        accessGranted = YES;
    }
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
    
}

@end
