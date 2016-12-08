//
//  ModifyUserInfoModel.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/4.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "ModifyUserInfoModel.h"

@implementation ModifyUserInfoModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"token":@"token",
             @"username": @"username",
             @"nickname": @"nickname",
             @"birthday": @"birthday",
             @"introduction": @"introduction",
             @"sex": @"sex",
             @"address":@"address"
             };
}

@end
