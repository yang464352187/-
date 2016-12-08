//
//  BaseModel.m
//  PaperSource
//
//  Created by Yhoon on 15/10/23.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"token":@"token",
             };
}

@end
