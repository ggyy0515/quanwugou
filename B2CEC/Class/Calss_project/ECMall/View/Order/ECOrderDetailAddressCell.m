//
//  ECOrderDetailAddressCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailAddressCell.h"
#import "ECOrderListModel.h"
#import "ECPointOrderDetailInfoModel.h"

@interface ECOrderDetailAddressCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation ECOrderDetailAddressCell

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
    [_imageView setImage:[UIImage imageNamed:@"address"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.textColor = DarkMoreColor;
    _nameLabel.font = FONT_32;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(16.f);
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
    }];
    
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
    }
    [self.contentView addSubview:_addressLabel];
    _addressLabel.font = FONT_28;
    _addressLabel.textColor = LightColor;
    _addressLabel.numberOfLines = 0;
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-16.f);
        make.height.mas_equalTo(32.f);
    }];
}

- (void)setModel:(ECOrderListModel *)model {
    _model = model;
    
    NSString *nameString = [NSString stringWithFormat:@"%@，%@", model.receiver, model.mobile];
    _nameLabel.text = nameString;
    
    NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@", model.province, model.city, model.address];
    _addressLabel.text = addressString;
}

- (void)setPointModel:(ECPointOrderDetailInfoModel *)pointModel {
    _pointModel = pointModel;
    NSString *nameString = [NSString stringWithFormat:@"%@，%@", pointModel.receiver, pointModel.mobile];
    _nameLabel.text = nameString;
    
    _addressLabel.text = pointModel.address;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
