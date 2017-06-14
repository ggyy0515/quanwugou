//
//  ECNewsInfoHeadTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsInfoHeadTableViewCell.h"

@interface ECNewsInfoHeadTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIImageView *authImageView;

@property (strong,nonatomic) UILabel *authLab;

@property (strong,nonatomic) UILabel *authTypeLab;

@property (strong,nonatomic) UILabel *dateLab;

@property (strong,nonatomic) UIButton *focusBtn;

@end

@implementation ECNewsInfoHeadTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECNewsInfoHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoHeadTableViewCell)];
    if (cell == nil) {
        cell = [[ECNewsInfoHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoHeadTableViewCell)];
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
    WEAK_SELF
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.font = [UIFont boldSystemFontOfSize:24.f];
    _titleLab.textColor = DarkColor;
    _titleLab.numberOfLines = 0;
    
    if (!_authImageView) {
        _authImageView = [UIImageView new];
    }
    _authImageView.image = [UIImage imageNamed:@"placeholder_News2"];
    _authImageView.layer.cornerRadius = 20.f;
    _authImageView.layer.masksToBounds = YES;
    
    if (!_authLab) {
        _authLab = [UILabel new];
    }
    _authLab.font = FONT_32;
    _authLab.textColor = DarkMoreColor;
    
    if (!_authTypeLab) {
        _authTypeLab = [UILabel new];
    }
    _authTypeLab.font = FONT_24;
    _authTypeLab.textColor = LightMoreColor;
    _authTypeLab.layer.borderColor = LineDefaultsColor.CGColor;
    _authTypeLab.layer.borderWidth = 0.5f;
    _authTypeLab.textAlignment = NSTextAlignmentCenter;
    
    if (!_dateLab) {
        _dateLab = [UILabel new];
    }
    _dateLab.font = FONT_28;
    _dateLab.textColor = LightColor;
    
    if (!_focusBtn) {
        _focusBtn = [UIButton new];
    }
    [_focusBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_focusBtn setTitle:@"√ 已关注" forState:UIControlStateSelected];
    [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _focusBtn.backgroundColor = MainColor;
    _focusBtn.layer.cornerRadius = 5.f;
    _focusBtn.layer.masksToBounds = YES;
    _focusBtn.titleLabel.font = FONT_32;
    _focusBtn.hidden = YES;
    [_focusBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.focusClickBlock) {
            weakSelf.focusClickBlock(weakSelf.focusBtn.selected);
        }
    }];
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_authImageView];
    [self.contentView addSubview:_authLab];
    [self.contentView addSubview:_authTypeLab];
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_focusBtn];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
        make.top.mas_equalTo(24.f);
    }];
    
    [_authImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
        make.left.mas_equalTo(18.f);
        make.bottom.mas_equalTo(-4.f);
    }];
    
    [_authLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.authImageView.mas_right).offset(12.f);
        make.bottom.mas_equalTo(weakSelf.authImageView.mas_centerY).offset(-2.f);
    }];
    
    [_authTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.authImageView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.authImageView.mas_centerY).offset(2.f);
        make.size.mas_equalTo(CGSizeMake(30.f, 16.f));
    }];
    
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.authTypeLab.mas_right).offset(5.f);
        make.top.mas_equalTo(weakSelf.authTypeLab.mas_top);
    }];

    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80.f, 32.f));
        make.right.mas_equalTo(-18.f);
        make.centerY.mas_equalTo(weakSelf.authImageView.mas_centerY);
    }];
}

- (void)setModel:(ECNewsInfomationModel *)model{
    _model = model;
    
    _titleLab.text = model.title;
    _authLab.text = model.resource;
    switch (model.isoriginal.integerValue) {
        case 0:{
            _authTypeLab.text = @"原创";
            _focusBtn.hidden = NO;
            _focusBtn.selected = [model.isattention isEqualToString:@"1"];
        }
            break;
        case 1:{
            _authTypeLab.text = @"转载";
            _focusBtn.hidden = YES;
        }
            break;
    }
    _dateLab.text = model.createdate;
    _focusBtn.hidden = YES;
}

@end
