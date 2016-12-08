//
//  LocationSharedCell.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/30.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "LocationSharedCell.h"
@interface LocationSharedCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;




@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation LocationSharedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"LocationSharedCell" owner:nil options:nil]lastObject];
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initData{
    self.formatter = [[NSDateFormatter alloc]init];
    self.formatter.dateStyle = kCFDateFormatterMediumStyle;
    self.formatter.timeStyle = kCFDateFormatterMediumStyle;

}

- (void)initUI{
    self.backgroundColor         = [UIColor clearColor];
    self.dateLabel.textColor     = [UIColor whiteColor];
    self.timeLabel.textColor     = [UIColor whiteColor];
    self.titleLabel.textColor    = [UIColor whiteColor];
    self.distanceLabel.textColor = [UIColor whiteColor];
    
    [self.uploadLocationSwitch setOn:NO];
    
    
}

- (void)configCellDataWithModel:(LocationShareModel *)model{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.createtime integerValue]];
    NSString *dateString = [self.formatter stringFromDate:date];
    NSArray *dateArray = [dateString componentsSeparatedByString:@" "];
    
    self.dateLabel.text = dateArray[0];
    self.timeLabel.text = dateArray[1];
    self.titleLabel.text = model.title;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ 米",model.distance];
    
    if (model.isLocation) {
        [self.uploadLocationSwitch setOn:YES animated:NO];
    }

}

- (CGFloat)getCellHeight{
    
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0;
}

- (IBAction)switchClick:(UISwitch *)sender {
    if (_uploadLocationBlock) {
        _uploadLocationBlock(sender);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
