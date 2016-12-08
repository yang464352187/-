//
//  NSString+Handy.m
//  PaperSource
//
//  Created by Yhoon on 15/10/22.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "NSString+Handy.h"

@implementation NSString (Handy)

// 动态计算文本宽度
+ (CGFloat)widthWithText:(NSString *)text andFontSize:(CGFloat)fontSize{
    CGRect rect =
    [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                       context:nil];
    return rect.size.width;
}

// 动态计算文本高度
+ (CGFloat)heightWithText:(NSString *)text andFontSize:(CGFloat)fontSize{
    CGRect rect =
    [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT)
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                       context:nil];
    return rect.size.height;
}

+ (NSString *)dictionaryToJsonString:(NSDictionary *)dict {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
