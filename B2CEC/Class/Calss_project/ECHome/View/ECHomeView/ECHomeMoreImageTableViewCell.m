//
//  ECHomeMoreImageTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeMoreImageTableViewCell.h"

@interface ECHomeMoreImageTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *authorLab;

@property (strong,nonatomic) UIImageView *commentImageView;

@property (strong,nonatomic) UILabel *commentLab;

@property (strong,nonatomic) UIImageView *dateImageView;

@property (strong,nonatomic) UILabel *dateLab;

@property (strong,nonatomic) UIImageView *iconImageView1;

@property (strong,nonatomic) UIImageView *iconImageView2;

@property (strong,nonatomic) UIImageView *iconImageView3;

@property (strong,nonatomic) UIView *lineView;

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation ECHomeMoreImageTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECHomeMoreImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeMoreImageTableViewCell)];
    if (cell == nil) {
        cell = [[ECHomeMoreImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeMoreImageTableViewCell)];
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
    _titleLab.text = @"传统的子母床已经过时了，现今流行这样节省空间";
    _titleLab.numberOfLines = 2;
    _titleLab.font = [UIFont systemFontOfSize:18.f];
    _titleLab.textColor = DarkMoreColor;
    
    if (!_authorLab) {
        _authorLab = [UILabel new];
    }
    _authorLab.font = FONT_24;
    _authorLab.textColor = LightColor;
    _authorLab.text = @"网易家居";
    
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
    
    if (!_dateImageView) {
        _dateImageView = [UIImageView new];
    }
    _dateImageView.image = [UIImage imageNamed:@"home_icon_time"];
    
    if (!_dateLab) {
        _dateLab = [UILabel new];
    }
    _dateLab.font = FONT_24;
    _dateLab.textColor = LightColor;
    _dateLab.text = @"10月29日";
    
    if (!_iconImageView1) {
        _iconImageView1 = [UIImageView new];
    }
    _iconImageView1.image = [UIImage imageNamed:@"placeholder_News2"];
    
    if (!_iconImageView2) {
        _iconImageView2 = [UIImageView new];
    }
    _iconImageView2.image = [UIImage imageNamed:@"placeholder_News2"];
    
    if (!_iconImageView3) {
        _iconImageView3 = [UIImageView new];
    }
    _iconImageView3.image = [UIImage imageNamed:@"placeholder_News2"];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_authorLab];
    [self.contentView addSubview:_commentImageView];
    [self.contentView addSubview:_commentLab];
    [self.contentView addSubview:_dateImageView];
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_iconImageView1];
    [self.contentView addSubview:_iconImageView2];
    [self.contentView addSubview:_iconImageView3];
    [self.contentView addSubview:_lineView];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
    }];
    
    [_iconImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.iconImageView2.mas_left).offset(-4.5f);
        make.left.mas_equalTo(18.f);
        make.height.mas_equalTo(weakSelf.iconImageView1.mas_width).multipliedBy(72.f / 110.f);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom).offset(10.f);
        make.width.mas_equalTo(weakSelf.iconImageView2.mas_width);
    }];
    
    [_iconImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView1.mas_right).offset(4.5);
        make.right.mas_equalTo(weakSelf.iconImageView3.mas_left).offset(-4.5);
        make.width.height.top.equalTo(weakSelf.iconImageView1);
    }];
    
    [_iconImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18.f);
        make.left.mas_equalTo(weakSelf.iconImageView2.mas_right).offset(4.5f);
        make.width.height.top.equalTo(weakSelf.iconImageView1);
    }];
    
    [_authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLab.mas_left);
        make.bottom.mas_equalTo(weakSelf.lineView.mas_bottom).offset(-18.f);
    }];
    
    [_commentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.authorLab.mas_right).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.authorLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12.f, 12.F));
    }];
    
    [_commentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(weakSelf.authorLab);
        make.left.mas_equalTo(weakSelf.commentImageView.mas_right).offset(4.f);
    }];
    
    [_dateImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.commentLab.mas_right).offset(12.f);
        make.centerY.with.height.equalTo(weakSelf.commentImageView);
    }];
    
    [_dateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(weakSelf.authorLab);
        make.left.mas_equalTo(weakSelf.dateImageView.mas_right).offset(4.f);
    }];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
        make.bottom.mas_equalTo(0.f);
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
}

- (void)setModel:(ECHomeNewsListModel *)model{
    _model = model;
    
    _titleLab.textColor = [model.isView isEqualToString:@"0"] ? DarkMoreColor : LightMoreColor;
    _titleLab.text = model.title;
    _authorLab.text = model.resource;
    _commentLab.text = model.commentNum;
    _dateLab.text = model.createdate;
    [_iconImageView1 yy_setImageWithURL:[NSURL URLWithString:[IMAGEURL(model.cover1) stringByReplacingOccurrencesOfString:@"/res" withString:@""]] placeholder:[UIImage imageNamed:@"placeholder_News2"]];
    [_iconImageView2 yy_setImageWithURL:[NSURL URLWithString:[IMAGEURL(model.cover2) stringByReplacingOccurrencesOfString:@"/res" withString:@""]] placeholder:[UIImage imageNamed:@"placeholder_News2"]];
    [_iconImageView3 yy_setImageWithURL:[NSURL URLWithString:[IMAGEURL(model.cover3) stringByReplacingOccurrencesOfString:@"/res" withString:@""]] placeholder:[UIImage imageNamed:@"placeholder_News2"]];
}

- (void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    _deleteBtn.hidden = !isDelete;
}

@end
