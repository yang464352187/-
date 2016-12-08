//
//  NSObject+ProgressHUD.h
//  PaperSource
//
//  Created by Yhoon on 15/10/16.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ProgressHUD)

+ (NSString *)tipFromError:(NSError *)error;
+ (void)showError:(NSError *)error;
+ (void)showHudTipStr:(NSString *)tipStr;
+ (void)showSuccessHudTipStr:(NSString *)tipStr;
+ (void)showInfoHudTipStr:(NSString *)tipStr;


-(id)handleResponse:(id)responseJSON;
-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError;

@end
