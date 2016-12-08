//
//  CarConditionMoreCell.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/19.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "CarConditionMoreCell.h"

@implementation CarConditionMoreCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:VIEWFRAME(4, 4, 100, 20)];
        self.titleLabel.font = SYSTEMFONT(14);
        self.titleLabel.textColor = RGBCOLOR(0.37, 0.37, 0.37);
        [self addSubview:self.titleLabel];
        
        self.imageView = [[UIImageView alloc] init];
        
        [self addSubview:self.imageView];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:VIEWFRAME(0, frame.size.height - 30, frame.size.width, 20)];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        self.valueLabel.font = SYSTEMFONT(14);
        self.valueLabel.textColor = RGBCOLOR(0.37, 0.37, 0.37);
        [self addSubview:self.valueLabel];
        
        //分割线
        UIView *cut1 = [[UIView alloc] initWithFrame:VIEWFRAME(frame.size.width-0.5, 0, 0.5, frame.size.height-0.5)];
        cut1.backgroundColor = HEXCOLOR(0x999999);
        [self addSubview:cut1];
        
        UIView *cut2 = [[UIView alloc] initWithFrame:VIEWFRAME(0, frame.size.height-0.5, frame.size.width, 0.5)];
        cut2.backgroundColor = HEXCOLOR(0x999999);
        [self addSubview:cut2];

    }

    return self;
}

- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
    self.imageView.frame = VIEWFRAME(self.frame.size.width/2-image.size.width/2, self.frame.size.height/2-image.size.height/2, image.size.width, image.size.height);
   // self.imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
}

@end
