//
//  RPSharedListModel.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/29.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "RPSharedListModel.h"

@implementation RPSharedListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{

   return @{@"code"           : @"code",
            @"total"          : @"total",
            @"pageSize"       : @"pageSize",
            @"pageNo"         : @"pageNo",
            @"locationShares" : @"locationShares",
            };
}

+ (NSValueTransformer *)locationSharesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[LocationShareModel class] ];
}


@end

@implementation LocationShareModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"uid"              : @"uid",
             @"distance"         : @"distance",
             @"presetMsg"        : @"presetMsg",
             @"title"            : @"title",
             @"contacts"         : @"contacts",
             @"track"            : @"track",
             @"msg"              : @"msg",
             @"createtime"       : @"createtime",
             @"presetMsgSwitch"  : @"presetMsgSwitch",
             @"locationshareid"  : @"locationshareid",
             };
}

+ (NSValueTransformer *)contactsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ContactInfoModel class] ];
}

+ (NSValueTransformer *)trackJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TrackModel class] ];
}

@end

@implementation ContactInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"name"    : @"name",
             @"phone"   : @"phone",
             @"address" : @"address",
             };

}

@end

@implementation TrackModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"lat" : @"lat",
             @"lng" : @"lng",
             };

}

@end
