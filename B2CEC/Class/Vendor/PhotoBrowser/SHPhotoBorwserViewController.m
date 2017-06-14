//
//  SHPhotoBorwserViewController.m
//  ZhongShanEC
//
//  Created by 曙华国际 on 16/6/6.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import "SHPhotoBorwserViewController.h"
#import "ZLDefine.h"
#import "ZLBigImageCell.h"

@interface SHPhotoBorwserViewController()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>{
    UIButton *_navRightBtn;
    //底部view
    UIView   *_bottomView;
    UIButton *_btnDone;
    //双击的scrollView
    UICollectionView *_collectionView;
    UIScrollView *_selectScrollView;
    NSInteger _currentPage;
}
@property (strong,nonatomic) NSMutableArray *removeArray;
@end

@implementation SHPhotoBorwserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.removeArray = [NSMutableArray new];
    [self initNavBtns];
    [self initCollectionView];
    [self initBottomView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (SYS_VERSION < 7.f) {
        self.navigationController.navigationBar.tintColor = kRGB(80, 180, 234);
    }else{
        self.navigationController.navigationBar.barTintColor = kRGB(80, 180, 234);
    }
    [_collectionView setContentOffset:CGPointMake(self.currentIndex*(kViewWidth+kItemMargin), 0)];
    [self changeNavRightBtnStatus];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (SYS_VERSION < 7.f) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }else{
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark  init
- (void)initNavBtns
{
    //left nav btn
    UIImage *navBackImg = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"navBackBtn.png")]?:[UIImage imageNamed:kZLPhotoBrowserFrameworkSrcName(@"navBackBtn.png")];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[navBackImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(btnBack_Click)];
    //right nav btn
    if (self.isEdit) {
        _navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _navRightBtn.frame = CGRectMake(0, 0, 25, 25);
        UIImage *normalImg = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"btn_circle.png")]?:[UIImage imageNamed:kZLPhotoBrowserFrameworkSrcName(@"btn_circle.png")];
        UIImage *selImg = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"btn_selected.png")]?:[UIImage imageNamed:kZLPhotoBrowserFrameworkSrcName(@"btn_selected.png")];
        [_navRightBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
        [_navRightBtn setBackgroundImage:selImg forState:UIControlStateSelected];
        [_navRightBtn addTarget:self action:@selector(navRightBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navRightBtn];
    }
    //title
    _currentPage = self.currentIndex + 1;
    self.title = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.imageArray.count];
}
- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = kItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin/2, 0, kItemMargin/2);
    layout.itemSize = self.view.bounds.size;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kItemMargin/2, 0, kViewWidth+kItemMargin, kViewHeight) collectionViewLayout:layout];
    [_collectionView registerNib:[UINib nibWithNibName:@"ZLBigImageCell" bundle:kZLPhotoBrowserBundle] forCellWithReuseIdentifier:@"ZLBigImageCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
}
- (void)initBottomView
{
    if (self.isEdit) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - 64, kViewWidth, 44)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDone.frame = CGRectMake(kViewWidth - 82, 7, 70, 30);
        [_btnDone setTitle:@"删除" forState:UIControlStateNormal];
        _btnDone.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnDone.layer.masksToBounds = YES;
        _btnDone.layer.cornerRadius = 3.0f;
        [_btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDone setBackgroundImage:[UIImage yy_imageWithColor:MainColor] forState:UIControlStateNormal];
        [_btnDone setBackgroundImage:[UIImage yy_imageWithColor:MainShallowColor] forState:UIControlStateSelected];
        [_btnDone setBackgroundColor:kRGB(80, 180, 234)];
        [_btnDone addTarget:self action:@selector(btnDone_Click:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_btnDone];
        
        [self.view addSubview:_bottomView];
    }
}

