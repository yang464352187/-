//
//  TyreStateView.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/10.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TyreStateView : UIImageView


/**
 * @gram frame         frame
 * @gram state         状态值
 * @gram Temperature   温度
 * @gram title         位置名称
 * @gram place         1为左边 2为右边
 **/

- (instancetype)initWithFrame:(CGRect)frame State:(CGFloat)state Temperature:(CGFloat)temperature Title:(NSString *)title place:(NSInteger)place;

@property (strong, nonatomic) UILabel *state;
@property (strong, nonatomic) UILabel *temperature;
@property (assign, nonatomic) BOOL    isnormal;

- (void)setStateText:(CGFloat)state;
- (void)setTemperatureText:(NSInteger)temperature;

@end
