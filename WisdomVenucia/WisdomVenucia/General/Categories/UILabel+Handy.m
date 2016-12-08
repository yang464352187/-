//
//  UILabel+Handy.m
//  PaperSource
//
//  Created by Yhoon on 15/10/21.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "UILabel+Handy.h"

@implementation UILabel (Handy)

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                          andText:(NSString *)text
                     andTextColor:(UIColor*)textColor
                       andBgColor:(UIColor*)bgColor
                 andTextAlignment:(NSTextAlignment)textAlignment {
    UILabel *label        = [[UILabel alloc] initWithFrame:frame];
    label.text            = text;
    label.frame           = frame;
    label.textColor       = textColor;
    label.backgroundColor = bgColor;
    label.textAlignment   = textAlignment;
    
    return label;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                          andText:(NSString *)text
                     andTextColor:(UIColor*)textColor
                       andBgColor:(UIColor*)bgColor
                          andFont:(UIFont *)font
                 andTextAlignment:(NSTextAlignment)textAlignment {
    UILabel *label        = [[UILabel alloc] initWithFrame:frame];
    label.text            = text;
    label.frame           = frame;
    label.font            = font;
    label.textColor       = textColor;
    label.backgroundColor = bgColor;
    label.textAlignment   = textAlignment;
    
    return label;
}

@end
