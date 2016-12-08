//
//  BaseModel.h
//  PaperSource
//
//  Created by Yhoon on 15/10/23.
//  Copyright © 2015年 yhoon. All rights reserved.
//


#import <Mantle/Mantle.h>

@interface BaseModel : MTLModel<MTLJSONSerializing>

/*这些为每个接口基本都要用到的属性参数,所以继承到BaseModel中*/
/*RQSomeModel为请求参数模型*/
/*RPSomeModel为返回数据模型*/

@property (nonatomic, copy) NSString *token;          // token

@end
