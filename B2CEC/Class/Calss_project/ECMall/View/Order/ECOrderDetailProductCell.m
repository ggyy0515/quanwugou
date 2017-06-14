//
//  ECOrderDetailProductCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailProductCell.h"
#import "ECOrderProductModel.h"

@interface ECOrderDetailProductCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation ECOrderDetailProductCell

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
    [_imageView setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(56.f, 56.f));
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = LightMoreColor;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.imageView.mas_top).offset(8.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
    }];
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(weakSelf.nameLabel);
        make.bottom.mas_equalTo(weakSelf.imageView.mas_bottom).offset(-8.f);
    }];

}

- (void)setModel:(ECOrderProductModel *)model {
    _model = model;
    
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    _nameLabel.text = model.name;
    
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model.amount]
                                                                                 attributes:@{NSFontAttributeName:FONT_32,
                                                                                              NSForegroundColorAttributeName:MainColor}];
    [priceAtt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@", model.count]
                                                                     attributes:@{NSFontAttributeName:FONT_24,
                                                                                  NSForegroundColorAttributeName:LightMoreColor}]];
    _priceLabel.attributedText = priceAtt;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
