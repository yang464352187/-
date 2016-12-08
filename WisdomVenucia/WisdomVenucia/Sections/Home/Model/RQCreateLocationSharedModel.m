//
//  RQCreateLocationSharedModel.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/26.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "RQCreateLocationSharedModel.h"

@implementation RQCreateLocationSharedModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"token"          :@"token",
             @"title"          :@"title",
             @"presetMsg"      :@"presetMsg",
             @"msg"            :@"msg",
             @"presetMsgSwitch":@"presetMsgSwitch",
             @"distance"       :@"distance",
             @"contacts"       :@"contacts",
             @"locationshareid":@"locationshareid",
             };
}

+ (NSValueTransformer *)contactsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ContactModel class] ];
}

- (NSString *)checkParams{
    if (!self.title || self.title.length < 4) {
        return @"主题不能少于4个字符";
    }else if (!self.presetMsg || self.presetMsg.length <= 0){
        return @"请输入启动预设消息";
    }else if (!self.msg || self.msg.length <= 0){
        return @"请输入预设消息";
    }else if (!self.distance || [self.distance floatValue] == 0){
        return @"请输入预设距离";
    }else if (!self.contacts || self.contacts.count == 0){
        return @"请选择联系人";
    }
    return nil;
}

@end


@implementation ContactModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"name"   : @"name",
             @"phone"  : @"phone",
             @"address": @"address",
             };

}

- (NSString *)checkParams{
    if (!self.name || self.name.length <= 0) {
        return @"请输入姓名";
    }else if (![self checkTel:self.phone]){
        return @"联系电话输入有误";
    }else if (!self.address || self.address.length <= 0){
        return @"请选择联系人地址";
    }
    return nil;
}

- (BOOL)checkTel:(NSString *)str

{
    
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"data_null_prompt", nil) message:NSLocalizedString(@"tel_no_null", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        return NO;
        
    }
    
    
    
    return YES;
    
}


@end