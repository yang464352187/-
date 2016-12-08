//
//  CustomAnnotationView.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/24.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"

@interface CustomAnnotationView()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CustomAnnotationView

- (void)setImage:(UIImage *)image{
    if (image) {
        self.imageView.image = image;
    }
}

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.imageView];
}

@end
