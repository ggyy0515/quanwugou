//
//  ECCartProductCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCartProductCell.h"
#import "ECCartProductModel.h"


@interface ECCartProductCell ()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIImageView *imageIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIView *line;

@end

@implementation ECCartProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!_selectBtn) {
        _selectBtn = [UIButton new];
    }
    [self.contentView addSubview:_selectBtn];
    [_selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_selectBtn setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
    }];
    [_selectBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.model.isSelectet = !weakSelf.model.isSelectet;
        sender.selected = weakSelf.model.isSelectet;
        if (weakSelf.clickSelectBtn) {
            weakSelf.clickSelectBtn();
        }
    }];
    
    if (!_imageIV) {
        _imageIV = [UIImageView new];
    }
    [self.contentView addSubview:_imageIV];
    [_imageIV setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    [_imageIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.selectBtn.mas_right).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(64.f, 64.f));
    }];
    
    if (!_countLabel) {
        _countLabel = [UILabel new];
    }
    [self.contentView addSubview:_countLabel];
    _countLabel.font = FONT_28;
    _countLabel.textColor = LightColor;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80.f, 14.f));
    }];
    
    if (!_addBtn) {
        _addBtn = [UIButton new];
    }
    [self.contentView addSubview:_addBtn];
    [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.countLabel.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.countLabel.mas_top).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
    }];
    [_addBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.model.count = [NSString stringWithFormat:@"%ld", weakSelf.model.count.integerValue + 1];
        weakSelf.countLabel.text = weakSelf.model.count;
        if (weakSelf.changeCountBlock) {
            weakSelf.changeCountBlock();
        }
    }];
    
    if (!_subBtn) {
        _subBtn = [UIButton new];
    }
    [self.contentView addSubview:_subBtn];
    [_subBtn setImage:[UIImage imageNamed:@"less"] forState:UIControlStateNormal];
    [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.countLabel.mas_centerX);
        make.top.mas_equalTo(weakSelf.countLabel.mas_bottom).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
    }];
    [_subBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.model.count.integerValue > 1) {
            weakSelf.model.count = [NSString stringWithFormat:@"%ld", weakSelf.model.count.integerValue - 1];
            weakSelf.countLabel.text = weakSelf.model.count;
            if (weakSelf.changeCountBlock) {
                weakSelf.changeCountBlock();
            }
        }
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = LightMoreColor;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imageIV.mas_top).offset(8.f);
        make.left.mas_equalTo(weakSelf.imageIV.mas_right).offset(12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
        make.right.mas_equalTo(weakSelf.countLabel.mas_left).offset(-10.f);
    }];
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self.contentView addSubview:_priceLabel];
    _priceLabel.font = FONT_32;
    _priceLabel.textColor = UIColorFromHexString(@"#1a191e");
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.left.mas_equalTo(weakSelf.nameLabel);
        make.bottom.mas_equalTo(weakSelf.imageIV.mas_bottom).offset(-8.f);
    }];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = UIColorFromHexString(@"#DDDDDD");
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setModel:(ECCartProductModel *)model {
    _model = model;
    
    [_imageIV yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                     placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    _nameLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    _countLabel.text = model.count;
    if (model.isSelectet) {
        _selectBtn.selected = YES;
    } else {
        _selectBtn.selected = NO;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
