//
//  ObjectMacro.h
//  PaperSource
//
//  Created by Yhoon on 15/10/14.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#ifndef ObjectMacro_h
#define ObjectMacro_h

#pragma mark - Weak Object
// 弱引用对象
#define _weekSelf(weakSelf)               __weak __typeof(&*self)weakSelf = self;// 弱引用
#define _weekObj(weakObj,variableObj)      __weak __typeof(&*variableObj)weakObj = variableObj;// 将对象弱引用

// 数据的有效性
#define Validity_Str(string) (((string != nil) && (string.length>0))?YES:NO)// 判断字符串是否有效

#endif /* ObjectMacro_h */
