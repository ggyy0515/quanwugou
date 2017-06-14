//
//  ECDesignerRegisterAddImageTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/30.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerRegisterAddImageTableViewCell.h"

@interface ECDesignerRegisterAddImageTableViewCell()

@property (strong,nonatomic) UIButton *addBtn;

@end

@implementation ECDesignerRegisterAddImageTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerRegisterAddImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterAddImageTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerRegisterAddImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterAddImageTableViewCell)];
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
    if (!_addBtn) {
        _addBtn = [UIButton new];
    }
    [_addBtn setImage:[UIImage imageNamed:@"addimg"] forState:UIControlStateNormal];
    [_addBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.addImageBlock) {
            weakSelf.addImageBlock();
        }
    }];
    
    [self.contentView addSubview:_addBtn];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
}

@end
