//
//  ECProductAttrCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAttrCell.h"
#import "ECProductAttrModel.h"


@interface ECProductAttrCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation ECProductAttrCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_28;
    _nameLabel.textColor = LightMoreColor;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.height.centerY.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo(80.f);
    }];
    
    if (!_valueLabel) {
        _valueLabel = [UILabel new];
    }
    [self.contentView addSubview:_valueLabel];
    _valueLabel.font = FONT_28;
    _valueLabel.textColor = DarkMoreColor;
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_right).offset(10.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.height.centerY.mas_equalTo(weakSelf.contentView);
    }];
    
}

- (void)setModel:(ECProductAttrModel *)model {
    _model = model;
    _nameLabel.text = model.attrName;
    _valueLabel.text = model.attrValue;
    /*
    CGFloat height = ceil([model.attrValue boundingRectWithSize:CGSizeMake(SCREENWIDTH - 24.f - 80.f - 10.f, 10000)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:_valueLabel.font}
                                                        context:nil].size.height);
    if (height < 55.f) {
        height = 55.f;
    }
     */
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
