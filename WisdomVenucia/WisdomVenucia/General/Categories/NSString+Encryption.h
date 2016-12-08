//
//  NSString+Encryption.h
//  PaperSource
//
//  Created by Yhoon on 15/10/26.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encryption)

// MD5加密(32位小写)
+ (NSString *)getMd5_32BitLower:(NSString *)input;

@end
