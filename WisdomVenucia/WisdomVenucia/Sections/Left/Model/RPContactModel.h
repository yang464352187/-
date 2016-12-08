//
//  RPContactModel.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/27.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BaseModel.h"

@interface RPContactModel : BaseModel

@property (nonatomic, copy) NSMutableArray *contacts;

@property (nonatomic, strong) NSNumber *pageSize, *total, *pageNo, *code;

@end

@interface ContactInfo :BaseModel

@property (nonatomic, strong) NSNumber *contactid, *uid, *createtime;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) NSString *phone, *name, *address;

- (NSString *)checkParams;

@end
