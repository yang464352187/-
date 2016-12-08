//
//  LocationSharedCell.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/30.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSharedListModel.h"

@interface LocationSharedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *uploadLocationSwitch;

@property (nonatomic, copy) void(^uploadLocationBlock)(UISwitch *sender);

- (void)configCellDataWithModel:(LocationShareModel *)model;

- (CGFloat)getCellHeight;

@end
