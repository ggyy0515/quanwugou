
//
//  ECSelectCityTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECSelectCityTableViewCell.h"

@interface ECSelectCityTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIImageView *dirImageView;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECSelectCityTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECSelectCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECSelectCityTableViewCell)];
    if (cell == nil) {
        cell = [[ECSelectCityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECSelectCityTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BaseColor;
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
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.font = FONT_32;
    _titleLab.textColor = DarkMoreColor;
    
    if (!_dirImageView) {
        _dirImageView = [UIImageView new];
    }
    _dirImageView.image = [UIImage imageNamed:@"enter"];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_dirImageView];
    [self.contentView addSubview:_lineView];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(18.f);
    }];
    
    [_dirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.right.mas_equalTo(-18.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setModel:(ECCityModel *)model{
    _model = model;
    _titleLab.text = model.NAME;
    _dirImageView.hidden = model.subDict.count == 0;
}

@end
