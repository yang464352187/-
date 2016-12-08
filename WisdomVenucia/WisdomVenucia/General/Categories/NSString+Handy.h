//
//  NSString+Handy.h
//  PaperSource
//
//  Created by Yhoon on 15/10/22.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Handy)

// 动态计算文本宽度;
+ (CGFloat)widthWithText:(NSString *)text andFontSize:(CGFloat)fontSize;
// 动态计算文本高度;
+ (CGFloat)heightWithText:(NSString *)text andFontSize:(CGFloat)fontSize;

// 字典转json字符串
+ (NSString *)dictionaryToJsonString:(NSDictionary *)dict;

@end
