//
//  SliderView.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/3.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SliderTypeSSD,
    SliderTypeHSD,
    SliderTypePSI,
    SliderTypeKPA,
    SliderTypeBAR,
} SliderType;

@interface SliderView : UIView

@property (strong, nonatomic) UISlider     *slier;
@property (strong, nonatomic) UILabel      *minLabel;
@property (strong, nonatomic) UILabel      *maxLabel;
@property (strong, nonatomic) UILabel      *valueLabel;
@property (strong, nonatomic) NSDictionary *valueDic;
@property (strong, nonatomic) NSString     *unitStr;
@property (assign, nonatomic) SliderType   sliderType;

@end
