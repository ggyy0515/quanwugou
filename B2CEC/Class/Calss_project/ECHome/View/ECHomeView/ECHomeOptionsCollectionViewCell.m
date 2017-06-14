
//
//  ECHomeOptionsCollectionViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeOptionsCollectionViewCell.h"

@interface ECHomeOptionsCollectionViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECHomeOptionsCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath{
    ECHomeOptionsCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeOptionsCollectionViewCell) forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBasicUI];
    }
    return self;
}
- (void)createBasicUI{
    WEAK_SELF
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:17.f];
    _titleLab.textColor = DarkMoreColor;
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = MainColor;
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_lineView];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(2.f);
        make.left.right.equalTo(weakSelf.titleLab);
    }];
}

- (void)setTitle:(NSString *)title{
    WEAK_SELF
    _title = title;
    _titleLab.text = title;
    CGFloat width = [title boundingRectWithSize:CGSizeMake(10000, 17.f)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]}
                                             context:nil].size.width;
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-3.f);
        make.height.mas_equalTo(2.f);
        make.centerX.mas_equalTo(weakSelf.titleLab.mas_centerX);
        make.width.mas_equalTo(width);
    }];
}

- (void)setIsCurrent:(BOOL)isCurrent{
    _isCurrent = isCurrent;
    _lineView.hidden = !isCurrent;
    if (isCurrent) {
        _titleLab.textColor = MainColor;
    } else {
        _titleLab.textColor = LightMoreColor;
    }
}

@end
