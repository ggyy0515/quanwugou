//
//  ECPostWorksInputTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPostWorksInputTableViewCell.h"

@interface ECPostWorksInputTableViewCell()

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UITextField *dataTF;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECPostWorksInputTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECPostWorksInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPostWorksInputTableViewCell)];
    if (cell == nil) {
        cell = [[ECPostWorksInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPostWorksInputTableViewCell)];
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
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.textColor = LightColor;
    _nameLab.font = FONT_32;
    
    if (!_dataTF) {
        _dataTF = [UITextField new];
    }
    [_dataTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _dataTF.textColor = DarkMoreColor;
    _dataTF.font = FONT_32;
    [_dataTF handleControlEvent:UIControlEventEditingDidEnd withBlock:^(UITextField *sender) {
        if (weakSelf.selectTypeBlock) {
            weakSelf.selectTypeBlock(sender.text);
        }
    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_dataTF];
    [self.contentView addSubview:_lineView];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
        make.width.mas_equalTo(76.f);
    }];
    
    [_dataTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLab.mas_right);
        make.right.mas_equalTo(-12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setName:(NSString *)name WithPlaceholder:(NSString *)placeholder{
    _nameLab.text = name;
    _dataTF.placeholder = placeholder;
}

@end
