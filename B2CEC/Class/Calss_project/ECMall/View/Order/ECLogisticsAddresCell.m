//
//  ECLogisticsAddresCell.m
//  B2CEC
//
//  Created by 曙华 on 16/7/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECLogisticsAddresCell.h"

@implementation ECLogisticsAddresCell


+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECLogisticsAddresCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLogisticsAddresCell)];
    if (cell == nil) {
        cell = [[ECLogisticsAddresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLogisticsAddresCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.image = [UIImage imageNamed:@"logitImg"];
    }
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
    }
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
    }
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = BaseColor;
    }
    if (!_bottomLine) {
         _bottomLine = [UIView new];
    }
    
    
    [self.contentView addSubview:_imageV];
    
    NSString *str = @"【深圳市】 快件已到达 深圳转运中心我的大吊早已饥渴难耐";
    CGFloat addressHeight = [CMPublicMethod getHeightWithContent:str width:SCREENWIDTH-48 font:14.f];
    
    _addressLabel.font = [UIFont systemFontOfSize:14.f];
    _addressLabel.textColor = LightColor;
    _addressLabel.numberOfLines = 0;
    _addressLabel.text = str;
    [self.contentView addSubview:_addressLabel];
    
    _dateLabel.font = [UIFont systemFontOfSize:12.f];
    _dateLabel.textColor = LightColor;
    _dateLabel.text = @"2016/07/12 20:00";
    [self.contentView addSubview:_dateLabel];
    
    [self.contentView addSubview:_topLine];
   
    _bottomLine.backgroundColor = BaseColor;
    [self.contentView addSubview:_bottomLine];
    
    WEAK_SELF
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf);
        make.width.mas_equalTo(@(1));
        make.left.mas_equalTo(@(14.5));
        make.height.mas_equalTo(@(18));
    }];
    
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(18));
        make.left.mas_equalTo(@(12));
        make.height.mas_equalTo(@(6));
        make.width.mas_equalTo(@(6));
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imageV.mas_bottom);
        make.width.mas_equalTo(@(1));
        make.left.mas_equalTo(@(14.5));
        make.bottom.mas_equalTo(weakSelf);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(addressHeight);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.bottom.mas_equalTo(weakSelf).offset(-17);
    }];

}


- (void)setIsFristOrFinall:(NSInteger)isFristOrFinall{
    _isFristOrFinall = isFristOrFinall;
    
    switch (isFristOrFinall) {
        case 0:{
            _bottomLine.hidden = NO;
            _topLine.hidden = NO;
            _addressLabel.textColor =  LightColor;
            _dateLabel.textColor = LightColor;
            [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(@(12));
                make.height.mas_equalTo(@(6));
                make.width.mas_equalTo(@(6));
            }];
            _imageV.image = [UIImage imageNamed:@"logitImg"];
        }
          
            break;
        case 1:{
            _bottomLine.hidden = NO;
            _topLine.hidden = YES;
            _addressLabel.textColor =  UIColorFromHexString(@"#3cdc78");
            _dateLabel.textColor = UIColorFromHexString(@"#3cdc78");
            [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(13);
                make.width.mas_equalTo(13);
                make.left.mas_equalTo(8);
            }];
            _imageV.image = [UIImage imageNamed:@"select_logitImg"];
        }
            break;
            
        case 2:{
            _topLine.hidden = NO;
            _bottomLine.hidden = YES;
            
            _addressLabel.textColor =  LightColor;
            _dateLabel.textColor = LightColor;
            [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(@(12));
                make.height.mas_equalTo(@(6));
                make.width.mas_equalTo(@(6));
            }];
            _imageV.image = [UIImage imageNamed:@"logitImg"];
        }
            break;
            
        default:
            break;
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
