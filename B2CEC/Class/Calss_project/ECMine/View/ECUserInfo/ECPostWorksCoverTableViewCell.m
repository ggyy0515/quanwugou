//
//  ECPostWorksCoverTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPostWorksCoverTableViewCell.h"

@interface ECPostWorksCoverTableViewCell()

@property (strong,nonatomic) UIImageView *coverImageView;

@property (strong,nonatomic) UIButton *addBtn;

@property (strong,nonatomic) UIButton *changeBtn;

@end

@implementation ECPostWorksCoverTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECPostWorksCoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPostWorksCoverTableViewCell)];
    if (cell == nil) {
        cell = [[ECPostWorksCoverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPostWorksCoverTableViewCell)];
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
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
    }
    _coverImageView.backgroundColor = BaseColor;
    
    if (!_addBtn) {
        _addBtn = [UIButton new];
    }
    [_addBtn setTitle:@"添加封面图" forState:UIControlStateNormal];
    [_addBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    _addBtn.titleLabel.font = FONT_28;
    _addBtn.backgroundColor = [UIColor whiteColor];
    _addBtn.layer.borderColor = LineDefaultsColor.CGColor;
    _addBtn.layer.borderWidth = 1.f;
    _addBtn.layer.cornerRadius = 4.f;
    _addBtn.layer.masksToBounds = YES;
    [_addBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.selectCoverBlock) {
            weakSelf.selectCoverBlock();
        }
    }];
    
    if (!_changeBtn) {
        _changeBtn = [UIButton new];
    }
    [_changeBtn setTitle:@"修改封面图" forState:UIControlStateNormal];
    [_changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _changeBtn.titleLabel.font = FONT_28;
    _changeBtn.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
    _changeBtn.layer.cornerRadius = 4.f;
    _changeBtn.layer.masksToBounds = YES;
    _changeBtn.hidden = YES;
    [_changeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.selectCoverBlock) {
            weakSelf.selectCoverBlock();
        }
    }];
    
    [self.contentView addSubview:_coverImageView];
    [self.contentView addSubview:_addBtn];
    [self.contentView addSubview:_changeBtn];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100.f, 40.f));
        make.center.equalTo(weakSelf.contentView);
    }];
    
    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80.f, 30.f));
        make.right.bottom.mas_equalTo(-16.f);
    }];
}

- (void)setCoverImage:(UIImage *)coverImage{
    _coverImage = coverImage;
    if (_coverImage == nil) {
        return;
    }
    _addBtn.hidden = YES;
    _changeBtn.hidden = NO;
    _coverImageView.image = coverImage;
}

@end
