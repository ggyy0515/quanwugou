//
//  ECProductDetailProductView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductDetailProductView.h"
#import "ECProductCycleCell.h"
#import "ECProductInfoCell.h"
#import "ECProductInfoModel.h"
#import "ECProductGuaranteeCell.h"
#import "ECProductSelectionCell.h"
#import "ECProductAppraiseHeader.h"
#import "ECProductAppraiseCell.h"
#import "ECProductAppraiseModel.h"
#import "ECProductAppraiseFooter.h"
#import "ECProductAttrViewController.h"
#import "ECProductAttrModel.h"
#import "ECProductPanicBuyInfoCell.h"
#import "ECCartFactoryModel.h"
#import "ECCartProductModel.h"

@interface ECProductDetailProductView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, copy) NSString *protable;
@property (nonatomic, copy) NSString *proId;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cycleImageList;
@property (nonatomic, strong) ECProductInfoModel *infoModel;

@property (nonatomic, assign) BOOL needReloadGuarantee;
@property (nonatomic, assign) CGFloat guaranteeHeight;
@property (nonatomic, strong) NSMutableArray *guaranteeDataSource;

@property (nonatomic, strong) NSMutableArray *appraiseDataSource;

@property (nonatomic, strong) NSMutableArray *attrDataSource;

