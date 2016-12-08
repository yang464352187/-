//
//  NSObject+ProgressHUD.m
//  PaperSource
//
//  Created by Yhoon on 15/10/16.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "NSObject+ProgressHUD.h"
#import "AppDelegate.h"
#import "LoginModel.h"

@implementation NSObject (ProgressHUD)

//+ (NSString *)tipFromError:(NSError *)error{
//    if (error && error.userInfo) {
//        NSMutableString *tipStr = [[NSMutableString alloc] init];
//        if ([error.userInfo objectForKey:@"msg"]) {
//            NSArray *msgArray = [[error.userInfo objectForKey:@"msg"] allValues];
//            NSUInteger num = [msgArray count];
//            for (int i = 0; i < num; i++) {
//                NSString *msgStr = [msgArray objectAtIndex:i];
//                if (i+1 < num) {
//                    [tipStr appendString:[NSString stringWithFormat:@"%@\n", msgStr]];
//                }else{
//                    [tipStr appendString:msgStr];
//                }
//            }
//        }else{
//            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
//                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
//            }else{
//                [tipStr appendFormat:@"ErrorCode = %ld", (long)error.code];
//            }
//        }
//        return tipStr;
//    }
//    return nil;
//}

+ (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if (error.userInfo[@"codeInfo"]) {
            [tipStr appendString:error.userInfo[@"codeInfo"]];
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode = %ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}

+ (void)showError:(NSError *)error{
    NSString *tipStr = [NSObject tipFromError:error];
    [NSObject showHudTipStr:tipStr];
}

+ (void)showSuccessHudTipStr:(NSString *)tipStr {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] ];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor] ];
    [SVProgressHUD showSuccessWithStatus:tipStr maskType:SVProgressHUDMaskTypeClear];
}

+ (void)showInfoHudTipStr:(NSString *)tipStr {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] ];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor] ];
    [SVProgressHUD showInfoWithStatus:tipStr maskType:SVProgressHUDMaskTypeClear];
}

+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }
}

#pragma mark - NetError
- (id)handleResponse:(id)responseJSON {
    return [self handleResponse:responseJSON autoShowError:YES];
}

// 处理错误提示信息
- (id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;
    //TODO:code为非1值时，表示有错
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
    
    if (resultCode.integerValue != 1) {
        error = [NSError errorWithDomain:@"" code:resultCode.integerValue userInfo:responseJSON];
        [MBProgressHUD showHudTipStr:responseJSON[@"msg"]];
        if (resultCode.integerValue == 911) {
            // TODO:登录超时或未登录提示信息
            
            [MBProgressHUD showHudTipStr:@"登录超时，请重新登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LoginModel doLoginOut];
                [[RootViewController sharedRootVC] ChangeRootVC];
            });
            
        }
    }
    return error;
}



@end
