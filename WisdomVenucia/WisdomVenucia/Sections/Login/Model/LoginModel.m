//
//  LoginModel.m
//  PaperSource
//
//  Created by Yhoon on 15/10/23.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "LoginModel.h"
#import "AppDelegate.h"
#import "BTManager.h"
#import "LocationManager.h"

//@interface LoginModel ()
//
//@property (nonatomic, strong) UserModel *curLoginUser; // 当前登录用户模型
//
//@end

static UserModel *curLoginUser; // 当前登录用户模型

@implementation LoginModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"username":@"username",
             @"password":@"password",
             };
}

// 验证是否登录
+ (BOOL)isLogin {
    BOOL loginState = DEFAULTS_GET_BOOL(mLOGINSTATE);
    if (loginState) {
        return YES;
    }else {
        return NO;
    }
}

// 登录成功是数据本地保存操作
+ (void)doLogin:(NSDictionary *)loginUserDict {
    if (loginUserDict) {
        DEFAULTS_SET_OBJ(loginUserDict, mLOGINUSERDICT);
        DEFAULTS_SET_BOOL(YES, mLOGINSTATE);
        DEFAULTS_SAVE;
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
        NSDictionary *dict = @{
                               @"token": loginUserDict[@"token"],
                               @"t":@(2)
                               };
        
        [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE__UserInfo Params:dict succesBlack:^(id data) {
            NSDictionary *userInfo = data[@"userInfo"];
            NSMutableArray *array = [NSMutableArray arrayWithArray:DEFAULTS_GET_OBJ(mLOGINUSERLIST)];
            if (array) {
                BOOL isExisted = NO;
                for (NSString *name in array) {
                    if ([name isEqualToString:userInfo[@"username"]]) {
                        isExisted = YES;
                        break;
                    }
                }
                if (!isExisted) {
                    [array addObject:[userInfo[@"username"] copy]];
                }
            }else{
                array = [[NSMutableArray alloc] initWithObjects:userInfo[@"username"], nil];
            }
            DEFAULTS_SET_OBJ(array, mLOGINUSERLIST);
            DEFAULTS_SET_OBJ(userInfo, mLOGINUSERINFO);
            DEFAULTS_SAVE;
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeftVC object:nil];
        } failue:^(id data, NSError *error) {
            
        }];
        
    }else {
        [LoginModel doLoginOut];
    }
}

// 退出登录时数据处理操作
+ (void)doLoginOut {
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0; // 退出登录后把app红点提示消除
    // 清空用户数据
    curLoginUser = nil;
    if (isManageInited) {
        [[BTManager sharedManager] cleanConnect];
    }
    
    DEFAULTS_SET_BOOL(NO, mLOGINSTATE);
    DEFAULTS_REMOVE(mLOGINUSERDICT);
    DEFAULTS_REMOVE(mLOGINUSERINFO);
    DEFAULTS_REMOVE(mCARINFOID);
    DEFAULTS_REMOVE(mUnLook);
    DEFAULTS_SAVE;
    
    //结束后台定位
    [[LocationManager sharedManager]stopLocation];
    DEFAULTS_REMOVE(@"row");
    
}


// 获取当前登录用户模型
+ (UserModel *)curLoginUser {
    if (!curLoginUser) {
        NSDictionary *curloginUserDict = DEFAULTS_GET_OBJ(mLOGINUSERDICT);
        curLoginUser = curloginUserDict ? [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:curloginUserDict error:nil] : nil;
    }
    return curLoginUser;
}

//- (void)setPassword:(NSString *)password {
//    _password = [NSString getMd5_32BitLower:password]; // MD5加密密码
//}

@end
