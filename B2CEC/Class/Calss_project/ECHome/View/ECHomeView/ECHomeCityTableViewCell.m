//
//  ECHomeCityTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeCityTableViewCell.h"

@interface ECHomeCityTableViewCell()

@property (strong,nonatomic) UILabel *cityLab;

@end

@implementation ECHomeCityTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECHomeCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeCityTableViewCell)];
    if (cell == nil) {
        cell = [[ECHomeCityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeCityTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BaseColor;
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
    if (!_cityLab) {
        _cityLab = [UILabel new];
    }
    _cityLab.text = @"已选城市:";
    _cityLab.textColor = LightColor;
    _cityLab.font = FONT_28;
    _cityLab.backgroundColor = LineDefaultsColor;
    _cityLab.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_cityLab];
    
    [_cityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0.f);
    }];
}

- (void)setCity:(NSString *)city{
    _city = city;
    
    if (city.length == 0) {
        _cityLab.text = @"点击选择城市";
    }else{
        _cityLab.text = [NSString stringWithFormat:@"已选城市:%@",city];
    }
}

@end
