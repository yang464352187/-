//
//  RegisterModel.m
//  PaperSource
//
//  Created by Yhoon on 15/11/12.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "RegisterModel.h"

@implementation RegisterModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"username":@"username",
             @"password":@"password",
             };
}

@end
