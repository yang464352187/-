//
//  LoginModel.h
//  PaperSource
//
//  Created by Yhoon on 15/10/23.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface LoginModel : BaseModel

@property (nonatomic, copy) NSString *username, *password;

//@property (nonatomic, assign) BOOL status; // 登陆状态(已登录:YES,未登录:NO)

+ (BOOL)isLogin;
+ (void)doLogin:(NSDictionary *)loginData;
+ (void)doLoginOut;

+ (UserModel *)curLoginUser;

@end
