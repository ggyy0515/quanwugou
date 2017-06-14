//
//  ECUserInfoDesignerExpressTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoDesignerExpressTableViewCell.h"

@interface ECUserInfoDesignerExpressTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIView *titleLineView;

@property (strong,nonatomic) UILabel *contentLab;

@end

@implementation ECUserInfoDesignerExpressTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECUserInfoDesignerExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoDesignerExpressTableViewCell)];
    if (cell == nil) {
        cell = [[ECUserInfoDesignerExpressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoDesignerExpressTableViewCell)];
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
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"职业历程";
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.backgroundColor = UIColorFromHexString(@"5e5e61");
    _titleLab.font = FONT_32;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    if (!_titleLineView) {
        _titleLineView = [UIView new];
    }
    _titleLineView.backgroundColor = UIColorFromHexString(@"5e5e61");
    
    if (!_contentLab) {
        _contentLab = [UILabel new];
    }
    _contentLab.textColor = DarkColor;
    _contentLab.font = FONT_32;
    _contentLab.numberOfLines = 0;
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_titleLineView];
    [self.contentView addSubview:_contentLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30.f);
        make.left.mas_equalTo(12.f);
        make.height.mas_equalTo(28.f);
        make.width.mas_equalTo(80.f);
    }];
    
    [_titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(weakSelf.titleLab.mas_bottom);
        make.height.mas_equalTo(1.f);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLineView);
        make.top.mas_equalTo(weakSelf.titleLineView.mas_bottom).offset(20.f);
    }];
}

- (void)setContent:(NSString *)content{
    _content = content;
    _contentLab.text = content;
}

@end
