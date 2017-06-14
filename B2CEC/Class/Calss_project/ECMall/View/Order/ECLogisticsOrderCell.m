//
//  ECLogisticsOrderCell.m
//  B2CEC
//
//  Created by 曙华 on 16/7/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECLogisticsOrderCell.h"

@interface ECLogisticsOrderCell()
/**
 *  图片
 */
@property (nonatomic, strong) UIImageView *imageV;
/**
 *  物流状态
 */
@property (nonatomic, strong) UILabel *topLabel;
/**
 *  信息来源
 */
@property (nonatomic, strong) UILabel *bottomLabel;
/**
 *  物流单号
 */
@property (nonatomic, strong) UILabel *logisticsLabel;

@end

@implementation ECLogisticsOrderCell


+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECLogisticsOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLogisticsOrderCell)];
    if (cell == nil) {
        cell = [[ECLogisticsOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLogisticsOrderCell)];
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
    }
    if (!_topLabel) {
        _topLabel = [UILabel new];
    }
    if (!_bottomLabel) {
        _bottomLabel = [UILabel new];
    }
    if (!_logisticsLabel) {
        _logisticsLabel = [UILabel new];
    }
    
     _imageV.image = [UIImage imageNamed:@"placeholder_goods1"];
    [self.contentView addSubview:_imageV];
    
    NSMutableAttributedString *att = [NSMutableAttributedString new];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"物流状态: " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f],NSForegroundColorAttributeName:DarkColor}]];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f],NSForegroundColorAttributeName:MainColor}]];
    _topLabel.attributedText = att;
    [self.contentView addSubview:_topLabel];
    
    _bottomLabel.font = [UIFont systemFontOfSize:12.f];
    _bottomLabel.textColor = LightMoreColor;
    _bottomLabel.text = @"信息来源：圆通速递";
    [self.contentView addSubview:_bottomLabel];
    
    _logisticsLabel.font = [UIFont systemFontOfSize:12.f];
    _logisticsLabel.textColor = LightMoreColor;
    _logisticsLabel.text = @"物流订单：2016061223659";
    [self.contentView addSubview:_logisticsLabel];
    
    
    WEAK_SELF
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(@(8));
        make.height.mas_equalTo(@(56));
        make.width.mas_equalTo(@(56));
    }];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imageV.mas_top);
        make.left.mas_equalTo(weakSelf.imageV.mas_right).offset(8);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topLabel.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(weakSelf.imageV.mas_right).offset(8);
    }];
    
    [_logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.bottomLabel.mas_bottom);
        make.left.mas_equalTo(weakSelf.imageV.mas_right).offset(8);
    }];
    
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [_imageV yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(imageUrl)] placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
}

- (void)setExpress:(NSString *)express{
    _express = express;
    _bottomLabel.text = [NSString stringWithFormat:@"物流公司：%@",express];
    
}

- (void)setLogisticsNum:(NSString *)logisticsNum{
    _logisticsNum = logisticsNum;
    _logisticsLabel.text = [NSString stringWithFormat:@"物流单号：%@",logisticsNum];
}

- (void)setLogisticsState:(NSString *)logisticsState{
    _logisticsState = logisticsState;
    
    if (logisticsState == nil) {
        return ;
    }
    
    NSInteger state = [logisticsState integerValue];
    NSString *stateStr;
    switch (state) {
        case 0:
            stateStr = @"在途中";
            break;
        case 2:
            stateStr = @"揽件中";
            break;
        case 3:
            stateStr = @"已签收";
            break;
        case 4:
            stateStr = @"退签中";
            break;
        case 5:
            stateStr = @"派件中";
            break;
        case 6:
            stateStr = @"退回中";
            break;
        default:
            break;
    }
    NSMutableAttributedString *att = [NSMutableAttributedString new];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"物流状态: " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f],NSForegroundColorAttributeName:DarkColor}]];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",stateStr] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f],NSForegroundColorAttributeName:MainColor}]];
    _topLabel.attributedText = att;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
