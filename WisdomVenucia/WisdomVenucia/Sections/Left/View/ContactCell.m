//
//  ContactCell.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/26.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell()

@property (nonatomic, strong) UIImageView *headerImageView;



@end

@implementation ContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
