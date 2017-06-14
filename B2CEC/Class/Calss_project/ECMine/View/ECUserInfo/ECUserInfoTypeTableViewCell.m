
//
//  ECUserInfoTypeTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/6.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoTypeTableViewCell.h"

@interface ECUserInfoTypeTableViewCell()

@property (strong,nonatomic) UIButton *infoBtn;

@property (strong,nonatomic) UIButton *workBtn;

@property (strong,nonatomic) UIButton *logBtn;

@property (strong,nonatomic) UIButton *commentBtn;

@property (strong,nonatomic) UIButton *workBigBtn;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIView *bottomLineView;

@end

@implementation ECUserInfoTypeTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECUserInfoTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoTypeTableViewCell)];
    if (cell == nil) {
        cell = [[ECUserInfoTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoTypeTableViewCell)];
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
    if (!_infoBtn) {
        _infoBtn = [UIButton new];
    }
    [_infoBtn setTitle:@"简介" forState:UIControlStateNormal];
    [_infoBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _infoBtn.titleLabel.font = FONT_28;
    [_infoBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(weakSelf.infoBtn);
            make.bottom.mas_equalTo(0.f);
            make.height.mas_equalTo(2.f);
        }];
        [weakSelf.contentView setNeedsUpdateConstraints];
        [weakSelf.contentView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25f animations:^{
            [weakSelf.contentView layoutIfNeeded];
        }];
        if (weakSelf.typeClickBlock) {
            weakSelf.typeClickBlock(0);
        }
    }];
    
    if (!_workBtn) {
        _workBtn = [UIButton new];
    }
    [_workBtn setTitle:@"案例" forState:UIControlStateNormal];
    [_workBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _workBtn.titleLabel.font = FONT_28;
    [_workBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(weakSelf.workBtn);
            make.bottom.mas_equalTo(0.f);
            make.height.mas_equalTo(2.f);
        }];
        [weakSelf.contentView setNeedsUpdateConstraints];
        [weakSelf.contentView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25f animations:^{
            [weakSelf.contentView layoutIfNeeded];
        }];
        if (weakSelf.typeClickBlock) {
            weakSelf.typeClickBlock(1);
        }
    }];
    
    if (!_logBtn) {
        _logBtn = [UIButton new];
    }
    [_logBtn setTitle:@"日志" forState:UIControlStateNormal];
    [_logBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _logBtn.titleLabel.font = FONT_28;
    [_logBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(weakSelf.logBtn);
            make.bottom.mas_equalTo(0.f);
            make.height.mas_equalTo(2.f);
        }];
        [weakSelf.contentView setNeedsUpdateConstraints];
        [weakSelf.contentView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25f animations:^{
            [weakSelf.contentView layoutIfNeeded];
        }];
        if (weakSelf.typeClickBlock) {
            weakSelf.typeClickBlock(2);
        }
    }];
    
    if (!_commentBtn) {
        _commentBtn = [UIButton new];
    }
    [_commentBtn setTitle:@"评价" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = FONT_28;
    [_commentBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(weakSelf.commentBtn);
            make.bottom.mas_equalTo(0.f);
            make.height.mas_equalTo(2.f);
        }];
        [weakSelf.contentView setNeedsUpdateConstraints];
        [weakSelf.contentView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25f animations:^{
            [weakSelf.contentView layoutIfNeeded];
        }];
        if (weakSelf.typeClickBlock) {
            weakSelf.typeClickBlock(3);
        }
    }];
    
    if (!_workBigBtn) {
        _workBigBtn = [UIButton new];
    }
    [_workBigBtn setTitle:@"文章" forState:UIControlStateNormal];
    [_workBigBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _workBigBtn.titleLabel.font = FONT_28;
    [_workBigBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.typeClickBlock) {
            weakSelf.typeClickBlock(4);
        }
    }];
    
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
    }
    _bottomLineView.backgroundColor = LineDefaultsColor;
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = DarkMoreColor;
    
    [self.contentView addSubview:_infoBtn];
    [self.contentView addSubview:_workBtn];
    [self.contentView addSubview:_logBtn];
    [self.contentView addSubview:_commentBtn];
    [self.contentView addSubview:_workBigBtn];
    [self.contentView addSubview:_bottomLineView];
    [self.contentView addSubview:_lineView];
    
    [_infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.workBtn.mas_left);
    }];
    
    [_workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(weakSelf.infoBtn);
        make.left.mas_equalTo(weakSelf.infoBtn.mas_right);
        make.right.mas_equalTo(weakSelf.logBtn.mas_left);
    }];
    
    [_logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(weakSelf.infoBtn);
        make.left.mas_equalTo(weakSelf.workBtn.mas_right);
        make.right.mas_equalTo(weakSelf.commentBtn.mas_left);
    }];
    
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(weakSelf.infoBtn);
        make.left.mas_equalTo(weakSelf.logBtn.mas_right);
        make.right.mas_equalTo(0.f);
    }];
    
    [_workBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0.f);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.infoBtn);
        make.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(2.f);
    }];
}

- (void)setIsDesigner:(BOOL)isDesigner{
    _isDesigner = isDesigner;
    _infoBtn.hidden = !isDesigner;
    _workBtn.hidden = !isDesigner;
    _logBtn.hidden = !isDesigner;
    _commentBtn.hidden = !isDesigner;
    _lineView.hidden = !isDesigner;
    _workBigBtn.hidden = isDesigner;
}

- (void)setType:(NSInteger)type{
    _type = type;
    WEAK_SELF
    switch (type) {
        case 0:{
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.centerX.equalTo(weakSelf.infoBtn);
                make.bottom.mas_equalTo(0.f);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
        case 1:{
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.centerX.equalTo(weakSelf.workBtn);
                make.bottom.mas_equalTo(0.f);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
        case 2:{
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.centerX.equalTo(weakSelf.logBtn);
                make.bottom.mas_equalTo(0.f);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
        case 3:{
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.centerX.equalTo(weakSelf.commentBtn);
                make.bottom.mas_equalTo(0.f);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
        default:{
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.centerX.equalTo(weakSelf.infoBtn);
                make.bottom.mas_equalTo(0.f);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
    }
    [weakSelf.contentView setNeedsUpdateConstraints];
    [weakSelf.contentView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf.contentView layoutIfNeeded];
    }];
}

@end
