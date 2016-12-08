//
//  RQCreateLocationSharedModel.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/26.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BaseModel.h"
@class ContactModel;
@interface RQCreateLocationSharedModel : BaseModel

@property (nonatomic, copy) NSString *title, *presetMsg, *msg;

@property (nonatomic, strong) NSNumber *presetMsgSwitch, *distance, *locationshareid;

@property (nonatomic, strong) NSArray <ContactModel *>*contacts;

- (NSString *)checkParams;

@end

@interface ContactModel :BaseModel

@property (nonatomic, copy) NSString *name, *phone, *address;

- (NSString *)checkParams;
@end
