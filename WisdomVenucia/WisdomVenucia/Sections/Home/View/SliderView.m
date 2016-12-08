//
//  SliderView.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/3.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "SliderView.h"

@implementation SliderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)initUI{
    self.slier = [[UISlider alloc] initWithFrame:VIEWFRAME(0, 0, self.frame.size.width, 31)];
    [self.slier setThumbImage:[UIImage imageNamed:@"TyreSetSlider"] forState:UIControlStateNormal];
    [self.slier addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.slier];
    
    self.minLabel = [UILabel createLabelWithFrame:VIEWFRAME(0, 40, self.frame.size.width, 15)
                                          andText:@"10"
                                     andTextColor:[UIColor whiteColor]
                                       andBgColor:[UIColor clearColor]
                                          andFont:[UIFont systemFontOfSize:14]
                                 andTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.minLabel];
    
    self.maxLabel = [UILabel createLabelWithFrame:VIEWFRAME(0, 40, self.frame.size.width, 15)
                                          andText:@"20"
                                     andTextColor:[UIColor whiteColor]
                                       andBgColor:[UIColor clearColor]
                                          andFont:[UIFont systemFontOfSize:14]
                                 andTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.maxLabel];
    
    self.valueLabel = [UILabel createLabelWithFrame:VIEWFRAME(0, 40, self.frame.size.width, 15)
                                          andText:@"30"
                                     andTextColor:[UIColor whiteColor]
                                       andBgColor:[UIColor clearColor]
                                          andFont:[UIFont systemFontOfSize:14]
                                 andTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.valueLabel];
    
}

- (void)sliderValueChanged:(UISlider *)slider{
    if (self.sliderType == SliderTypeSSD) {
        NSInteger min =  [self.valueDic[@"ssdmin"] integerValue];
        NSInteger max =  [self.valueDic[@"ssdmax"] integerValue];
        NSInteger value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%li%@",value,self.unitStr];
        
        
    }else if (self.sliderType == SliderTypeHSD){
        NSInteger min =  [self.valueDic[@"hsdmin"] integerValue];
        NSInteger max =  [self.valueDic[@"hsdmax"] integerValue];
        NSInteger value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%li%@",value,self.unitStr];
        
    }else if (self.sliderType == SliderTypePSI) {
        NSInteger min =  [self.valueDic[@"psimin"] integerValue];
        NSInteger max =  [self.valueDic[@"psimax"] integerValue];
        NSInteger value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%li%@",value,self.unitStr];
        
    }else if (self.sliderType == SliderTypeKPA){
        NSInteger min =  [self.valueDic[@"kpamin"] integerValue];
        NSInteger max =  [self.valueDic[@"kpamax"] integerValue];
        NSInteger value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%li%@",value,self.unitStr];
        
    }else{
        CGFloat min =  [self.valueDic[@"barmin"] floatValue];
        CGFloat max =  [self.valueDic[@"barmax"] floatValue];
        CGFloat value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f%@",value,self.unitStr];
    }
    
    
    
}

- (void)setSliderType:(SliderType)sliderType{
    _sliderType = sliderType;
    if (sliderType == SliderTypeSSD) {
        self.unitStr = @"°C";
        NSInteger min =  [self.valueDic[@"ssdmin"] integerValue];
        NSInteger max =  [self.valueDic[@"ssdmax"] integerValue];
        NSInteger value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%li%@",value,self.unitStr];
        
        self.minLabel.text = [self.valueDic[@"ssdmin"] description];
        self.maxLabel.text = [self.valueDic[@"ssdmax"] description];
        
        
    }else if (sliderType == SliderTypeHSD){
        self.unitStr = @"°F";
        NSInteger min =  [self.valueDic[@"hsdmin"] integerValue];
        NSInteger max =  [self.valueDic[@"hsdmax"] integerValue];
        NSInteger value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%li%@",value,self.unitStr];
        
        self.minLabel.text = [self.valueDic[@"hsdmin"] description];
        self.maxLabel.text = [self.valueDic[@"hsdmax"] description];
        
        
    }else if (sliderType == SliderTypePSI) {
        self.unitStr = @"psi";
        NSInteger min =  [self.valueDic[@"psimin"] integerValue];
        NSInteger max =  [self.valueDic[@"psimax"] integerValue];
        NSInteger value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%li%@",value,self.unitStr];
        
        self.minLabel.text = [self.valueDic[@"psimin"] description];
        self.maxLabel.text = [self.valueDic[@"psimax"] description];
        
        
    }else if (sliderType == SliderTypeKPA){
        self.unitStr = @"kPa";
        NSInteger min =  [self.valueDic[@"kpamin"] integerValue];
        NSInteger max =  [self.valueDic[@"kpamax"] integerValue];
        NSInteger value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%li%@",value,self.unitStr];
        
        self.minLabel.text = [self.valueDic[@"kpamin"] description];
        self.maxLabel.text = [self.valueDic[@"kpamax"] description];
        
        
    }else{
        self.unitStr = @"Bar";
        CGFloat min =  [self.valueDic[@"barmin"] floatValue];
        CGFloat max =  [self.valueDic[@"barmax"] floatValue];
        CGFloat value = min + (max - min)*self.slier.value;
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f%@",value,self.unitStr];
        
        self.minLabel.text = [self.valueDic[@"barmin"] description];
        self.maxLabel.text = [self.valueDic[@"barmax"] description];
        
    }
}




@end
