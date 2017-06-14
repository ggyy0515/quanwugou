//
//  ECPointManagermentBillListCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointManagermentBillListCell.h"
#import "ECPointManagmentBillModel.h"

@interface ECPointManagermentBillListCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *pointLabel;

@end

@implementation ECPointManagermentBillListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
    }
    [self.contentView addSubview:_dateLabel];
    _dateLabel.font = FONT_32;
    _dateLabel.textColor = DarkMoreColor;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.size.mas_equalTo(CGSizeMake(50.f, weakSelf.dateLabel.font.lineHeight));
        make.top.mas_equalTo(10.f);
    }];
    
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
    }
    [self.contentView addSubview:_timeLabel];
    _timeLabel.textColor = LightMoreColor;
    _timeLabel.font = FONT_24;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.dateLabel);
        make.top.mas_equalTo(weakSelf.dateLabel.mas_bottom).offset(8.f);
        make.height.mas_equalTo(weakSelf.timeLabel.font.lineHeight);
    }];
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.dateLabel.mas_right).offset(16.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    if (!_pointLabel) {
        _pointLabel = [UILabel new];
    }
    [self.contentView addSubview:_pointLabel];
    _pointLabel.font = FONT_32;
    _pointLabel.textColor = DarkMoreColor;
    _pointLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
    }
    [self.contentView addSubview:_detailLabel];
    _detailLabel.font = FONT_32;
    _detailLabel.textColor = LightMoreColor;
    _detailLabel.numberOfLines = 0;
    
}

- (void)setModel:(ECPointManagmentBillModel *)model {
    WEAK_SELF
    _model = model;
    
    NSDateFormatter *dateFt = [[NSDateFormatter alloc] init];
    [dateFt setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFt dateFromString:model.createDate];
    [dateFt setDateFormat:@"MM/dd"];
    NSString *dateStr = [dateFt stringFromDate:date];
    _dateLabel.text = dateStr;
    
    [dateFt setDateFormat:@"HH:mm"];
    NSString *timeStr = [dateFt stringFromDate:date];
    _timeLabel.text = timeStr;
    
   
    _pointLabel.text = model.symbolPoint;
    
    [_imageView yy_setImageWithURL:[NSURL URLWithString:model.image]
                       placeholder:[UIImage imageNamed:@"face1"]];
    
    CGFloat width = [CMPublicMethod getWidthWithLabel:_pointLabel];
    [_pointLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.bottom.top.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo(width);
    }];
    
    _detailLabel.text = model.detail;
    [_detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(16.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.right.mas_equalTo(weakSelf.pointLabel.mas_left).offset(-12.f);
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
