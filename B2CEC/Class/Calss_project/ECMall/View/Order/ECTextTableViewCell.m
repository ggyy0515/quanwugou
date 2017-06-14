//
//  ECTextTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 16/7/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTextTableViewCell.h"

@interface ECTextTableViewCell()

@property (strong,nonatomic) UILabel *leftLabel;

@property (strong,nonatomic) UILabel *rightLabel;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECTextTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTextTableViewCell)];
    if (cell == nil) {
        cell = [[ECTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTextTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    WEAK_SELF
    
    if (_leftLabel == nil) {
        _leftLabel = [UILabel new];
    }
    _leftLabel.textColor = DarkColor;
    _leftLabel.font = [UIFont systemFontOfSize:16.f];
    
    if (_rightLabel == nil) {
        _rightLabel = [UILabel new];
    }
    _rightLabel.textColor = LightMoreColor;
    _rightLabel.font = [UIFont systemFontOfSize:14.f];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    
    if (_lineView == nil) {
        _lineView = [UIView new];
    }
    _lineView.hidden = YES;
    _lineView.backgroundColor = BaseColor;
    
    [self.contentView addSubview:_leftLabel];
    [self.contentView addSubview:_rightLabel];
    [self.contentView addSubview:_lineView];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.f);
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.rightLabel.mas_left);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8.f);
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.leftLabel.mas_right);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setName:(NSString *)name{
    _name = name;
    _leftLabel.text = name;
}

- (void)setDetail:(NSString *)detail{
    _detail = detail;
    _rightLabel.text = detail;
}

- (void)setNameColor:(UIColor *)nameColor{
    _nameColor = nameColor;
    _leftLabel.textColor = nameColor;
}

- (void)setDetailColor:(UIColor *)detailColor{
    _detailColor = detailColor;
    _rightLabel.textColor = detailColor;
}

- (void)setNameFont:(CGFloat)nameFont{
    _nameFont = nameFont;
    _leftLabel.font = [UIFont systemFontOfSize:nameFont];
}
- (void)setDetailFont:(CGFloat)detailFont{
    _detailFont = detailFont;
    _rightLabel.font = [UIFont systemFontOfSize:detailFont];
}

- (void)setNameNumberOfLines:(NSInteger)nameNumberOfLines{
    _nameNumberOfLines = nameNumberOfLines;
    _leftLabel.numberOfLines = nameNumberOfLines;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    _leftLabel.textAlignment = textAlignment;
}

- (void)setShowLine:(BOOL)showLine{
    _showLine = showLine;
    _lineView.hidden = !showLine;
}
@end
