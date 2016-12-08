//
//  RQContactModel.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/12/7.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BaseModel.h"

@interface RQContactModel : BaseModel

@property (nonatomic, strong) NSString *phone, *name, *address;

@property (nonatomic, strong) NSNumber *contactid;

- (NSString *)checkParams;

@end
