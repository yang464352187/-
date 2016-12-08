//
//  CreateLocationSharedVC.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "WVBaseVC.h"
#import "RPSharedListModel.h"



@interface CreateLocationSharedVC : WVBaseVC

@property (nonatomic, strong) LocationShareModel *shareModel;

@property (nonatomic, copy) void(^reGetDataBlock)(void);//返回时重新获取数据

@end
