//
//  RescuListCell.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 16/7/7.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RescuListCell : UITableViewCell

@property (nonatomic, copy) void(^controlSwitchBlock)(void);

- (void)configCellData:(id)data;

@end
