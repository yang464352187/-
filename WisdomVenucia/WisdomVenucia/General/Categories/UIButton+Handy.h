//
//  UIButton+Handy.h
//  PaperSource
//
//  Created by Yhoon on 15/10/23.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Handy)

+ (UIButton *)createButtonWithButtonType:(UIButtonType)buttonType
                                andFrame:(CGRect)frame
                                andTitle:(NSString *)title
                           andTitleColor:(UIColor *)titleColor;


+ (UIButton *)createButtonWithButtonType:(UIButtonType)buttonType
                                andFrame:(CGRect)frame
                                andTitle:(NSString *)title
                           andTitleColor:(UIColor *)titleColor
                      andBackgroundColor:(UIColor *)backgroundColor;

+ (UIButton *)createButtonWithButtonType:(UIButtonType)buttonType
                                andFrame:(CGRect)frame
                                andTitle:(NSString *)title
                                 andFont:(UIFont *)font
                           andTitleColor:(UIColor *)titleColor
                      andBackgroundColor:(UIColor *)backgroundColor;

/**
 *  设置Button具有image和title
 *
 *  @param image     图片
 *  @param title     title
 *  @param stateType 类型
 */
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;

/**
 *  设置Button具有Backgroundimage和title
 *
 *  @param image            背景图片
 *  @param selecetImage     选择后的背景图片
 *  @param title            title
 */
- (void) setImage:(UIImage *)image selecetImage:(UIImage *)image_sel withTitle:(NSString *)title;

@end
