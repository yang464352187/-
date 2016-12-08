//
//  TyreStateView.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/10.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "TyreStateView.h"

@implementation TyreStateView{
    UILabel *_statelabel;
}

- (instancetype)initWithFrame:(CGRect)frame State:(CGFloat)state Temperature:(CGFloat)temperature Title:(NSString *)title place:(NSInteger)place{
    if (self = [super initWithFrame:frame]) {
        _statelabel = [[UILabel alloc] init];
        UILabel *stateValue = [[UILabel alloc] initWithFrame:VIEWFRAME(0, frame.size.height/2-40, frame.size.width, 40)];
        UILabel *unitLabel = [[UILabel alloc] initWithFrame:VIEWFRAME(0, frame.size.height/2, frame.size.width, 16)];
        UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:VIEWFRAME(0, frame.size.height/2+17, frame.size.width, 25)];
        
        
        if (temperature < 30) {
            self.image = [UIImage imageNamed:@"TyreStateGreen"];
            _statelabel.text = @"正常";
            
            stateValue.textColor = HEXCOLOR(0x00fff6);
            temperatureLabel.textColor = HEXCOLOR(0x00fff6);
            
            _isnormal = YES;
        }else{
            _statelabel.text = @"异常";
            stateValue.textColor = [UIColor redColor];
            temperatureLabel.textColor = [UIColor redColor];
            self.image = [UIImage imageNamed:@"TyreStateRed"];
            _isnormal = NO;
        }
        _statelabel.font = SYSTEMFONT(14);
        unitLabel.font = SYSTEMFONT(10);
        temperatureLabel.font = SYSTEMFONT(16);
        stateValue.font = SYSTEMFONT(36);
        
        unitLabel.textAlignment = NSTextAlignmentCenter;
        temperatureLabel.textAlignment = NSTextAlignmentCenter;
        stateValue.textAlignment = NSTextAlignmentCenter;
        
        unitLabel.text = @"Kgt/cm^2";
        temperatureLabel.text = [NSString stringWithFormat:@"%.1f°C",temperature];
        stateValue.text = [NSString stringWithFormat:@"%.1f",state];
        
        
        
        _statelabel.textColor = [UIColor whiteColor];
        unitLabel.textColor = [UIColor whiteColor];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = SYSTEMFONT(14);
        titleLabel.text = title;
        
        if (place == 1) {
            _statelabel.frame = VIEWFRAME(12, 0, 60, 33);
            titleLabel.frame = VIEWFRAME(12, frame.size.height-40, 60, 40);
            
        }else{
            _statelabel.frame = VIEWFRAME(frame.size.width-72, 0, 60, 33);
            titleLabel.frame = VIEWFRAME(frame.size.width-72, frame.size.height-40, 60, 40);
            _statelabel.textAlignment = NSTextAlignmentRight;
            titleLabel.textAlignment = NSTextAlignmentRight;
        }
        
        [self addSubview:temperatureLabel];
        [self addSubview:_statelabel];
        [self addSubview:stateValue];
        [self addSubview:unitLabel];
        [self addSubview:titleLabel];
        
        if (SCREEN_HIGHT == 480) {
            self.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }
        
        _temperature = temperatureLabel;
        _state       = stateValue;
    
    }
    
    return self;
}

- (void)setStateText:(CGFloat)state{
    self.state.text = [NSString stringWithFormat:@"%.1f",state];
    if (state>2.5) {
        _statelabel.text = @"异常";
        self.state.textColor = [UIColor redColor];
        self.image = [UIImage imageNamed:@"TyreStateRed"];
        self.state.textColor = [UIColor redColor];
        _isnormal = NO;
    }else{
        self.image = [UIImage imageNamed:@"TyreStateGreen"];
        _statelabel.text = @"正常";
        
        self.state.textColor = HEXCOLOR(0x00fff6);
        _isnormal = YES;
    }
}



- (void)setTemperatureText:(NSInteger)temperature{
    self.temperature.text = [NSString stringWithFormat:@"%li°C",(long)temperature];
    if (temperature > 60) {
        _statelabel.text = @"异常";
        self.temperature.textColor = [UIColor redColor];
        self.image = [UIImage imageNamed:@"TyreStateRed"];
        _isnormal = NO;
    }else{
        self.image = [UIImage imageNamed:@"TyreStateGreen"];
        _statelabel.text = @"正常";
        self.temperature.textColor = HEXCOLOR(0x00fff6);
        _isnormal = YES;
    }
    
}

@end
