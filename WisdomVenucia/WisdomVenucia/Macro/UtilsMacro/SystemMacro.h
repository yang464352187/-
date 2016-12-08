//
//  SystemMacro.h
//  PaperSource
//
//  Created by Yhoon on 15/10/14.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#ifndef SystemMacro_h
#define SystemMacro_h

// 系统方法
#define App_Delegate                        AppDelegate
#define APPLICATIONDELEGATE                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define USERDEFAULTS                        [NSUserDefaults standardUserDefaults]
#define NOTIFICATIONCENTER                  [NSNotificationCenter defaultCenter]
#define SharedApplication                   [UIApplication sharedApplication]
#define BUNDLE                              [NSBundle mainBundle]
#define MAINSCREEN                          [UIScreen mainScreen]
#define NAVBAR                              self.navigationController.navigationBar
#define TABBAR                              self.tabBarController.tabBar

// 系统版本
#define IsIOS6Later ([[[UIDevice currentDevice] systemVersion] floatValue] >=6.0 ? YES : NO)
#define IsIOS7Later ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES : NO)
#define IsIOS8Later ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0 ? YES : NO)
#define SUPPORT_IPHONE_OS_VERSION(version) ( __IPHONE_OS_VERSION_MIN_REQUIRED <= version && __IPHONE_OS_VERSION_MAX_ALLOWED >= version)

// 设置Debug模式下打印log,release模式下不打印
#ifdef DEBUG
#	define DebugLog(format, ...)   NSLog((@"[DEBUG]%s " format), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#	define DebugLog(...)
#endif

#define TipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#endif /* SystemMacro_h */
