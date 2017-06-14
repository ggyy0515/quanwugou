//
//  ECHomeOptionsView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeOptionsView.h"
#import "ECHomeOptionsCollectionViewCell.h"
#import "ECNewsTypeModel.h"
#import "DragCellCollectionView.h"
#import "ECHomeAllOptionCollectionViewCell.h"
#import "ECHomeAllOptionHeaderCollectionReusableView.h"
#import "ECHomeAllOptionFooterCollectionReusableView.h"

@interface ECHomeOptionsView()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
DragCellCollectionViewDataSource,
DragCellCollectionViewDelegate
>
/**
 滑动tabbar
 */
@property (strong,nonatomic) UICollectionView *contentCollectionView;
/**
 更多视图
 */
@property (strong,nonatomic) UIView *moreView;
/**
 更多视图背景图片
 */
@property (strong,nonatomic) UIImageView *moreBgImageView;
/**
 更多视图图片
 */
@property (strong,nonatomic) UIImageView *moreImageView;
/**
 更多视图按钮
 */
@property (strong,nonatomic) UIButton *moreBtn;
//弹出全部选择视图
@property (assign,nonatomic) BOOL isShowAllOptionView;

@property (assign,nonatomic) CGFloat allViewHeight;

@property (strong,nonatomic) UIView *tipsView;

@property (strong,nonatomic) UILabel *tipsLab;

@property (strong,nonatomic) UIView *tipsRightLineView;

@property (strong,nonatomic) UIView *tipsBottomLineView;

@property (strong,nonatomic) UIView *allContentView;

@property (strong,nonatomic) UIView *dragView;

@property (strong,nonatomic) DragCellCollectionView *dragCollectionView;

@property (strong,nonatomic) UIButton *shadowBtn;

@property (strong,nonatomic) NSMutableArray *changeArray;

@end

@implementation ECHomeOptionsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.allViewHeight = 0.f;
        self.isShowAllOptionView = NO;
        self.changeArray = [NSMutableArray new];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0.f, 10.f, 0.f, 40.f);
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = ClearColor;
    
    if (!_moreView) {
        _moreView = [UIView new];
    }
    _moreView.backgroundColor = ClearColor;
    
    if (!_moreBgImageView) {
        _moreBgImageView = [UIImageView new];
    }
    _moreBgImageView.image = [UIImage imageNamed:@"navdown_icon_bg"];
    
    if (!_moreImageView) {
        _moreImageView = [UIImageView new];
    }
    _moreImageView.image = [UIImage imageNamed:@"navdown_more"];
    
    if (!_moreBtn) {
        _moreBtn = [UIButton new];
    }
    [_moreBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.newsTypeArray.count == 0) {
            return ;
        }
        weakSelf.isShowAllOptionView = !weakSelf.isShowAllOptionView;
        [weakSelf updateRotationAnimation];
        [weakSelf updateAllOptionView];
        if (!weakSelf.isShowAllOptionView) {
            [weakSelf saveNewsType];
        }
    }];
    
    [self addSubview:_contentCollectionView];
    [self addSubview:_moreView];
    [_moreView addSubview:_moreBgImageView];
    [_moreView addSubview:_moreImageView];
    [_moreView addSubview:_moreBtn];
    
    [_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0.f);
    }];
    
    [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0.f);
        make.width.mas_equalTo(57.f);
    }];
    
    [_moreBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21.5f);
        make.top.mas_equalTo(9.f);
        make.bottom.mas_equalTo(-9.f);
        make.right.mas_equalTo(-13.5f);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_contentCollectionView registerClass:[ECHomeOptionsCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeOptionsCollectionViewCell)];
    [_contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(UICollectionReusableView)];
    [_contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(UICollectionReusableView)];
}

