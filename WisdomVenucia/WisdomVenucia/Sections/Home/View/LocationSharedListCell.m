//
//  LocationSharedListCell.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/29.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "LocationSharedListCell.h"

@interface LocationSharedListCell()

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UILabel  *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation LocationSharedListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"LocationSharedListCell" owner:nil options:nil]lastObject];
        [self initUI];
    }
    return self;
}
- (IBAction)checkButtonClike:(UIButton *)sender {
    self.checkButton.selected = !self.checkButton.selected;
    if (_cellSelectBlock) {
        _cellSelectBlock(sender);
    }
    if (self.checkButton.selected) {
        [self.checkButton setImage:[UIImage imageNamed:@"ContactCheck"] forState:UIControlStateNormal];
    }else{
        [self.checkButton setImage:nil forState:UIControlStateNormal];
    }
}

- (IBAction)editCellButtonClike:(UIButton *)sender {
    if (_editSharedBlock) {
        _editSharedBlock(sender);
    }
}


- (void)initUI{
    self.backgroundColor             = [UIColor clearColor];
    self.nameLabel.textColor         = [UIColor whiteColor];
    self.phoneLabel.textColor        = [UIColor whiteColor];
    self.checkButton.backgroundColor = [UIColor clearColor];
    self.editButton.backgroundColor  = [UIColor clearColor];
    ViewBorder(self.checkButton, 0.5, [UIColor whiteColor]);
}

- (void)configCellDataWithModel:(ContactInfo *)model{
    self.nameLabel.text  = model.name;
    self.phoneLabel.text = model.phone;
    if (model.isSelected) {
        [self.checkButton setImage:[UIImage imageNamed:@"ContactCheck"] forState:UIControlStateNormal];
    }else {
        [self.checkButton setImage:nil forState:UIControlStateNormal];
    }
}

- (CGFloat)getCellHeight{
    
    return 100;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
