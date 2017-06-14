//
//  ECDesignerOrderTypeView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderTypeView.h"
#import "ECHomeOptionsCollectionViewCell.h"

@interface ECDesignerOrderTypeView()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UICollectionView *contentCollectionView;

@end

@implementation ECDesignerOrderTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = ClearColor;
    
    [_contentCollectionView registerClass:[ECHomeOptionsCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeOptionsCollectionViewCell)];
    
    [self addSubview:_contentCollectionView];
    
    [_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
    }];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [self.contentCollectionView reloadData];
    [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ECHomeOptionsCollectionViewCell *cell = [ECHomeOptionsCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row][0];
    cell.isCurrent = _currentIndex == indexPath.row;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDTH - 24.f) / self.dataArray.count, 40.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndex = indexPath.row;
    if (self.didSelectIndex) {
        self.didSelectIndex(_currentIndex);
    }
}

@end
