//
//  DatePickerView.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/27.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

@optional

- (void)didSaveClick:(NSString *)date;

@end

@interface DatePickerView : UIView

@property (weak, nonatomic) id<DatePickerViewDelegate> delegate;

- (void)bringSubviewToFrontAction;
- (void)sendSubviewToBackAction;
- (void)setinitialDate:(NSString *)date;
- (void)setMaxDate:(NSDate *)date;
- (void)setMinDate:(NSDate *)date;

- (void)setMaxStrDate:(NSString *)date;
- (void)setMinStrDate:(NSString *)date;



@end