- (void)createAllOptionViewUI{
    WEAK_SELF
    
    _tipsView = [UIView new];
    _tipsView.backgroundColor = [UIColor whiteColor];
    
    _tipsLab = [UILabel new];
    _tipsLab.text = @"长按拖动可调整顺序";
    _tipsLab.font = FONT_28;
    _tipsLab.textColor = LightColor;
    
    _tipsRightLineView = [UIView new];
    _tipsRightLineView.backgroundColor = LineDefaultsColor;
    
    _tipsBottomLineView = [UIView new];
    _tipsBottomLineView.backgroundColor = LineDefaultsColor;
    
    _allContentView = [UIView new];
    _allContentView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3f];
    
    _dragView = [UIView new];
    _dragView.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = (SCREENWIDTH - 40.f - 72.f * 4) / 3.f;
    layout.minimumLineSpacing = 20.f;
    _dragCollectionView = [[DragCellCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _dragCollectionView.delegate = self;
    _dragCollectionView.dataSource = self;
    _dragCollectionView.showsVerticalScrollIndicator = NO;
    _dragCollectionView.backgroundColor = [UIColor whiteColor];
    [_dragCollectionView setAddCellBlock:^(NSIndexPath *indexPath) {
        [weakSelf addCellUpdateArray:indexPath];
    }];
    [_dragCollectionView setRemoveCellBlock:^(NSIndexPath *indexPath) {
        [weakSelf removeCellUpdateArray:indexPath];
    }];
    
    [_dragCollectionView registerClass:[ECHomeAllOptionCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeAllOptionCollectionViewCell)];
    [_dragCollectionView registerClass:[ECHomeAllOptionHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeAllOptionHeaderCollectionReusableView)];
    [_dragCollectionView registerClass:[ECHomeAllOptionFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeAllOptionFooterCollectionReusableView)];
    
    _shadowBtn = [UIButton new];
    [_shadowBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.isShowAllOptionView = NO;
        [weakSelf updateRotationAnimation];
        [weakSelf updateAllOptionView];
    }];
}

- (void)saveNewsType{
    [ECNewsTypeModel saveNewsType:self.changeArray];
    if (EC_USER_WHETHERLOGIN) {
        NSMutableArray *typeArray = [NSMutableArray new];
        for (ECNewsTypeModel *model in self.changeArray[0]) {
            [typeArray addObject:model.BIANMA];
        }
        //发起请求向服务器保存用户操作结果,保存成功之后调用回调
        [ECHTTPServer requestSaveUserNewsType:typeArray.count == 0 ? @"" : [typeArray componentsJoinedByString:@","] Succeed:^(NSURLSessionDataTask *task, id result) {
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    if (self.closeClick) {
        self.closeClick([ECNewsTypeModel loadNewsType]);
    }
}

- (void)addCellUpdateArray:(NSIndexPath *)indexPath{
    [self.changeArray[0] addObject:self.changeArray[1][indexPath.row]];
    [self.changeArray[1] removeObjectAtIndex:indexPath.row];
    [_dragCollectionView reloadData];
}

- (void)removeCellUpdateArray:(NSIndexPath *)indexPath{
    [self.changeArray[1] addObject:self.changeArray[0][indexPath.row]];
    [self.changeArray[0] removeObjectAtIndex:indexPath.row];
    [_dragCollectionView reloadData];
}

- (void)updateRotationAnimation{
    CGFloat count = self.isShowAllOptionView ? 5.f : 0.f;
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_4 * count ];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    [_moreImageView.layer addAnimation:rotationAnimation forKey:self.isShowAllOptionView ? @"rotationAnimation1" : @"rotationAnimation2"];
}

- (void)updateAllOptionView{
    WEAK_SELF
    
    if (self.isShowAllOptionView) {
        [self createAllOptionViewUI];
        
        [self addSubview:_tipsView];
        [_tipsView addSubview:_tipsLab];
        [_tipsView addSubview:_tipsRightLineView];
        [self addSubview:_tipsBottomLineView];
        [self.superview addSubview:_allContentView];
        [_allContentView addSubview:_dragView];
        [_allContentView addSubview:_dragCollectionView];
        [_allContentView addSubview:_shadowBtn];
        
        [_tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.f);
            make.right.mas_equalTo(-43.5f);
        }];
        
        [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0.f);
            make.left.mas_equalTo(20.f);
        }];
        
        [_tipsRightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0.f);
            make.width.mas_equalTo(0.5f);
        }];
        
        [_tipsBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0.f);
            make.height.mas_equalTo(0.5f);
        }];
        
        [_allContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0.f);
            make.top.mas_equalTo(weakSelf.mas_bottom);
        }];
        
        [_dragView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.f);
            make.height.mas_equalTo(0.f);
        }];
        
        [_dragCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.f);
            make.right.mas_equalTo(-20.f);
            make.top.height.equalTo(weakSelf.dragView);
        }];
        
        [_allContentView layoutIfNeeded];
        
        [_dragView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(weakSelf.allViewHeight);
        }];
        
        [_dragCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(weakSelf.dragView.mas_height);
        }];
        
        [_allContentView setNeedsUpdateConstraints];
        [_allContentView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.5f animations:^{
            [_allContentView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_shadowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0.f);
                make.top.mas_equalTo(weakSelf.dragView.mas_bottom);
            }];
        }];
    }else{
        [_dragView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
        [_dragCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(weakSelf.dragView.mas_height);
        }];
        [_allContentView setNeedsUpdateConstraints];
        [_allContentView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.5f animations:^{
            [_allContentView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_tipsView removeFromSuperview];
            [_tipsBottomLineView removeFromSuperview];
            [_allContentView removeFromSuperview];
        }];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([collectionView isKindOfClass:[DragCellCollectionView class]]) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.newsTypeArray.count == 0) {
        return 0;
    }else{
        if ([collectionView isKindOfClass:[DragCellCollectionView class]]) {
            return ((NSArray *)self.changeArray[section]).count;
        }else{
            return ((NSArray *)self.newsTypeArray[0]).count;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[DragCellCollectionView class]]) {
        ECHomeAllOptionCollectionViewCell *cell = [ECHomeAllOptionCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
        cell.model = self.changeArray[indexPath.section][indexPath.row];
        cell.isDelete = (indexPath.section == 0 && indexPath.row != 0);
        cell.isFixed = (indexPath.section == 0 && indexPath.row == 0);
        return cell;
    }else{
        ECNewsTypeModel *model = [((NSArray *)self.newsTypeArray[0]) objectAtIndexWithCheck:indexPath.row];
        ECHomeOptionsCollectionViewCell *cell = [ECHomeOptionsCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
        cell.title = model.NAME;
        cell.isCurrent = _currentIndex == indexPath.row;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([collectionView isKindOfClass:[DragCellCollectionView class]]) {
        return CGSizeMake(SCREENWIDTH - 40.f, 60.f);
    }else{
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if ([collectionView isKindOfClass:[DragCellCollectionView class]]) {
        if (((NSArray *)self.changeArray[section]).count == 0) {
            return CGSizeMake(SCREENWIDTH - 40.f, 60.f);
        }else{
            return CGSizeMake(SCREENWIDTH - 40.f, 23.f);
        }
    }else{
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([collectionView isKindOfClass:[DragCellCollectionView class]]) {
        if (kind == UICollectionElementKindSectionHeader){
            ECHomeAllOptionHeaderCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeAllOptionHeaderCollectionReusableView) forIndexPath:indexPath];
            headView.title = indexPath.section == 0 ? @"我的分类" : @"其他分类";
            reusableView = headView;
        }else if (kind == UICollectionElementKindSectionFooter){
            ECHomeAllOptionFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeAllOptionFooterCollectionReusableView) forIndexPath:indexPath];
            footerView.isShowLine = indexPath.section == 0;
            footerView.isHaveData = ((NSArray *)self.changeArray[indexPath.section]).count != 0;
            reusableView = footerView;
        }
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[DragCellCollectionView class]]) {
        return CGSizeMake(72.f, 32.f);
    }else{
        ECNewsTypeModel *model = [((NSArray *)self.newsTypeArray[0]) objectAtIndexWithCheck:indexPath.row];
        CGFloat fontSize = _currentIndex == indexPath.row ? 19.f : 18.f;
        CGFloat width = ceilf([model.NAME boundingRectWithSize:CGSizeMake(10000, fontSize)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                                       context:nil].size.width) + 20.f;
        return CGSizeMake(width, 40.f);
    }
}

