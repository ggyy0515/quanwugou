//
//  ECProductDetailAppraiseView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductDetailAppraiseView.h"
#import "ECProductAppraisePageHeader.h"
#import "ECProductAppraiseCell.h"
#import "ECProductAppraiseModel.h"

@interface ECProductDetailAppraiseView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, copy) NSString *proId;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger maxPage;
@property (nonatomic, assign) CGFloat score;

@end

@implementation ECProductDetailAppraiseView

#pragma mark - Life Cycle

- (instancetype)initWithProId:(NSString *)proId {
    if (self = [super init]) {
        _proId = proId;
        _dataSource = [NSMutableArray array];
        [self createUI];
        [_collectionView.mj_header beginRefreshing];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = BaseColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(8, 0, 8, 0);
        layout.minimumLineSpacing = 4.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_collectionView registerClass:[ECProductAppraisePageHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraisePageHeader)];
    [_collectionView registerClass:[ECProductAppraiseCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseCell)];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf loadDataSource];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.pageNum < weakSelf.maxPage) {
            _pageNum ++;
        }
        [weakSelf loadDataSource];
    }];
}

- (void)loadDataSource {
    [ECHTTPServer requestProductAppraiseListWithPageNumber:_pageNum
                                                     proId:_proId
                                                   succeed:^(NSURLSessionDataTask *task, id result) {
                                                       [_collectionView.mj_header endRefreshing];
                                                       [_collectionView.mj_footer endRefreshing];
                                                       if (IS_REQUEST_SUCCEED(result)) {
                                                           _maxPage = [result[@"page"][@"totalPage"] integerValue];
                                                           if (_pageNum == _maxPage) {
                                                               [_collectionView.mj_footer endRefreshingWithNoMoreData];
                                                           }
                                                           if (_pageNum == 1) {
                                                               [_dataSource removeAllObjects];
                                                           }
                                                           for (NSDictionary *dic in result[@"commentList"]) {
                                                               ECProductAppraiseModel *model = [ECProductAppraiseModel yy_modelWithDictionary:dic];
                                                               [_dataSource addObject:model];
                                                           }
                                                           _score = [result[@"star_level"] floatValue];
                                                           [_collectionView reloadData];
                                                       } else {
                                                           EC_SHOW_REQUEST_ERROR_INFO
                                                       }
                                                   }
                                                    failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                        [_collectionView.mj_header endRefreshing];
                                                        [_collectionView.mj_footer endRefreshing];
                                                    }];
}


#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENWIDTH, 44.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECProductAppraiseModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    CGFloat contentHeight = ceil([model.content boundingRectWithSize:CGSizeMake(SCREENWIDTH - 24.f, 100000)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:FONT_32}
                                                             context:nil].size.height);
    CGFloat cellHeight = 280.f + contentHeight;
    if (model.imageList.count == 0) {
        cellHeight = 185.f + contentHeight;
    }
    return CGSizeMake(SCREENWIDTH, cellHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ECProductAppraisePageHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                             withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraisePageHeader)
                                                                                    forIndexPath:indexPath];
    header.score = _score;
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECProductAppraiseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseCell)
                                                                            forIndexPath:indexPath];
    ECProductAppraiseModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
