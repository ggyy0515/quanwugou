//
//  ECDesignerOrderDetailAddressTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderDetailAddressTableViewCell.h"

@interface ECDesignerOrderDetailAddressTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *addressLab;

@property (strong,nonatomic) UIImageView *dirImageView;

@end

@implementation ECDesignerOrderDetailAddressTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerOrderDetailAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderDetailAddressTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerOrderDetailAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderDetailAddressTableViewCell)];
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
    _iconImageView.image = [UIImage imageNamed:@"address"];
    
    if (!_addressLab) {
        _addressLab = [UILabel new];
    }
    _addressLab.textColor = LightColor;
    _addressLab.font = FONT_32;
    _addressLab.numberOfLines = 2;
    
    if (!_dirImageView) {
        _dirImageView = [UIImageView new];
    }
    _dirImageView.image = [UIImage imageNamed:@"enter"];
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_addressLab];
    [self.contentView addSubview:_dirImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(16.f);
        make.right.mas_equalTo(weakSelf.dirImageView.mas_left).offset(-16.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_dirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)setLocation:(NSString *)location{
    _location = location;
    _addressLab.text = location;
}

@end
