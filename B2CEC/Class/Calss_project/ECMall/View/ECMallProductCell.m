//
//  ECMallProductCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallProductCell.h"
#import "ECMallProductModel.h"
#import "ECPointProductListModel.h"

@interface ECMallProductCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation ECMallProductCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView setImage:[UIImage imageNamed:@"placeholder_goods2"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo((SCREENWIDTH - 24.f) / 2.f);
    }];
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    [self.contentView addSubview:_contentLabel];
    _contentLabel.textColor = LightColor;
    _contentLabel.font = FONT_24;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).offset(10.f);
        make.height.mas_equalTo(12.f);
    }];
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_priceLabel];
    _priceLabel.font = FONT_28;
    _priceLabel.textColor = DarkColor;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.imageView);
        make.height.mas_equalTo(14.f);
        make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom).offset(10.f);
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

- (void)setModel:(ECMallProductModel *)model {
    _model = model;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
    _contentLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
}

- (void)setPointModel:(ECPointProductListModel *)pointModel {
    _pointModel = pointModel;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(pointModel.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
    _contentLabel.text = pointModel.name;
    _priceLabel.text = [NSString stringWithFormat:@"%@积分", pointModel.point];
}

- (void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    _deleteBtn.hidden = !isDelete;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
