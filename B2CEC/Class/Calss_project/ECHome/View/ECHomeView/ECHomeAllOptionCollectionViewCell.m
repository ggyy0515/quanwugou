//
//  ECHomeAllOptionCollectionViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/16.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeAllOptionCollectionViewCell.h"

@interface ECHomeAllOptionCollectionViewCell()

@property (strong,nonatomic) UIView *bgView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIImageView *deleteImageView;

@end

@implementation ECHomeAllOptionCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath{
    ECHomeAllOptionCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeAllOptionCollectionViewCell) forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBasicUI];
    }
    return self;
}
- (void)createBasicUI{
    if (!_bgView) {
        _bgView = [UIView new];
    }
    _bgView.backgroundColor = OptionsBaseColor;
    _bgView.layer.cornerRadius = 14.f;
    _bgView.layer.masksToBounds = YES;
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"头条";
    _titleLab.font = FONT_28;
    _titleLab.textColor = LightMoreColor;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    if (!_deleteImageView) {
        _deleteImageView = [UIImageView new];
    }
    _deleteImageView.image = [UIImage imageNamed:@"navdown_close2"];
    
    [self.contentView addSubview:_bgView];
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_deleteImageView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(4.f);
        make.right.mas_equalTo(-4.f);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(4.f);
        make.right.mas_equalTo(-4.f);
    }];
    
    [_deleteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0.f);
        make.width.height.mas_equalTo(16.f);
    }];
}

- (void)setModel:(ECNewsTypeModel *)model{
    _model = model;
    
    _titleLab.text = model.NAME;
}

- (void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    
    _deleteImageView.hidden = !isDelete;
}

- (void)setIsFixed:(BOOL)isFixed{
    _isFixed = isFixed;
    
    _titleLab.textColor = isFixed ? LightPlaceholderColor : LightMoreColor;
}

@end
