//
//  ECBrandStoryInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECBrandStoryInfoCell.h"
#import "ECBrandStoryInfoModel.h"

@interface ECBrandStoryInfoCell ()

@property (nonatomic, strong) UIImageView *brandImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sloganLabel;
@property (nonatomic, strong) UIButton *telBtn;

@end

@implementation ECBrandStoryInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_brandImageView) {
        _brandImageView = [UIImageView new];
    }
    [self.contentView addSubview:_brandImageView];
    [_brandImageView setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    [_brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60.f, 60.f));
    }];
    
    if (!_telBtn) {
        _telBtn = [UIButton new];
    }
    [self.contentView addSubview:_telBtn];
    [_telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(164.f / 2.f, 136.f / 2.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
    }];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 1.f, 136.f / 2.f);
    layer.backgroundColor = BaseColor.CGColor;
    [_telBtn.layer addSublayer:layer];
    [_telBtn setImage:[UIImage imageNamed:@"stroy_phone"] forState:UIControlStateNormal];
    [_telBtn setTitle:@"客服" forState:UIControlStateNormal];
    [_telBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _telBtn.titleLabel.font = FONT_28;
    [_telBtn setImageEdgeInsets:UIEdgeInsetsMake(-15.f, 10, 15.f, -10)];
    [_telBtn setTitleEdgeInsets:UIEdgeInsetsMake(18.f, -10, -18.f, 10)];
    [_telBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf showAlert];
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.textColor = DarkMoreColor;
    _nameLabel.font = FONT_32;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.brandImageView.mas_right).offset(12.f);
        make.right.mas_equalTo(weakSelf.telBtn.mas_left).offset(-12.f);
        make.top.mas_equalTo(weakSelf.brandImageView.mas_top);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
    }];
    
    if (!_sloganLabel) {
        _sloganLabel = [UILabel new];
    }
    [self.contentView addSubview:_sloganLabel];
    _sloganLabel.font = FONT_28;
    _sloganLabel.textColor = LightMoreColor;
    _sloganLabel.numberOfLines = 0;
    [_sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.bottom.mas_equalTo(weakSelf.brandImageView.mas_bottom);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(10.f);
    }];
}

- (void)setModel:(ECBrandStoryInfoModel *)model {
    _model = model;
    [_brandImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                            placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    _nameLabel.text = model.name;
    _sloganLabel.text = model.slogan;
}

- (void)showAlert {
    WEAK_SELF
    if (!_model || !_model.telephone || [_model.telephone isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"没有查询到客服电话"];
        return;
    }
    
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"拨打电话"
                                                                         andText:_model.telephone
                                                                 andCancelButton:YES
                                                                    forAlertType:AlertInfo
                                                           withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                               if (blockBtn == blockAlert.defaultButton) {
                                                                   NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", weakSelf.model.telephone]];
                                                                   [[UIApplication sharedApplication] openURL:phoneURL];
                                                               }
                                                           }];
    [alert.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert.defaultButton setTitle:@"拨打电话" forState:UIControlStateNormal];
    alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
