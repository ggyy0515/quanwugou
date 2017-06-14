//
//  ECProductGuaranteeCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductGuaranteeCell.h"
#import "ECProductGuaranteeSubCell.h"

@interface ECProductGuaranteeCell ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat miny;

@property (nonatomic, assign) CGFloat maxy;

@end

@implementation ECProductGuaranteeCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 12.f, 0, 12.f);
        layout.minimumInteritemSpacing = 24.f;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [self.contentView addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[ECProductGuaranteeSubCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductGuaranteeSubCell)];
}

#pragma mark - Setter

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [_collectionView reloadData];
}

#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECProductGuaranteeSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductGuaranteeSubCell)
                                                                                forIndexPath:indexPath];
    cell.title = [_titles objectAtIndexWithCheck:indexPath.row];
    if (indexPath.row == 0) {
        _miny = cell.y;
    }
    if (indexPath.row == _titles.count - 1) {
        _maxy = cell.maxY;
        _didGetCellHeight(_maxy - _miny);
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [_titles objectAtIndexWithCheck:indexPath.row];
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(10000, 31.f)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:FONT_24}
                                              context:nil].size.width + 18.f + 4.f);
    return CGSizeMake(width, 31.f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