- (void)updateBorwser{
    if (self.imageArray.count == 0 || self.imageArray == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.removeArray removeAllObjects];
    self.title = [NSString stringWithFormat:@"%ld/%ld", _currentIndex, self.imageArray.count];
    [_collectionView reloadData];
}
#pragma mark  action
- (void)btnBack_Click
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)navRightBtn_Click:(UIButton *)btn
{
    //在这里编辑removearray数组元素
    btn.selected = !btn.selected;
    [self changeBtnDoneTitle];
}
- (void)btnDone_Click:(UIButton *)btn
{
    if (self.removeArray.count == 0) {
        [self.removeArray addObject:@(_currentPage)];
    }
    NSInteger index = _currentPage;
    for (NSNumber *remove in self.removeArray) {
        if ([remove integerValue] < index) {
            index --;
        }
    }
    if (self.btnDoneBlock) {
        self.btnDoneBlock(self.removeArray,index);
    }
}
#pragma mark 逻辑
- (void)changeBtnDoneTitle
{
    if ([self.removeArray containsObject:@(_currentPage)]) {
        [self.removeArray removeObject:@(_currentPage)];
    }else{
        [self.removeArray addObject:@(_currentPage)];
    }
    if (self.removeArray.count == 0) {//如果全部被选中需要删除
        [_btnDone setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        [_btnDone setTitle:[NSString stringWithFormat:@"删除(%ld)", self.removeArray.count] forState:UIControlStateNormal];
    }
}
- (void)changeNavRightBtnStatus
{
    _navRightBtn.selected = [self.removeArray containsObject:@(_currentPage)];
}
- (void)showNavBarAndBottomView
{
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    _bottomView.hidden = NO;
    _collectionView.frame = CGRectMake(-kItemMargin/2, 0, kViewWidth+kItemMargin, kViewHeight);
}

- (void)hideNavBarAndBottomView
{
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    _bottomView.hidden = YES;
    _collectionView.frame = CGRectMake(-kItemMargin/2, 0, kViewWidth+kItemMargin, kViewHeight + 64);
}
#pragma mark  collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLBigImageCell" forIndexPath:indexPath];
    cell.imageView.image = nil;
    [cell showIndicator];
    
    if ([self.imageArray[indexPath.row] isKindOfClass:[UIImage class]]) {//如果是图片
        cell.imageView.image = self.imageArray[indexPath.row];
    }else if ([self.imageArray[indexPath.row] isKindOfClass:[NSString class]]){//如果是URL类型
        [cell.imageView yy_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholder:DEFAULTIMAGE];
    }else if ([self.imageArray[indexPath.row] isKindOfClass:[NSDictionary class]]){//如果是路径字典
        NSDictionary *dict = self.imageArray[indexPath.row];
        for (NSInteger i = 0; i < self.urlKeyArray.count - 1; i ++) {
            dict = dict[self.urlKeyArray[i]];
        }
        [cell.imageView yy_setImageWithURL:[NSURL URLWithString:dict[self.urlKeyArray[self.urlKeyArray.count - 1]]] placeholder:DEFAULTIMAGE];
    }
    
    [cell hideIndicator];
    cell.scrollView.delegate = self;
    
    [self addDoubleTapOnScrollView:cell.scrollView];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLBigImageCell *cell1 = (ZLBigImageCell *)cell;
    cell1.scrollView.zoomScale = 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - 图片缩放相关方法
- (void)addDoubleTapOnScrollView:(UIScrollView *)scrollView
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}
- (void)singleTapAction:(UITapGestureRecognizer *)tap
{
    if (self.navigationController.navigationBar.isHidden) {
        [self showNavBarAndBottomView];
    } else {
        [self hideNavBarAndBottomView];
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap
{
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    _selectScrollView = scrollView;
    CGFloat scale = 1;
    if (scrollView.zoomScale != 3.0) {
        scale = 3;
    } else {
        scale = 1;
    }
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[tap locationInView:tap.view]];
    [scrollView zoomToRect:zoomRect animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == (UIScrollView *)_collectionView) {
        //改变导航标题
        CGFloat page = scrollView.contentOffset.x/(kViewWidth+kItemMargin);
        NSString *str = [NSString stringWithFormat:@"%.0f", page];
        _currentPage = str.integerValue + 1;
        self.title = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.imageArray.count];
        [self changeNavRightBtnStatus];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = _selectScrollView.frame.size.height / scale;
    zoomRect.size.width  = _selectScrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}
@end
