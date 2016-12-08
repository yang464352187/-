//
//  UserInfoModel.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel


@property (nonatomic, copy) NSString *username,*nickname,*birthday,*introduction,*avatar,*address;
@property (nonatomic, copy) NSNumber *sex;

@end
