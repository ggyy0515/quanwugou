//
//  ECOrderDetailLogisticsInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailLogisticsInfoCell.h"
#import "ECOrderListModel.h"

@interface ECOrderDetailLogisticsInfoCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *comLabel;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UILabel *checkLabel;

@end

@implementation ECOrderDetailLogisticsInfoCell

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
    [_imageView setImage:[UIImage imageNamed:@"iconfont-icon-yxj-express"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
    }];
    
    if (!_arrow) {
        _arrow = [UIImageView new];
    }
    [self.contentView addSubview:_arrow];
    [_arrow setImage:[UIImage imageNamed:@"icon_more"]];
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
    }];
    
    if (!_comLabel) {
        _comLabel = [UILabel new];
    }
    [self.contentView addSubview:_comLabel];
    _comLabel.textColor = UIColorFromHexString(@"#333333");
    _comLabel.font = FONT_32;
    
    if (!_checkLabel) {
        _checkLabel = [UILabel new];
    }
    [self.contentView addSubview:_checkLabel];
    _checkLabel.font = FONT_32;
    _checkLabel.textColor = LightColor;
    _checkLabel.textAlignment = NSTextAlignmentRight;
    _checkLabel.text = @"查看物流";
}

- (void)setModel:(ECOrderListModel *)model {
    _model = model;
    if (!model) {
        _imageView.hidden = YES;
        _comLabel.hidden = YES;
        _checkLabel.hidden = YES;
        _arrow.hidden = YES;
    } else {
        _imageView.hidden = NO;
        _comLabel.hidden = NO;
        _checkLabel.hidden = NO;
        _arrow.hidden = NO;
    }
    WEAK_SELF
    
    _comLabel.text = model.express;
    CGFloat width = [CMPublicMethod getWidthWithLabel:_comLabel];
    [_comLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.comLabel.font.lineHeight));
    }];
    
    [_checkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.arrow.mas_left).offset(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.height.mas_equalTo(weakSelf.checkLabel.font.lineHeight);
        make.left.mas_equalTo(weakSelf.comLabel.mas_right);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
