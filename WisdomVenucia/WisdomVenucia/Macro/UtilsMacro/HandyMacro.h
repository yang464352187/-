//
//  HandyMacro.h
//  PaperSource
//
//  Created by Yhoon on 15/10/14.
//  Copyright © 2015年 yhoon. All rights reserved.
//
//  常用的IOS开发宏


#ifndef HandyMacro_h
#define HandyMacro_h

#pragma mark - Color Macro
// 颜色
#define RGBCOLOR(r,g,b)                     [UIColor colorWithRed:r green:g blue:b alpha:1]
#define RGBACOLOR(r,g,b,a)                  [UIColor colorWithRed:r green:g blue:b alpha:a]
#define HEXCOLOR(c)                         [UIColor colorWithRed:((c>>16)&0xFF)/255.0f green:((c>>8)&0xFF)/255.0f blue:(c&0xFF)/255.0f alpha:1.0f]
#define HSVCOLOR(h,s,v)                     [UIColor colorWithHue:h saturation:s value:v alpha:1]
#define HSVACOLOR(h,s,v,a)                  [UIColor colorWithHue:h saturation:s value:v alpha:a]
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

/******************************************************************************/

#pragma mark - Funtion Method (宏方法)

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)            [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)                [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)                [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)                                        \
                                                                                            \
                                                    [View.layer setCornerRadius:(Radius)];  \
                                                    [View.layer setMasksToBounds:YES];      \
                                                    [View.layer setBorderWidth:(Width)];    \
                                                    [View.layer setBorderColor:[Color CGColor]]

#define ViewBorder(View, Width, Color)                                      \
                                                                            \
                                        [View.layer setBorderWidth:(Width)];\
                                        [View.layer setBorderColor:[Color CGColor]]


// View 圆角
#define ViewRadius(View, Radius)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES]


#pragma mark - Singletion(单例)

#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)                       \
                                                       \
+ (classname *)sharedInstance##classname {             \
                                                       \
    static dispatch_once_t oncePredicate;              \
    static classname * sharedInstance##classname = nil;\
    dispatch_once( &oncePredicate, ^{                  \
    sharedInstance##classname = [[self alloc] init];   \
    });                                                \
                                                       \
    return sharedInstance##classname;                  \
}
#endif


#endif /* HandyMacro_h */
