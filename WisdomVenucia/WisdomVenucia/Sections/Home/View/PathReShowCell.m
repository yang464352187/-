//
//  PathReShowCell.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "PathReShowCell.h"

@interface PathReShowCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation PathReShowCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel = [UILabel createLabelWithFrame:CGRectMake(ViewWidth(self) / 2, 5, ViewWidth(self) / 2 - 10, 30)
                                                                    andText:@"周末舟山旅游"
                                                               andTextColor:[UIColor whiteColor]
                                                                 andBgColor:[UIColor clearColor]
                                                                    andFont:[UIFont systemFontOfSize:16]
                                                           andTextAlignment:NSTextAlignmentRight];
    self.distanceLabel = [UILabel createLabelWithFrame:CGRectMake(ViewWidth(self) / 2, GetViewMaxY(self.titleLabel) + 5, ViewWidth(self) / 2 - 10, 30)
                                            andText:@"20.00km"
                                       andTextColor:[UIColor whiteColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:[UIFont systemFontOfSize:16]
                                   andTextAlignment:NSTextAlignmentRight];
    self.dateLabel = [UILabel createLabelWithFrame:CGRectMake(50, 5, ViewWidth(self) / 2 - 50, 30)
                                               andText:@"2015-10-16"
                                          andTextColor:[UIColor whiteColor]
                                            andBgColor:[UIColor clearColor]
                                               andFont:[UIFont systemFontOfSize:14]
                                      andTextAlignment:NSTextAlignmentCenter];
    self.timeLabel = [UILabel createLabelWithFrame:CGRectMake(50, GetViewMaxY(self.dateLabel) + 5, ViewWidth(self) / 2 - 50, 30)
                                           andText:@"01:20:36"
                                      andTextColor:[UIColor whiteColor]
                                        andBgColor:[UIColor clearColor]
                                           andFont:[UIFont systemFontOfSize:14]
                                  andTextAlignment:NSTextAlignmentCenter];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 22, 30, 30)];
    imageView.image = [UIImage imageNamed:@"DriveBehaviour4"];
    [self addSubview:self.titleLabel];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:imageView];
}
- (void)initData{
    self.formatter = [[NSDateFormatter alloc]init];
    self.formatter.dateStyle = kCFDateFormatterMediumStyle;
    self.formatter.timeStyle = kCFDateFormatterMediumStyle;
    
}
- (void)configCellDataWithModel:(LocationShareModel *)model{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.createtime integerValue]];
    NSString *dateString = [self.formatter stringFromDate:date];
    NSArray *dateArray = [dateString componentsSeparatedByString:@" "];
    
    self.dateLabel.text = dateArray[0];
    self.timeLabel.text = dateArray[1];
    self.titleLabel.text = model.title;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ 米",model.distance];
}

- (CGFloat)getCellHeight{
    return 30 + 30 + 5 + 5 + 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
