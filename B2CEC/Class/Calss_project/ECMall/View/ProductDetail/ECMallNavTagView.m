//
//  ECMallNavTagView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallNavTagView.h"
#import "ECMallNavTagViewCell.h"

@interface ECMallNavTagView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ECMallNavTagView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[ECMallNavTagViewCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallNavTagViewCell)];
}

#pragma mark - Setter

- (void)scrollToIndex:(NSInteger)index {
    self.currentIndex = index;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [_collectionView reloadData];
}

- (void)setDataSource:(NSMutableArray *)dataSource currentIndex:(NSInteger)currentIndex {
    _dataSource = dataSource;
    _currentIndex = currentIndex;
    [_collectionView reloadData];
}


#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [_dataSource objectAtIndexWithCheck:indexPath.row];
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(10000, 14.f)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:FONT_28}
                                              context:nil].size.width) + 24.f;
    return CGSizeMake(width, 33.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallNavTagViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallNavTagViewCell)
                                                                        forIndexPath:indexPath];
    NSString *title = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.title = title;
    if (indexPath.row == _currentIndex) {
        cell.titleLabel.textColor = MainColor;
        cell.line.hidden = NO;
    } else {
        cell.titleLabel.textColor = LightMoreColor;
        cell.line.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setCurrentIndex:indexPath.row];
    [collectionView reloadData];
    if (_didSelectIndex) {
        _didSelectIndex(indexPath.row);
    }
//    [collectionView scrollToItemAtIndexPath:indexPath
//                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
//                                   animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
