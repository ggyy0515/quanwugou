//
//  ECDesignerOrderCommentTitleTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2017/2/9.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "ECDesignerOrderCommentTitleTableViewCell.h"

@interface ECDesignerOrderCommentTitleTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@end

@implementation ECDesignerOrderCommentTitleTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerOrderCommentTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderCommentTitleTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerOrderCommentTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderCommentTitleTableViewCell)];
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
    _titleLab.text = @"用户评价";
    _titleLab.textColor = DarkMoreColor;
    _titleLab.font = FONT_B_32;
    
    [self.contentView addSubview:_titleLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(16.f);
        make.right.mas_equalTo(-12.f);
    }];
}
@end
