//
//  ECDesignerOrderDetailUserInfoTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderDetailUserInfoTableViewCell.h"

@interface ECDesignerOrderDetailUserInfoTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UIButton *chatBtn;

@property (strong,nonatomic) UIView *lineView1;

@property (strong,nonatomic) UILabel *startDateNameLab;

@property (strong,nonatomic) UILabel *startDateDataLab;

@property (strong,nonatomic) UILabel *endDateNameLab;

@property (strong,nonatomic) UILabel *endDateDataLab;

@property (strong,nonatomic) UIView *lineView2;
@end

@implementation ECDesignerOrderDetailUserInfoTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerOrderDetailUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderDetailUserInfoTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerOrderDetailUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderDetailUserInfoTableViewCell)];
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
    _iconImageView.layer.cornerRadius = 49.f / 2.f;
    _iconImageView.layer.masksToBounds = YES;
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.textColor = LightMoreColor;
    _nameLab.font = FONT_32;
    
    if (!_chatBtn) {
        _chatBtn = [UIButton new];
    }
    [_chatBtn setTitle:@"联系TA" forState:UIControlStateNormal];
    [_chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _chatBtn.backgroundColor = MainColor;
    _chatBtn.layer.cornerRadius = 5.f;
    _chatBtn.layer.masksToBounds = YES;
    [_chatBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.chatClickBlock) {
            weakSelf.chatClickBlock();
        }
    }];
    
    if (!_lineView1) {
        _lineView1 = [UIView new];
    }
    _lineView1.backgroundColor = LineDefaultsColor;
    
    if (!_startDateNameLab) {
        _startDateNameLab = [UILabel new];
    }
    _startDateNameLab.text = @"下单时间";
    _startDateNameLab.font = FONT_24;
    _startDateNameLab.textColor = LightMoreColor;
    
    if (!_startDateDataLab) {
        _startDateDataLab = [UILabel new];
    }
    _startDateDataLab.font = FONT_24;
    _startDateDataLab.textColor = LightColor;
    
    if (!_endDateNameLab) {
        _endDateNameLab = [UILabel new];
    }
    _endDateNameLab.text = @"完成时间";
    _endDateNameLab.font = FONT_24;
    _endDateNameLab.textColor = LightMoreColor;
    
    if (!_endDateDataLab) {
        _endDateDataLab = [UILabel new];
    }
    _endDateDataLab.font = FONT_24;
    _endDateDataLab.textColor = LightColor;
    
    if (!_lineView2) {
        _lineView2 = [UIView new];
    }
    _lineView2.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_chatBtn];
    [self.contentView addSubview:_lineView1];
    [self.contentView addSubview:_startDateNameLab];
    [self.contentView addSubview:_startDateDataLab];
    [self.contentView addSubview:_endDateNameLab];
    [self.contentView addSubview:_endDateDataLab];
    [self.contentView addSubview:_lineView2];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(33.f / 2.f);
        make.size.mas_equalTo(CGSizeMake(49.f, 49.f));
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(27.f);
        make.centerY.mas_equalTo(weakSelf.iconImageView.mas_centerY);
    }];
    
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100.f, 32.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.nameLab.mas_centerY);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(82.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_startDateNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(weakSelf.lineView1.mas_bottom).offset(10.f);
    }];
    
    [_startDateDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.bottom.mas_equalTo(-10.f);
    }];
    
    [_endDateNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.lineView1.mas_bottom).offset(10.f);
    }];
    
    [_endDateDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(-10.f);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.lineView1);
        make.bottom.mas_equalTo(0.f);
    }];
}

- (void)setIsDesigner:(BOOL)isDesigner{
    _isDesigner = isDesigner;
}

- (void)setModel:(ECDesignerOrderDetailModel *)model{
    _model = model;
    
    _startDateDataLab.text = model.createdate;
    _endDateDataLab.hidden = model.updatedate.length == 0;
    _endDateNameLab.hidden = model.updatedate.length == 0;
    _endDateDataLab.text = model.updatedate;
    
    if (_isDesigner) {
        [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.utitle_img)] placeholder:[UIImage imageNamed:@"face1"]];
        _nameLab.text = model.uname;
    }else{
        [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.dtitle_img)] placeholder:[UIImage imageNamed:@"face1"]];
        _nameLab.text = model.dname;
    }
}

@end
