//
//  ECSettingSwitchTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/1.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECSettingSwitchTableViewCell.h"

@interface ECSettingSwitchTableViewCell()

@property (strong,nonatomic) UILabel *messageLab;

@property (strong,nonatomic) UISwitch *messageSwitch;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECSettingSwitchTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECSettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECSettingSwitchTableViewCell)];
    if (cell == nil) {
        cell = [[ECSettingSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECSettingSwitchTableViewCell)];
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
    
    if (!_messageLab) {
        _messageLab = [UILabel new];
    }
    _messageLab.textColor = DarkMoreColor;
    _messageLab.font = FONT_32;
    
    if (!_messageSwitch) {
        _messageSwitch = [UISwitch new];
    }
    _messageSwitch.tintColor = BaseColor;
    _messageSwitch.onTintColor = DarkMoreColor;
    [_messageSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_messageLab];
    [self.contentView addSubview:_messageSwitch];
    [self.contentView addSubview:_lineView];
    
    [_messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_messageSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.messageLab.mas_centerY);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)switchChange:(UISwitch *)sender{
    if (self.switchChangeBlock) {
        self.switchChangeBlock(sender.on);
    }
}

- (void)setName:(NSString *)name{
    _name = name;
    _messageLab.text = name;
}

- (void)setOn:(BOOL)on{
    _on = on;
    _messageSwitch.on = on;
}

@end
