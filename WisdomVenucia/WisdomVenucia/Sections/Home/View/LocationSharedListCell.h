//
//  LocationSharedListCell.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/29.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPContactModel.h"

@interface LocationSharedListCell : UITableViewCell

@property (nonatomic, copy) void(^cellSelectBlock)(UIButton *sender);

@property (nonatomic, copy) void(^editSharedBlock)(UIButton *sender);

- (void)configCellDataWithModel:(ContactInfo *)model;

- (CGFloat)getCellHeight;

@end
