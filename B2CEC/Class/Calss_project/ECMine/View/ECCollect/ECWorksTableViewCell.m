//
//  ECWorksTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWorksTableViewCell.h"

@interface ECWorksTableViewCell()

@property (strong,nonatomic) UIView *topView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIImageView *coverImageView;

@property (strong,nonatomic) UIImageView *authimageView;

@property (strong,nonatomic) UILabel *authLab;

@property (strong,nonatomic) UIImageView *collectImageView;

@property (strong,nonatomic) UILabel *collectLab;

@property (strong,nonatomic) UIImageView *likeImageView;

@property (strong,nonatomic) UILabel *likeLab;

@property (strong,nonatomic) UIButton *deleteImgBtn;

@property (strong,nonatomic) UIView *lineView;

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation ECWorksTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECWorksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWorksTableViewCell)];
    if (cell == nil) {
        cell = [[ECWorksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWorksTableViewCell)];
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
    if (!_topView) {
        _topView = [UIView new];
    }
    _topView.backgroundColor = BaseColor;
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.textColor = DarkMoreColor;
    _titleLab.font = FONT_32;
    
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
    }
    
    if (!_authimageView) {
        _authimageView = [UIImageView new];
    }
    _authimageView.layer.cornerRadius = 16.f;
    _authimageView.layer.masksToBounds = YES;
    
    if (!_authLab) {
        _authLab = [UILabel new];
    }
    _authLab.font = FONT_32;
    _authLab.textColor = LightMoreColor;
    
    if (!_collectImageView) {
        _collectImageView = [UIImageView new];
    }
    _collectImageView.image = [UIImage imageNamed:@"article_tabbar_like_b"];
    
    if (!_collectLab) {
        _collectLab = [UILabel new];
    }
    _collectLab.font = FONT_24;
    _collectLab.textColor = LightColor;
    
    if (!_likeImageView) {
        _likeImageView = [UIImageView new];
    }
    _likeImageView.image = [UIImage imageNamed:@"good"];
    
    if (!_likeLab) {
        _likeLab = [UILabel new];
    }
    _likeLab.font = FONT_24;
    _likeLab.textColor = LightColor;
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_topView];
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_coverImageView];
    [self.contentView addSubview:_authimageView];
    [self.contentView addSubview:_authLab];
    [self.contentView addSubview:_collectImageView];
    [self.contentView addSubview:_collectLab];
    [self.contentView addSubview:_likeImageView];
    [self.contentView addSubview:_likeLab];
    [self.contentView addSubview:_lineView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(8.f);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom);
        make.height.mas_equalTo(44.f);
    }];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom);
        make.bottom.mas_equalTo(-49.f);
    }];
    
    [_authimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.authLab.mas_centerY);
    }];
    
    [_authLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.authimageView.mas_right).offset(8.f);
        make.top.mas_equalTo(weakSelf.coverImageView.mas_bottom);
        make.bottom.mas_equalTo(0.f);
    }];
    
    [_collectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.collectLab.mas_left).offset(-4.f);
        make.centerY.mas_equalTo(weakSelf.authLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12.f, 12.F));
    }];
    
    [_collectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(weakSelf.authLab);
        make.right.mas_equalTo(weakSelf.likeImageView.mas_left).offset(-12.f);
    }];
    
    [_likeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.likeLab.mas_left).offset(-4.f);
        make.centerY.with.height.equalTo(weakSelf.collectImageView);
    }];
    
    [_likeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(weakSelf.authLab);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
    }
    _deleteBtn.hidden = YES;
    [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_deleteBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.deleteBlock) {
            weakSelf.deleteBlock(weakSelf.model.collect_id,weakSelf.indexPath.row);
        }
    }];
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(33.f, 33.f));
        make.top.mas_equalTo(8.f);
        make.right.mas_equalTo(-8.f);
    }];
    
    if (!_deleteImgBtn) {
        _deleteImgBtn = [UIButton new];
    }
    [_deleteImgBtn setImage:[UIImage imageNamed:@"delete-1"] forState:UIControlStateNormal];
    _deleteImgBtn.hidden = YES;
    [_deleteImgBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.deleteUserBlock) {
            weakSelf.deleteUserBlock(weakSelf.model.worksID,weakSelf.indexPath.row);
        }
    }];
    [self.contentView addSubview:_deleteImgBtn];
}

- (void)setModel:(ECWorksModel *)model{
    _model = model;
    _titleLab.text = model.title;
    [_coverImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.cover)] placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
    [_authimageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.TITLE_IMG)] placeholder:[UIImage imageNamed:@"face1"]];
    _authLab.text = model.NAME;
    _collectLab.text = model.collect;
    _likeLab.text = model.praise;
}

- (void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    _deleteBtn.hidden = !isDelete;
}

- (void)setIsUserDelete:(BOOL)isUserDelete{
    _isUserDelete = isUserDelete;
    _deleteImgBtn.hidden = !isUserDelete;
    WEAK_SELF
    
    if (isUserDelete) {
        [_collectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.collectLab.mas_left).offset(-4.f);
            make.centerY.mas_equalTo(weakSelf.authLab.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.f, 12.F));
        }];
        
        [_collectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(weakSelf.authLab);
            make.right.mas_equalTo(weakSelf.likeImageView.mas_left).offset(-12.f);
        }];
        
        [_likeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.likeLab.mas_left).offset(-4.f);
            make.centerY.with.height.equalTo(weakSelf.collectImageView);
        }];
        
        [_likeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(weakSelf.authLab);
            make.right.mas_equalTo(weakSelf.deleteImgBtn.mas_left).offset(-12.f);
        }];
        
        [_deleteImgBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24.f, 24.f));
            make.right.mas_equalTo(-12.f);
            make.centerY.mas_equalTo(weakSelf.collectImageView.mas_centerY);
        }];
    }else{
        [_collectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.collectLab.mas_left).offset(-4.f);
            make.centerY.mas_equalTo(weakSelf.authLab.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12.f, 12.F));
        }];
        
        [_collectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(weakSelf.authLab);
            make.right.mas_equalTo(weakSelf.likeImageView.mas_left).offset(-12.f);
        }];
        
        [_likeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.likeLab.mas_left).offset(-4.f);
            make.centerY.with.height.equalTo(weakSelf.collectImageView);
        }];
        
        [_likeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(weakSelf.authLab);
            make.right.mas_equalTo(-12.f);
        }];
    }
}

@end
