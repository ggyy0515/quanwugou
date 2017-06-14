//
//  ECMallTagView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallTagView.h"
#import "ECMallTagModel.h"
#import "ECMallTagViewCell.h"

@interface ECMallTagView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation ECMallTagView

#pragma mark - Life cycle

- (instancetype)init {
    if (self = [super init]) {
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
        layout.sectionInset = UIEdgeInsetsMake(0, 12.f, 0, 0);
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
    _collectionView.scrollsToTop = NO;
    [_collectionView registerClass:[ECMallTagViewCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallTagViewCell)];
}

#pragma mark - Setter

- (void)setDataSource:(NSMutableArray<ECMallTagModel *> *)dataSource {
    _dataSource = dataSource.mutableCopy;
    ECMallTagModel *model = [_dataSource objectAtIndexWithCheck:0];
    if (model) {
        model.isSel = YES;
    }
    [_collectionView reloadData];
}

#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallTagModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    CGFloat width = ceilf([model.name boundingRectWithSize:CGSizeMake(10000, 14.f)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:FONT_28}
                                                    context:nil].size.width) + 24.f;
    return CGSizeMake(width, 33.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallTagViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallTagViewCell)
                                                                        forIndexPath:indexPath];
    ECMallTagModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_dataSource enumerateObjectsUsingBlock:^(ECMallTagModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row) {
            model.isSel = YES;
        } else {
            model.isSel = NO;
        }
    }];
    [collectionView reloadData];
    if (_didSelectCatAtIndex) {
        _didSelectCatAtIndex(indexPath.row);
    }
    [collectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                   animated:YES];
}

#pragma mark - Interface

+ (instancetype)showTagInView:(UIView *)view dataSource:(NSMutableArray *)dataSource {
    typeof(view) __weak weakView = view;
    ECMallTagView *tagView = [[self alloc] init];
    [view addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakView);
        make.height.mas_equalTo(33.f);
    }];
    [tagView setDataSource:dataSource];
    return tagView;
}

- (void)scrollToIndex:(NSInteger)index {
    [_dataSource enumerateObjectsUsingBlock:^(ECMallTagModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            model.isSel = YES;
        } else {
            model.isSel = NO;
        }
    }];
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
