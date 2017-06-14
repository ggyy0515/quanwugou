//
//  ECNewsInfoRelatedTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsInfoRelatedTableViewCell.h"

@interface ECNewsInfoRelatedTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@end

@implementation ECNewsInfoRelatedTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECNewsInfoRelatedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoRelatedTableViewCell)];
    if (cell == nil) {
        cell = [[ECNewsInfoRelatedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoRelatedTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
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
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"这是相关资讯标题";
    _titleLab.font = FONT_32;
    _titleLab.textColor = DarkMoreColor;
    
    [self.contentView addSubview:_titleLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)setModel:(ECNewsRecommendModel *)model{
    _model = model;
    _titleLab.text = model.title;
}

@end
