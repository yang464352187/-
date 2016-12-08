//
//  UserDefaultMacro.h
//  PaperSource
//
//  Created by Yhoon on 15/10/14.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#ifndef UserDefaultMacro_h
#define UserDefaultMacro_h

/*本地数据库快捷方法*/
#define DEFAULTS()                          [NSUserDefaults standardUserDefaults]
#define DEFAULTS_INIT(dictionary)			[DEFAULTS() registerDefaults:dictionary]
#define DEFAULTS_SAVE                       [DEFAULTS() synchronize]

// 存取数据对象
#define DEFAULTS_GET_OBJ(key)               [DEFAULTS() objectForKey:key]
#define DEFAULTS_SET_OBJ(object, key)       [DEFAULTS() setObject:object forKey:key]
#define DEFAULTS_REMOVE(key)				[DEFAULTS() removeObjectForKey:key]

// 存取BOOL值
#define DEFAULTS_GET_BOOL(key)              [DEFAULTS() boolForKey:key]
#define DEFAULTS_SET_BOOL(BOOL, key)        [DEFAULTS() setBool:BOOL forKey:key]

// 存取Integer
#define DEFAULTS_GET_INTEGER(key)           [DEFAULTS() integerForKey:key]
#define DEFAULTS_SET_INTEGER(Integer, key)  [DEFAULTS() setInteger:Integer forKey:key]

#endif /* UserDefaultMacro_h */
