//
//  ECHomeVideoPlayerTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeVideoPlayerTableViewCell.h"

@interface ECHomeVideoPlayerTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UIImageView *bgImageView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIButton *startOrPauseBtn;

@property (strong,nonatomic) UIView *timeView;

@property (strong,nonatomic) UILabel *timeLab;

@property (strong,nonatomic) UIImageView *authorImageView;

@property (strong,nonatomic) UILabel *authorLab;

@property (strong,nonatomic) UILabel *countLab;

@property (strong,nonatomic) UIImageView *commentImageView;

@property (strong,nonatomic) UILabel *commentLab;

@property (strong,nonatomic) UIImageView *shareImageView;

@property (strong,nonatomic) UILabel *shareLab;

@property (strong,nonatomic) UIButton *shareBtn;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECHomeVideoPlayerTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECHomeVideoPlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeVideoPlayerTableViewCell)];
    if (cell == nil) {
        cell = [[ECHomeVideoPlayerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeVideoPlayerTableViewCell)];
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
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"placeHolder_4"];
    
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
    }
    _bgImageView.image = [UIImage imageNamed:@"video_mbg"];
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"我是视频标题，我最多拥有2行字。字数还不够吗？现在够了吧！";
    _titleLab.numberOfLines = 2;
    _titleLab.font = [UIFont systemFontOfSize:18.f];
    _titleLab.textColor = [UIColor whiteColor];
    
    if (!_startOrPauseBtn) {
        _startOrPauseBtn = [UIButton new];
    }
    [_startOrPauseBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
    [_startOrPauseBtn setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateSelected];
    [_startOrPauseBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.startVideoPlayer) {
            weakSelf.startVideoPlayer(weakSelf.indexPath);
        }
    }];
    
    if (!_timeView) {
        _timeView = [UIView new];
    }
    _timeView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3f];
    _timeView.layer.cornerRadius = 10.f;
    _timeView.layer.masksToBounds = YES;
    
    if (!_timeLab) {
        _timeLab = [UILabel new];
    }
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.textColor = UIColorFromHexString(@"ffffff");
    _timeLab.font = [UIFont systemFontOfSize:10.f];
    _timeLab.text = @"00:00";
    
    if (!_authorImageView) {
        _authorImageView = [UIImageView new];
    }
    _authorImageView.image = [UIImage imageNamed:@"placeholder_News1"];
    _authorImageView.layer.cornerRadius = 14.f;
    _authorImageView.layer.masksToBounds = YES;
    
    if (!_authorLab) {
        _authorLab = [UILabel new];
    }
    _authorLab.text = @"网易视频";
    _authorLab.font = FONT_28;
    _authorLab.textColor = LightMoreColor;
    
    if (!_countLab) {
        _countLab = [UILabel new];
    }
    _countLab.text = @"265次播放";
    _countLab.textColor = LightColor;
    _countLab.font = FONT_24;
    
    if (!_commentImageView) {
        _commentImageView = [UIImageView new];
    }
    _commentImageView.image = [UIImage imageNamed:@"home_icon_comment"];
    
    if (!_commentLab) {
        _commentLab = [UILabel new];
    }
    _commentLab.font = FONT_24;
    _commentLab.textColor = LightColor;
    _commentLab.text = @"256";
    
    if (!_shareImageView) {
        _shareImageView = [UIImageView new];
    }
    _shareImageView.image = [UIImage imageNamed:@"share_mini"];
    
    if (!_shareLab) {
        _shareLab = [UILabel new];
    }
    _shareLab.font = FONT_24;
    _shareLab.textColor = LightColor;
    _shareLab.text = @"分享";
    
    if (!_shareBtn) {
        _shareBtn = [UIButton new];
    }
    [_shareBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.shareClickBlock) {
            weakSelf.shareClickBlock();
        }
    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_bgImageView];
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_startOrPauseBtn];
    [self.contentView addSubview:_timeView];
    [_timeView addSubview:_timeLab];
    [self.contentView addSubview:_authorImageView];
    [self.contentView addSubview:_authorLab];
    [self.contentView addSubview:_countLab];
    [self.contentView addSubview:_commentImageView];
    [self.contentView addSubview:_commentLab];
    [self.contentView addSubview:_shareImageView];
    [self.contentView addSubview:_shareLab];
    [self.contentView addSubview:_shareBtn];
    [self.contentView addSubview:_lineView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(weakSelf.iconImageView.mas_width).multipliedBy(422.f / 750.f);
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.iconImageView);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.f);
        make.left.mas_equalTo(16.f);
        make.right.mas_equalTo(-16.f);
    }];
    
    [_startOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
        make.center.equalTo(weakSelf.iconImageView);
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44.f, 20.f));
        make.right.mas_equalTo(weakSelf.iconImageView.mas_right).offset(-8.f);
        make.bottom.mas_equalTo(weakSelf.iconImageView.mas_bottom).offset(-8.f);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_authorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28.f, 28.f));
        make.left.mas_equalTo(8.f);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).offset(8.f);
    }];
    
    [_authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.authorImageView.mas_centerY);
        make.left.mas_equalTo(weakSelf.authorImageView.mas_right).offset(8.f);
    }];
    
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.authorImageView.mas_centerY);
        make.right.mas_equalTo(weakSelf.commentImageView.mas_left).offset(-16.f);
    }];
    
    [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.f, 16.f));
        make.centerY.mas_equalTo(weakSelf.authorImageView.mas_centerY);
        make.right.mas_equalTo(weakSelf.commentLab.mas_left).offset(-4.f);
    }];
    
    [_commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.authorImageView.mas_centerY);
        make.right.mas_equalTo(weakSelf.shareImageView.mas_left).offset(-16.f);
    }];
    
    [_shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.f, 16.f));
        make.centerY.mas_equalTo(weakSelf.authorImageView.mas_centerY);
        make.right.mas_equalTo(weakSelf.shareLab.mas_left).offset(-4.f);
    }];
    
    [_shareLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.authorImageView.mas_centerY);
        make.right.mas_equalTo(-8.f);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf.shareImageView);
        make.right.mas_equalTo(weakSelf.shareLab.mas_right);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

- (void)setModel:(ECHomeNewsListModel *)model{
    _model = model;
    
    _titleLab.textColor = [model.isView isEqualToString:@"0"] ? DarkMoreColor : LightMoreColor;
    _titleLab.text = model.title;
    _authorLab.text = model.resource;
    _commentLab.text = model.commentNum;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.cover1)] placeholder:[UIImage imageNamed:@"placeholder_News1"]];
    _timeLab.text = [CMPublicMethod playerTimeStyle:model.videolength.integerValue];
    _countLab.text = [NSString stringWithFormat:@"%@次播放",model.viewNumber];
}
@end
