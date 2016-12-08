//
//  BlueToothCell.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/23.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueToothCell : UITableViewCell


@property (strong, nonatomic) UILabel     *name;
@property (strong, nonatomic) UILabel     *state;
@property (strong, nonatomic) UIImageView *imageLogo;
- (void)setImageAndFrame:(UIImage *)image;
@end
