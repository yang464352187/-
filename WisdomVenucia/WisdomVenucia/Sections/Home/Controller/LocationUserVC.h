//
//  LocationUserVC.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/27.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BaseMapViewController.h"

@interface LocationUserVC : BaseMapViewController

@property (nonatomic, copy) void(^selectedLocationBlock)(NSString *location);

@end
