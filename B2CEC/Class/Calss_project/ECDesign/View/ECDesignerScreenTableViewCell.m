//
//  ECDesignerScreenTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerScreenTableViewCell.h"

@interface ECDesignerScreenTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@end

@implementation ECDesignerScreenTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerScreenTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerScreenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerScreenTableViewCell)];
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
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.textColor = LightMoreColor;
    _titleLab.font = FONT_28;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_titleLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = title;
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _titleLab.backgroundColor = isSelect ? UIColorFromHexString(@"e7e7e7") : [UIColor whiteColor];
}

@end
