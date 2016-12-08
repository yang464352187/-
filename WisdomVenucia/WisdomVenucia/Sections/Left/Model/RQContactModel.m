//
//  RQContactModel.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/12/7.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "RQContactModel.h"

@implementation RQContactModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"token"     : @"token",
             @"name"      : @"name",
             @"phone"     : @"phone",
             @"address"   : @"address",
             @"contactid" : @"contactid",
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
