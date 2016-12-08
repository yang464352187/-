//
//  ModifyUserInfoModel.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/4.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BaseModel.h"

@interface ModifyUserInfoModel : BaseModel

@property (nonatomic, copy) NSString *username,*nickname,*birthday,*introduction,*address;
@property (nonatomic, copy) NSNumber *sex;

@end
