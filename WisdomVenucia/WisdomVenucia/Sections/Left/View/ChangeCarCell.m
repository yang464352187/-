//
//  ChangeCarCell.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "ChangeCarCell.h"

@implementation ChangeCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:VIEWFRAME(110, 20, SCREEN_WIDTH-180, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = SYSTEMFONT(14);
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        UIImage *image = [UIImage imageNamed:@"ChangeCarLogo"];
        self.imageLogo = [[UIImageView alloc] initWithFrame:VIEWFRAME(40,(60-image.size.height)/2 , image.size.width, image.size.height)];
        self.imageLogo.image = image;
        [self addSubview:self.imageLogo];
        
        self.selectImage = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-60, 20, 20, 20)];
        [self addSubview:self.selectImage];
        
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
    
}

@end
