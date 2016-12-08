//
//  CustomAnnotationView.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/24.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIImage *customImage;

@property (nonatomic, strong) CustomCalloutView *customCalloutView;

@end
