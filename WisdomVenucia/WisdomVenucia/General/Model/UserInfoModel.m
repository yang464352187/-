//
//  UserInfoModel.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"token":@"token",
             @"username": @"username",
             @"nickname": @"nickname",
             @"birthday": @"birthday",
             @"introduction": @"introduction",
             @"sex": @"sex",
             @"address":@"address",
             @"avatar": @"avatar"
             };
}

@end
