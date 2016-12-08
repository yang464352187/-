//
//  BlueToothCell.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/23.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "BlueToothCell.h"

@implementation BlueToothCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.name = [[UILabel alloc] initWithFrame:VIEWFRAME(30, 20, SCREEN_WIDTH-130, 20)];
        self.name.textColor = [UIColor whiteColor];
        self.name.font = CELL_BASE_FONT;
        [self addSubview:self.name];
        
        self.imageLogo = [[UIImageView alloc] init];
        [self addSubview:self.imageLogo];
        
        self.state = [[UILabel alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-120, 20, 50, 20)];
        self.state.textColor = [UIColor whiteColor];
        self.state.font = CELL_BASE_FONT;
        [self addSubview:self.state];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setImageAndFrame:(UIImage *)image{
    self.imageLogo.image = image;
    self.imageLogo.frame = VIEWFRAME(SCREEN_WIDTH-50, 30-image.size.height/2, image.size.width, image.size.height);
    
}

@end