/**
 定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ECProductDetailProductView

#pragma mark - Life Cycle

- (instancetype)initWithProtable:(NSString *)protable proId:(NSString *)proId {
    if (self = [super init]) {
        _protable = protable;
        _proId = proId;
        _cycleImageList = [NSMutableArray array];
        _appraiseDataSource = [NSMutableArray array];
        _guaranteeDataSource = [NSMutableArray array];
        _attrDataSource = [NSMutableArray array];
        _needReloadGuarantee = YES;
        _guaranteeHeight = 1000.f;
        [self createUI];
        [self loadDataSource];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)createUI {
    WEAK_SELF
    
    self.backgroundColor = BaseColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECProductCycleCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductCycleCell)];
    [_collectionView registerClass:[ECProductInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductInfoCell)];
    [_collectionView registerClass:[ECProductPanicBuyInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductPanicBuyInfoCell)];
    [_collectionView registerClass:[ECProductGuaranteeCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductGuaranteeCell)];
    [_collectionView registerClass:[ECProductSelectionCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductSelectionCell)];
    [_collectionView registerClass:[ECProductAppraiseHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseHeader)];
    [_collectionView registerClass:[ECProductAppraiseCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseCell)];
    [_collectionView registerClass:[ECProductAppraiseFooter class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseFooter)];
    _collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        if (weakSelf.checkWebDetailAction) {
            weakSelf.checkWebDetailAction();
        }
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }];
    [(MJRefreshBackStateFooter *)_collectionView.mj_footer setTitle:@"上拉查看详情" forState:MJRefreshStateIdle];
    [(MJRefreshBackStateFooter *)_collectionView.mj_footer setTitle:@"松开立即加载" forState:MJRefreshStatePulling];
    [(MJRefreshBackStateFooter *)_collectionView.mj_footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
}



#pragma mark - Actions

- (void)loadDataSource {
    [ECHTTPServer requestProductDetailWithProTable:_protable
                                             proId:_proId
                                            userId:[Keychain objectForKey:EC_USER_ID]
                                           succeed:^(NSURLSessionDataTask *task, id result) {
                                               if (IS_REQUEST_SUCCEED(result)) {
                                                   ECLog(@"->>>%@",result);
                                                   //轮播图数据解析
                                                   [_cycleImageList removeAllObjects];
                                                   [result[@"info"][@"images"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                       NSString *str = IMAGEURL(dic[@"url"]);
                                                       if (idx == 0) {
                                                           if (_didLoadProductAnimationPic) {
                                                               _didLoadProductAnimationPic([NSURL URLWithString:str]);
                                                           }
                                                       }
                                                       [_cycleImageList addObject:str];
                                                   }];
                                                   //商品信息解析
                                                   _infoModel = [ECProductInfoModel yy_modelWithDictionary:result[@"info"][@"product"]];
                                                   if (_getProductTitleBlock) {
                                                       _getProductTitleBlock(_infoModel.name);
                                                   }
                                                   if (_infoModel && _didLoadProductSerise) {
                                                       //获取到系列
                                                       _didLoadProductSerise(STR_EXISTS(_infoModel.serise));
                                                   }
                                                   if (_updateCollectionState) {
                                                       //获取到收藏状态
                                                       if (_infoModel && [_infoModel.isCollect isEqualToString:@"1"]) {
                                                           _updateCollectionState(YES);
                                                       } else {
                                                           _updateCollectionState(NO);
                                                       }
                                                   }
                                                   //获取到工厂用户的id（环信id）
                                                   if (_didGetFactoryUserId) {
                                                       _didGetFactoryUserId(_infoModel.factoryUserId);
                                                   }
                                                   //获取到库存
                                                   if (_didGetStock) {
                                                       _didGetStock(_infoModel.stock);
                                                   }
                                                   //获取到是否是抢购
                                                   if (_infoModel.isPanicBuy.integerValue == 1) {
                                                       [self createTimer];
                                                       if (_didGetPanicBuyState) {
                                                           _didGetPanicBuyState(YES);
                                                       }
                                                   } else {
                                                       if (_didGetPanicBuyState) {
                                                           _didGetPanicBuyState (NO);
                                                       }
                                                   }
                                                   //获取到是否是尾货
                                                   BOOL isLeftProduct = NO;
                                                   if (_infoModel.isLeftProduct.integerValue == 0) {
                                                       isLeftProduct = YES;
                                                   } else {
                                                       isLeftProduct = NO;
                                                   }
                                                   if (_didGetLeftProductState) {
                                                       _didGetLeftProductState(isLeftProduct);
                                                   }
                                                   //获取到立即购买需要的数据模型
                                                   ECCartProductModel *cartProductModel = [ECCartProductModel yy_modelWithDictionary:result[@"info"][@"product"]];
                                                   cartProductModel.count = @"1";
                                                   cartProductModel.cartId = @"立即购买订单";
                                                   ECCartFactoryModel *cartFactoryModel = [ECCartFactoryModel yy_modelWithDictionary:result[@"info"][@"product"]];
                                                   cartFactoryModel.productCount = @"1";
                                                   cartFactoryModel.productList = [NSMutableArray arrayWithObject:cartProductModel];
                                                   if (_didGetCartModel) {
                                                       _didGetCartModel(cartFactoryModel);
                                                   }
                                                   
                                                   //解析商品承诺数据
                                                   _guaranteeHeight = 1000.f;
                                                   [_guaranteeDataSource removeAllObjects];
                                                   [result[@"service"] enumerateObjectsUsingBlock:^(NSString * _Nonnull guarantee, NSUInteger idx, BOOL * _Nonnull stop) {
                                                       [_guaranteeDataSource addObject:guarantee];
                                                   }];
                                                   if (_guaranteeDataSource.count == 0) {
                                                       _guaranteeHeight = 0.f;
                                                   }
                                                   //评论数据解析
                                                   [_appraiseDataSource removeAllObjects];
                                                   [result[@"info"][@"commentList"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                       ECProductAppraiseModel *model = [ECProductAppraiseModel yy_modelWithDictionary:dic];
                                                       [_appraiseDataSource addObject:model];
                                                   }];
                                                   //规格参数解析
                                                   [_attrDataSource removeAllObjects];
                                                   [result[@"info"][@"attrs"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                       ECProductAttrModel *model = [ECProductAttrModel yy_modelWithDictionary:dic];
                                                       [_attrDataSource addObject:model];
                                                   }];
                                                   [_collectionView reloadData];
                                               } else {
                                                   EC_SHOW_REQUEST_ERROR_INFO
                                               }
                                           }
                                            failed:^(NSURLSessionDataTask *task, NSError *error) {
                                               RequestFailure
                                            }];
}

- (void)createTimer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(timerEvent)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)timerEvent {
    if (_infoModel) {
        _infoModel.leftSecond --;
    }
    POST_NOTIFICATION(NOTIFICATION_NAME_PURCHASE_COUNTDOWN_IN_DETAIL, nil);
}


#pragma mark - UICollection Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
        case 3:
            return 1;
        case 4:
            return _appraiseDataSource.count;
            
        default:
            return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(SCREENWIDTH, SCREENWIDTH);
        case 1:
        {
            if (_infoModel.isPanicBuy.integerValue == 1) {
                //是抢购
                return CGSizeMake(SCREENWIDTH, 326.f / 2.f);
            }else {
                return CGSizeMake(SCREENWIDTH, 300.f / 2.f);
            }
        }
        case 2:
            return CGSizeMake(SCREENWIDTH, _guaranteeHeight);
        case 3:
            return CGSizeMake(SCREENWIDTH, 44.f);
        case 4:
        {
            ECProductAppraiseModel *model = [_appraiseDataSource objectAtIndexWithCheck:indexPath.row];
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
        default:
            return CGSizeZero;
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return UIEdgeInsetsMake(0, 0, 0, 0);
        case 2:
        case 3:
            return UIEdgeInsetsMake(0, 0, 8.f, 0);
        case 4:
            return UIEdgeInsetsMake(0, 0, 0, 0);
            
        default:
            return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 4:
            return CGSizeMake(SCREENWIDTH, 36.f);
            
        default:
            return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    switch (section) {
        case 4:
        {
            if (_appraiseDataSource.count == 0) {
                return CGSizeZero;
            }
            return CGSizeMake(SCREENWIDTH, 44.f);
        }
            
            
        default:
            return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    switch (indexPath.section) {
        case 4:
        {
            if (kind == UICollectionElementKindSectionHeader) {
                ECProductAppraiseHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                     withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseHeader)
                                                                                            forIndexPath:indexPath];
                header.appraiseCount = _infoModel.appraiseNum;
                return header;
            } else {
                if (_appraiseDataSource.count == 0) {
                    return nil;
                }
                ECProductAppraiseFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                     withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseFooter)
                                                                                            forIndexPath:indexPath];
                [footer setMoreAppraiseAction:^{
                    if (weakSelf.moreAppraiseAction) {
                        weakSelf.moreAppraiseAction();
                    }
                }];
                return footer;
            }
            
        }
            
        default:
            return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    
    switch (indexPath.section) {
        case 0:
        {
           ECProductCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductCycleCell)
                                                                                forIndexPath:indexPath];
            cell.imageUrlArr = _cycleImageList;
            [cell setMoreBtnClick:^{
                if (weakSelf.moreBtnClick) {
                    weakSelf.moreBtnClick();
                }
            }];
            return cell;
        }
        case 1:
        {
            if (_infoModel.isPanicBuy.integerValue == 1) {
                //是抢购
                ECProductPanicBuyInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductPanicBuyInfoCell)
                                                                                            forIndexPath:indexPath];
                cell.model = _infoModel;
                return cell;
            } else {
                ECProductInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductInfoCell)
                                                                                    forIndexPath:indexPath];
                cell.model = _infoModel;
                return cell;
            }
            
        }
        case 2:
        {
            ECProductGuaranteeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductGuaranteeCell)
                                                                                     forIndexPath:indexPath];
            cell.titles = _guaranteeDataSource;
            [cell setDidGetCellHeight:^(CGFloat height) {
                weakSelf.guaranteeHeight = height;
                if (weakSelf.needReloadGuarantee) {
                    weakSelf.needReloadGuarantee = NO;
                    [weakSelf.collectionView reloadData];
                }
            }];
            return cell;
        }
        case 3:
        {
            ECProductSelectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductSelectionCell)
                                                                                     forIndexPath:indexPath];
            cell.title = @"产品参数";
            return cell;
        }
        case 4:
        {
            ECProductAppraiseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseCell)
                                                                                    forIndexPath:indexPath];
            ECProductAppraiseModel *model = [_appraiseDataSource objectAtIndexWithCheck:indexPath.row];
            cell.model = model;
            return cell;
        }
            
        default:
            return nil;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 3:
        {
            BKTBlurParameters *blurParameters = [[BKTBlurParameters alloc] init];
            blurParameters.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
            blurParameters.radius = 0.3;
            
            ECProductAttrViewController *vc = [[ECProductAttrViewController alloc] init];
            [vc setBlurParameters:blurParameters];
            [vc setPopinTransitionDirection:BKTPopinTransitionDirectionBottom];
            vc.dataSource = _attrDataSource;
            
            [self.viewController.navigationController presentPopinController:vc
                                                                    fromRect:CGRectMake(0, SCREENHEIGHT - (SCREENHEIGHT * 400.f / 667.f), SCREENWIDTH, (SCREENHEIGHT * 400.f / 667.f) )
                                                            needComputeFrame:NO
                                                                    animated:YES
                                                                  completion:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