- (NSArray *)dataSourceArrayOfCollectionView:(DragCellCollectionView *)collectionView{
    return self.changeArray;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[DragCellCollectionView class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNewsChangeState object:[collectionView cellForItemAtIndexPath:indexPath]];
    }else{
        self.currentIndex = indexPath.row;
        if (self.didSelectIndex) {
            self.didSelectIndex(_currentIndex);
        }
    }
}

- (void)dragCellCollectionView:(DragCellCollectionView *)collectionView moveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    ECNewsTypeModel *model = self.changeArray[0][fromIndexPath.row];
    [(NSMutableArray *)self.changeArray[0] removeObjectAtIndex:fromIndexPath.row];
    [(NSMutableArray *)self.changeArray[0] insertObject:model atIndex:toIndexPath.row];
    [self.dragCollectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [self.contentCollectionView reloadData];
    [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)setNewsTypeArray:(NSMutableArray *)newsTypeArray{
    _newsTypeArray = newsTypeArray;
    self.changeArray = newsTypeArray;
    
    [self getNewsTypeArrayHeight];
    [self.contentCollectionView reloadData];
}

- (void)getNewsTypeArrayHeight{
    if (self.changeArray.count == 0) {
        self.allViewHeight = 0.f;
    }else{
        NSArray *array1 = self.changeArray[0];
        NSArray *array2 = self.changeArray[1];
        CGFloat height = 120.f;
        if (array1.count == 0) {
            height += 60.f;
        }else{
            height += ceilf(array1.count / 4.f) * 52.f + 23.f;
        }
        if (array2.count == 0) {
            height += 60.f;
        }else{
            height += ceilf(array2.count / 4.f) * 52.f + 23.f;
        }
        if (height >= (SCREENHEIGHT - (64.f + 48.f))) {
            height = (SCREENHEIGHT - (64.f + 48.f));
        }
        self.allViewHeight = height;
    }
}
@end
