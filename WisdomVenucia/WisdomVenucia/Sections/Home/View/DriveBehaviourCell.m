//
//  DriveBehaviourCell.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "DriveBehaviourCell.h"

@implementation DriveBehaviourCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:VIEWFRAME(70, 10, SCREEN_WIDTH-100, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = SYSTEMFONT(12);
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        self.imageLogo = [[UIImageView alloc] initWithFrame:VIEWFRAME(30, 10, 40, 40)];
        
        [self addSubview:self.imageLogo];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:VIEWFRAME(70, 30, SCREEN_WIDTH-100, 20)];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = SYSTEMFONT(12);
        self.valueLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.valueLabel];
        
        //背景色和分割线
        UIView *back = [[UIView alloc] init];
        back.backgroundColor = CELL_COLOR_BACKGROUND;
        self.selectedBackgroundView = back;
        UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, 59, SCREEN_WIDTH, 1)];
        cut.backgroundColor = CELL_COLOR_CUT;
        [self addSubview:cut];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
