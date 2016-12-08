//
//  AddRescuManView.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 16/7/7.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRescuManView : UIView

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, copy) void(^buttonClickedBlock)(NSInteger,NSString *, NSString *);

- (void)showAddRescuManView;

- (void)hideRescuManView;

@end
