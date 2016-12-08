//
//  RightCell.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/8.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "RightCell.h"

@implementation RightCell{
    UILabel *_dataLabel;
    UILabel *_titleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *back = [[UIImageView alloc] initWithFrame:VIEWFRAME(0, 15, SCREEN_WIDTH*2/3-25, 60)];
        back.image = [UIImage imageNamed:@"RightBackImg"];
        [self addSubview:back];
        
        
        _dataLabel               = [[UILabel alloc] initWithFrame:VIEWFRAME(50, 5, 100, 20)];
        _dataLabel.textColor     = [UIColor blackColor];
        _dataLabel.textAlignment = NSTextAlignmentRight;
        _dataLabel.font          = SYSTEMFONT(14);
        _dataLabel.text          = @"2015-12-08";
        [back addSubview:_dataLabel];
        
        _titleLabel               = [[UILabel alloc] initWithFrame:VIEWFRAME(50, 35, 100, 20)];
        _titleLabel.textColor     = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font          = SYSTEMFONT(14);
        _titleLabel.text          = @"专用测试字条";
        [back addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setData:(NSString *)data Title:(NSString *)title{
    _dataLabel.text = data;
    _titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
