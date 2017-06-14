//
//  ECNewsInfoLikeTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsInfoLikeTableViewCell.h"

@interface ECNewsInfoLikeTableViewCell()

@property (strong,nonatomic) UIButton *likeBtn;

@property (strong,nonatomic) UIButton *disLikeBtn;

@property (strong,nonatomic) UIButton *reportBtn;

@end

@implementation ECNewsInfoLikeTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECNewsInfoLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoLikeTableViewCell)];
    if (cell == nil) {
        cell = [[ECNewsInfoLikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoLikeTableViewCell)];
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
    if (!_likeBtn) {
        _likeBtn = [UIButton new];
    }
    _likeBtn.layer.cornerRadius = 16.f;
    _likeBtn.layer.masksToBounds = YES;
    _likeBtn.layer.borderColor = LineDefaultsColor.CGColor;
    _likeBtn.layer.borderWidth = 1.f;
    _likeBtn.titleLabel.font = FONT_28;
    [_likeBtn setTitleColor:LightColor forState:UIControlStateNormal];
    [_likeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.praiseType.integerValue == 0) {
            if (weakSelf.praiseClickBlock) {
                weakSelf.praiseClickBlock(YES);
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"您已选择,请勿重复选择！"];
        }
    }];
    
    if (!_disLikeBtn) {
        _disLikeBtn = [UIButton new];
    }
    _disLikeBtn.layer.cornerRadius = 16.f;
    _disLikeBtn.layer.masksToBounds = YES;
    _disLikeBtn.layer.borderColor = LineDefaultsColor.CGColor;
    _disLikeBtn.layer.borderWidth = 1.f;
    _disLikeBtn.titleLabel.font = FONT_28;
    [_disLikeBtn setTitleColor:LightColor forState:UIControlStateNormal];
    [_disLikeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.praiseType.integerValue == 0) {
            if (weakSelf.praiseClickBlock) {
                weakSelf.praiseClickBlock(NO);
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"您已选择,请勿重复选择！"];
        }
    }];
    
    if (!_reportBtn) {
        _reportBtn = [UIButton new];
    }
    [_reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [_reportBtn setTitleColor:LightColor forState:UIControlStateNormal];
    _reportBtn.titleLabel.font = FONT_28;
    [_reportBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.reportClickBlock) {
            weakSelf.reportClickBlock();
        }
    }];
    
    [self.contentView addSubview:_likeBtn];
    [self.contentView addSubview:_disLikeBtn];
    [self.contentView addSubview:_reportBtn];
    
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(76.f, 32.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.right.mas_equalTo(weakSelf.contentView.mas_centerX).offset(-6.f);
    }];
    
    [_disLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(76.f, 32.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(weakSelf.contentView.mas_centerX).offset(6.f);
    }];
    
    [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)setPraiseType:(NSString *)praiseType{
    _praiseType = praiseType;
    switch (praiseType.integerValue) {
        case 0:{//未选择
            [_likeBtn setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
            [_disLikeBtn setImage:[UIImage imageNamed:@"nogood"] forState:UIControlStateNormal];
        }
            break;
        case 1:{
            [_likeBtn setImage:[UIImage imageNamed:@"good_y"] forState:UIControlStateNormal];
            [_disLikeBtn setImage:[UIImage imageNamed:@"nogood"] forState:UIControlStateNormal];
        }
            break;
        case 2:{
            [_likeBtn setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
            [_disLikeBtn setImage:[UIImage imageNamed:@"nogood_y"] forState:UIControlStateNormal];
        }
            break;
    }
}

- (void)setPraise:(NSString *)praise{
    _praise = praise;
    [_likeBtn setTitle:praise forState:UIControlStateNormal];
    [_likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, 0.f)];
    [_likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 6.f)];
}

- (void)setBoo:(NSString *)boo{
    _boo = boo;
    [_disLikeBtn setTitle:boo forState:UIControlStateNormal];
    [_disLikeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, 0.f)];
    [_disLikeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 6.f)];
}

@end
