//
//  ECDesignerScreenTitleCollectionViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerScreenTitleCollectionViewCell.h"

@interface ECDesignerScreenTitleCollectionViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIImageView *dirImageView;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECDesignerScreenTitleCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath{
    ECDesignerScreenTitleCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerScreenTitleCollectionViewCell) forIndexPath:indexPath];
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
    _titleLab.font = FONT_28;
    _titleLab.textColor = LightMoreColor;
    
    if (!_dirImageView) {
        _dirImageView = [UIImageView new];
    }
    _dirImageView.image = [UIImage imageNamed:@"down"];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_dirImageView];
    [self.contentView addSubview:_lineView];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
    }];
    
    [_dirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(9.f, 5.f));
        make.centerY.mas_equalTo(weakSelf.titleLab.mas_centerY);
        make.left.mas_equalTo(weakSelf.titleLab.mas_right).offset(8.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5f, 24.f));
        make.centerY.mas_equalTo(weakSelf.titleLab.mas_centerY);
        make.right.mas_equalTo(0.f);
    }];
}

- (void)setDataStr:(NSString *)dataStr{
    _dataStr = dataStr;
    _titleLab.text = dataStr;
}

- (void)setIsHiddenLine:(BOOL)isHiddenLine{
    _isHiddenLine = isHiddenLine;
    _lineView.hidden = isHiddenLine;
}

@end
