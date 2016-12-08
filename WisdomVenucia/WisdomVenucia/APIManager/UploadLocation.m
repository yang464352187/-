//
//  UploadLocation.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 16/7/13.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "UploadLocation.h"

@interface UploadLocation()

@property (nonatomic, copy) NSString *token;

@end

@implementation UploadLocation

+ (instancetype)sharedManager {
    static dispatch_once_t predicate;
    static id sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[UploadLocation alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccess object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotify:) name:kLoginSuccess object:nil];
    }
    return self;
}

//登录成功通知
- (void)loginSuccessNotify:(id)sender {
    //读取token
    self.token = [UserModel readCurLoginUser].token;
}

//上传经纬度
- (void)uploadLocationWithSharedid:(NSNumber *)locationshareid lat:(float)lat lng:(float)lng {
    if (!self.token) {
        return;
    }
    NSString *path       = [APP_BASEURL stringByAppendingPathComponent:@"/zhihuiqichen/trackreply/setlocationpointpost"];
    NSDictionary *params = @{@"token"           : self.token,
                             @"locationshareid" : locationshareid,
                             @"lat"             : [NSNumber numberWithFloat:lat],
                             @"lng"             : [NSNumber numberWithFloat:lng],
                             };
    [[NetAPIManager sharedManager]request_common_WithPath:path Params:params succesBlack:^(id data) {
        if ([data[@"code"]integerValue] == 1) {
            DebugLog(@"上传成功......");
        }else{
            DebugLog(@"上传失败......");
        }
    } failue:^(id data, NSError *error) {
        [MBProgressHUD showError:error];
    }];

}

//发送启动预设消息
- (void)sendPresetMsg{
    if (!self.selectShareMode) {
        [MBProgressHUD showInfoHudTipStr:@"您还未启动事件"];
        return;
    }
    if (!self.token) {
        return;
    }
    NSString *path       = @"/zhihuiqichen/sendmsg/sendpresetmsgpost";
    NSDictionary *params = @{@"token"           : self.token,
                             @"locationshareid" : self.selectShareMode.locationshareid,
                             };
    [[NetAPIManager sharedManager]request_common_WithPath:path Params:params succesBlack:^(id data) {
        if ([data[@"code"]integerValue] == 1) {
            [MBProgressHUD showInfoHudTipStr:@"成功发送预设消息"];
        }else {
            [MBProgressHUD showInfoHudTipStr:data[@"msg"]];
        }
    } failue:^(id data, NSError *error) {
        [MBProgressHUD showError:error];
    }];
    
}

//发送事件共享消息
- (void)sendLocationShareMsg{
    if (!self.selectShareMode) {
        [MBProgressHUD showInfoHudTipStr:@"您还未启动事件"];
        return;
    }
    if (!self.token) {
        return;
    }
    NSString *path       = @"/zhihuiqichen/sendmsg/sendmsgpost";
    NSDictionary *params = @{@"token"           : self.token,
                             @"locationshareid" : self.selectShareMode.locationshareid,
                             };
    [[NetAPIManager sharedManager]request_common_WithPath:path Params:params succesBlack:^(id data) {
        if ([data[@"code"]integerValue] == 1) {
            
        }else{
            
        }
    } failue:^(id data, NSError *error) {
        [MBProgressHUD showError:error];
    }];
}

@end
