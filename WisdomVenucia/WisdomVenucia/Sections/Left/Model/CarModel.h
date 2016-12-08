//
//  CarModel.h
//  WisdomVenucia
//
//  Created by 苏凡 on 16/3/24.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "BaseModel.h"

@interface CarModel : BaseModel


@property (strong, nonatomic) NSString *plateNumber,*vinCode,*engineCode,*model,*modelNumber,*displacement,*gearbox,*fuelType,*frameNumber,*deviceNumer;

@property (strong, nonatomic) NSNumber *carinfoid,*mileage;

@end
