//
//  PathReShowCell.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSharedListModel.h"

@interface PathReShowCell : UITableViewCell

- (CGFloat)getCellHeight;

- (void)configCellDataWithModel:(LocationShareModel *)model;

@end
