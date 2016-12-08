//
//  UserModel.m
//  PaperSource
//
//  Created by Yhoon on 15/10/26.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"token"    :@"token",
             @"uid"      :@"uid",
             };
}

// 读取用户数据模型
+ (UserModel *)readCurLoginUser {
    NSDictionary *userDict = DEFAULTS_GET_OBJ(mLOGINUSERDICT);
    UserModel *user = userDict ? [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:userDict error:nil] : nil;
    return user;
}

// 将用户数据写入系统本地数据库
+ (void)writeUser:(UserModel *)user {
    NSDictionary *userDict = [MTLJSONAdapter JSONDictionaryFromModel:user error:nil];
    DEFAULTS_SET_OBJ(userDict, mLOGINUSERDICT);
    DEFAULTS_SAVE;
}

@end
