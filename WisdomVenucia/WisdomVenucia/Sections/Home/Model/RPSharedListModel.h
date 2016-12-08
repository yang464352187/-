//
//  RPSharedListModel.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/29.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BaseModel.h"

@interface RPSharedListModel : BaseModel

@property (nonatomic, strong) NSNumber *code, *total, *pageSize, *pageNo;

@property (nonatomic, strong) NSArray *locationShares;

@end

//位置共享model
@interface LocationShareModel : BaseModel

@property (nonatomic, strong) NSNumber *uid, *distance, *createtime, *presetMsgSwitch, *locationshareid;

@property (nonatomic, copy) NSString *presetMsg, *title, *msg;

@property (nonatomic, strong) NSArray *contacts, *track;

@property (nonatomic, assign) BOOL isLocation; // 加一个参数用来判断是否是在定位

@end

//联系人model
@interface ContactInfoModel : BaseModel

@property (nonatomic, copy) NSString *name, *phone, *address;

@end
//track
@interface TrackModel : BaseModel

@property (nonatomic, strong) NSNumber *lat, *lng;

@end