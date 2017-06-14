//
//  ECBankCardListCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECBankCardListCell.h"
#import "ECBankCardListModel.h"

@interface ECBankCardListCell ()

@property (nonatomic, strong) UIImageView *cardIcon;
@property (nonatomic, strong) UILabel *cardNoLabel;
@property (nonatomic, strong) UILabel *bankNameLabel;

@end

@implementation ECBankCardListCell

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
    
    NSMutableArray *rightBtns = [NSMutableArray array];
    [rightBtns sw_addUtilityButtonWithColor:UIColorFromHexString(@"#ff3b30")
                                 normalIcon:[UIImage imageNamed:@"home_close"]
                               selectedIcon:[UIImage imageNamed:@"home_close"]];
    self.rightUtilityButtons = rightBtns;
    
    if (!_cardIcon) {
        _cardIcon = [UIImageView new];
    }
    [self.contentView addSubview:_cardIcon];
    [_cardIcon setImage:[UIImage imageNamed:@"face1"]];
    [_cardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(15.f);
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
    }];
    
    if (!_bankNameLabel) {
        _bankNameLabel = [UILabel new];
    }
    [self.contentView addSubview:_bankNameLabel];
    _bankNameLabel.font = FONT_32;
    _bankNameLabel.textColor = LightMoreColor;
    
    if (!_cardNoLabel) {
        _cardNoLabel = [UILabel new];
    }
    [self.contentView addSubview:_cardNoLabel];
    _cardNoLabel.font = FONT_32;
    _cardNoLabel.textColor = LightMoreColor;
    _cardNoLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setModel:(ECBankCardListModel *)model {
    WEAK_SELF
    _model = model;
    
    [_cardIcon yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                      placeholder:[UIImage imageNamed:@"face1"]];
    
    _bankNameLabel.text = model.bankName;
    CGFloat width = [CMPublicMethod getWidthWithLabel:_bankNameLabel];
    [_bankNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.cardIcon.mas_right).offset(10.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo(width);
    }];
    
    if (model.bankNo.length >= 4) {
        NSString *shortNum = [model.bankNo substringWithRange:NSMakeRange(model.bankNo.length - 4, 4)];
        NSString *cardNo = [NSString stringWithFormat:@"**** **** **** %@", shortNum];
        _cardNoLabel.text = cardNo;
    }
    [_cardNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bankNameLabel.mas_right);
        make.right.mas_equalTo(-12.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
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
