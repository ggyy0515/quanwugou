//
//  ECFilterCollectionViewCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECFilterCollectionViewCell.h"

@interface ECFilterCollectionViewCell ()



@end

@implementation ECFilterCollectionViewCell

+ (instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath{
    ECFilterCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECFilterCollectionViewCell) forIndexPath:indexPath];
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.textColor = LightMoreColor;
    _titleLab.font = [UIFont systemFontOfSize:14.f];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLab.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
