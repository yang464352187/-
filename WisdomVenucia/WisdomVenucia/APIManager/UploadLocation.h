//
//  UploadLocation.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 16/7/13.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSharedListModel.h"

@interface UploadLocation : NSObject

@property (nonatomic, strong) LocationShareModel *selectShareMode; //选中的事件，用于距离计算

+ (instancetype)sharedManager;

- (void)uploadLocationWithSharedid:(NSNumber *)locationshareid lat:(float)lat lng:(float)lng;

- (void)sendPresetMsg;

- (void)sendLocationShareMsg;

@end
