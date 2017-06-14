//
//  ECTeamManagementTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTeamManagementTableViewCell.h"

@interface ECTeamManagementTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UILabel *scoreLab;

@property (strong,nonatomic) UIImageView *dirImageView;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECTeamManagementTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECTeamManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTeamManagementTableViewCell)];
    if (cell == nil) {
        cell = [[ECTeamManagementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTeamManagementTableViewCell)];
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
    _iconImageView.layer.cornerRadius = 16.f;
    _iconImageView.layer.masksToBounds = YES;
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.textColor = DarkMoreColor;
    _nameLab.font = FONT_32;
    
    if (!_scoreLab) {
        _scoreLab = [UILabel new];
    }
    _scoreLab.textColor = DarkMoreColor;
    _scoreLab.font = FONT_28;
    
    if (!_dirImageView) {
        _dirImageView = [UIImageView new];
    }
    _dirImageView.image = [UIImage imageNamed:@"enter"];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_scoreLab];
    [self.contentView addSubview:_dirImageView];
    [self.contentView addSubview:_lineView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(12.f);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(6.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.dirImageView.mas_left).offset(-8.f);
    }];
    
    [_dirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setModel:(ECTeamModel *)model{
    _model = model;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.TITLE_IMG)] placeholder:[UIImage imageNamed:@"face1"]];
    _nameLab.text = model.NAME;
    _scoreLab.text = [NSString stringWithFormat:@"%@积分",model.point];
}

- (void)setIsShowNext:(BOOL)isShowNext{
    _isShowNext = isShowNext;
    WEAK_SELF
    if (isShowNext) {
        [_scoreLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.f);
            make.right.mas_equalTo(weakSelf.dirImageView.mas_left).offset(-8.f);
        }];
        
        [_dirImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
            make.right.mas_equalTo(-12.f);
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        }];
    }else{
        [_scoreLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.f);
            make.right.mas_equalTo(-12.f);
        }];
        
        [_dirImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0.f, 0.f));
            make.right.mas_equalTo(-12.f);
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        }];
    }
}

@end
