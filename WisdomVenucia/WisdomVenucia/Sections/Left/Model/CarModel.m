//
//  CarModel.m
//  WisdomVenucia
//
//  Created by 苏凡 on 16/3/24.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"token"       :@"token",
             @"plateNumber" :@"plateNumber",
             @"vinCode"     :@"vinCode",
             @"engineCode"  :@"engineCode",
             @"model"       :@"model",
             @"modelNumber" :@"modelNumber",
             @"displacement":@"displacement",
             @"gearbox"     :@"gearbox",
             @"fuelType"    :@"fuelType",
             @"frameNumber" :@"frameNumber",
             @"deviceNumer" :@"deviceNumer",
             @"carinfoid"   :@"carinfoid",
             @"mileage"     :@"mileage",
             };
}


@end
