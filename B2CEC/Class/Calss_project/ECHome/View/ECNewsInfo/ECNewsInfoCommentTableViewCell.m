//
//  ECNewsInfoCommentTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsInfoCommentTableViewCell.h"

@interface ECNewsInfoCommentTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UIButton *iconBtn;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UILabel *dateLab;

@property (strong,nonatomic) UILabel *contentLab;

@end

@implementation ECNewsInfoCommentTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECNewsInfoCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoCommentTableViewCell)];
    if (cell == nil) {
        cell = [[ECNewsInfoCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoCommentTableViewCell)];
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
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"face1"];
    _iconImageView.layer.cornerRadius = 18.f;
    _iconImageView.layer.masksToBounds = YES;
    
    if (!_iconBtn) {
        _iconBtn = [UIButton new];
    }
    [_iconBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.iconClickBlock) {
            weakSelf.iconClickBlock(weakSelf.userID);
        }
    }];
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.text = @"用户A";
    _nameLab.textColor = LightMoreColor;
    _nameLab.font = FONT_32;
    
    if (!_dateLab) {
        _dateLab = [UILabel new];
    }
    _dateLab.text = @"10月24日 20:24:23";
    _dateLab.textColor = LightColor;
    _dateLab.font = FONT_24;
    _dateLab.textAlignment = NSTextAlignmentRight;
    
    if (!_contentLab) {
        _contentLab = [UILabel new];
    }
    _contentLab.text = @"10月24日 20:24:23";
    _contentLab.textColor = DarkMoreColor;
    _contentLab.font = FONT_32;
    _contentLab.numberOfLines = 0;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_iconBtn];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_contentLab];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
        make.top.mas_equalTo(20.f);
        make.left.mas_equalTo(18.f);
    }];
    
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.iconImageView);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.iconImageView.mas_centerY);
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(12.f);
    }];
    
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.iconImageView.mas_centerY);
        make.right.mas_equalTo(-18.f);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLab.mas_left);
        make.right.mas_equalTo(-18.f);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).offset(16.f);
    }];
}

- (void)setTitle_img:(NSString *)title_img{
    _title_img = title_img;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(title_img)] placeholder:[UIImage imageNamed:@"face1"]];
}

- (void)setName:(NSString *)name{
    _name = name;
    _nameLab.text = name;
}

- (void)setEdittime:(NSString *)edittime{
    _edittime = edittime;
    _dateLab.text = edittime;
}

- (void)setContent:(NSString *)content{
    _content = content;
    _contentLab.text = content;
}

- (void)setUserID:(NSString *)userID{
    _userID = userID;
}

@end
