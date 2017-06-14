//
//  ECConfirmOrderAddressCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECConfirmOrderAddressCell.h"
#import "ECAddressModel.h"

@interface ECConfirmOrderAddressCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation ECConfirmOrderAddressCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_arrow) {
        _arrow = [UIImageView new];
    }
    [self.contentView addSubview:_arrow];
    [_arrow setImage:[UIImage imageNamed:@"icon_more"]];
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
        make.right.mas_equalTo(weakSelf.mas_right).offset(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = DarkMoreColor;
    
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
    }
    [self.contentView addSubview:_phoneLabel];
    _phoneLabel.font = FONT_32;
    _phoneLabel.textColor = DarkMoreColor;
    
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
    }
    [self.contentView addSubview:_addressLabel];
    _addressLabel.font = FONT_28;
    _addressLabel.textColor = LightMoreColor;
    _addressLabel.numberOfLines = 0;
    
    if (!_descLabel) {
        _descLabel = [UILabel new];
    }
    [self.contentView addSubview:_descLabel];
    _descLabel.font = FONT_32;
    _descLabel.textColor = DarkMoreColor;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.height.mas_equalTo(weakSelf.descLabel.font.lineHeight);
        make.right.mas_equalTo(weakSelf.arrow.mas_left).offset(12.f);
    }];
    _descLabel.text = @"请设置收货地址";
    _descLabel.hidden = YES;

}

- (void)setModel:(ECAddressModel *)model {
    WEAK_SELF
    _model = model;
    
    if (model) {
        _nameLabel.text = model.consignee;
        CGFloat width = [CMPublicMethod getWidthWithLabel:_nameLabel];
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(17.f);
            make.size.mas_equalTo(CGSizeMake(width, weakSelf.nameLabel.font.lineHeight));
        }];
        _nameLabel.hidden = NO;
        
        _phoneLabel.text = model.mobile_no;
        [_phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.nameLabel.mas_right).offset(12.f);
            make.right.mas_equalTo(weakSelf.arrow.mas_left).offset(-12.f);
            make.height.centerY.mas_equalTo(weakSelf.nameLabel);
        }];
        _phoneLabel.hidden = NO;
        
        NSString *addressStr = [NSString stringWithFormat:@"%@%@",model.area,model.address];
        _addressLabel.text = addressStr;
        CGFloat addressHeight = ceilf([addressStr boundingRectWithSize:CGSizeMake(SCREENWIDTH - 24.f - 22.f - 12.f, 10000)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:_addressLabel.font}
                                                               context:nil].size.height);
        [_addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
            make.right.mas_equalTo(weakSelf.arrow.mas_left).offset(-12.f);
            make.height.mas_equalTo(addressHeight);
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(12.f);
        }];
        _addressLabel.hidden = NO;
        _descLabel.hidden = YES;
    } else {
        _nameLabel.hidden = YES;
        _phoneLabel.hidden = YES;
        _addressLabel.hidden = YES;
        _descLabel.hidden = NO;
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
