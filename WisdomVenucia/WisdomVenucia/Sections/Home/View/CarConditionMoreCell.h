//
//  CarConditionMoreCell.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/19.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarConditionMoreCell : UICollectionViewCell

@property (strong , nonatomic) UILabel     *titleLabel;

@property (strong , nonatomic) UILabel     *valueLabel;

@property (strong , nonatomic) UIImageView *imageView;

- (void)setImage:(UIImage *)image;

@end
