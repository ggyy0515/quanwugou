//
//  SHImageListView.m
//  ZhongShanEC
//
//  Created by 曙华国际 on 16/6/2.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import "SHImageListView.h"
#import "SHImageListViewCollectionViewCell.h"
#import "SHPhotoBorwserViewController.h"


@interface SHImageListView()<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>
@property (strong,nonatomic) UICollectionViewFlowLayout *flowlayout;
@property (strong,nonatomic) UICollectionView *contentCollectionView;

@property (strong,nonatomic) NSMutableArray *dataArray;
@end

@implementation SHImageListView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.addImage = @"addimg";
        self.maxCount = 0;
        self.dataArray = [NSMutableArray new];
        [self CreateUI];
    }
    return self;
}

- (void)CreateUI{
    self.isAdd = NO;
    [self addSubview:self.contentCollectionView];
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}
#pragma mark  setter  getter
- (UICollectionViewFlowLayout *)flowlayout{
    if (_flowlayout == nil) {
        _flowlayout = [[UICollectionViewFlowLayout alloc] init];
        _flowlayout.itemSize = CGSizeMake(48.f, 48.f);
        _flowlayout.minimumLineSpacing = 10.f;
        _flowlayout.minimumInteritemSpacing = 5.f;
        _flowlayout.sectionInset = UIEdgeInsetsZero;
        _flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowlayout;
}

- (UICollectionView *)contentCollectionView{
    if (_contentCollectionView == nil) {
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowlayout];
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        [_contentCollectionView registerClass:[SHImageListViewCollectionViewCell class]
                   forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(SHImageListViewCollectionViewCell)];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.scrollEnabled = NO;
    }
    return _contentCollectionView;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:imageArray];
    [self.contentCollectionView reloadData];
}

- (void)setAddImageArray:(NSArray *)addImageArray{
    _addImageArray = addImageArray;
    [self.dataArray addObjectsFromArray:addImageArray];
    [self.contentCollectionView reloadData];
}

- (void)setIsAdd:(BOOL)isAdd{
    _isAdd = isAdd;
    [self.contentCollectionView reloadData];
}

- (void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    self.flowlayout.itemSize = itemSize;
    [self.contentCollectionView reloadData];
}
- (void)setUrlKeyArray:(NSArray *)urlKeyArray{
    _urlKeyArray = urlKeyArray;
}
- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
}
- (void)setAddImage:(NSString *)addImage{
    _addImage = addImage;
}
#pragma mark - action
+ (CGFloat)imageListWithMaxWidth:(CGFloat)width
                       WithCount:(NSInteger)count
                    WithMaxCount:(NSInteger)max
                    WithItemSize:(CGSize)itemSize
                         WithAdd:(BOOL)isAdd{
    if (!isAdd && count == 0) {
        return 0.f;
    }
    NSInteger allCount = 0;
    if (isAdd) {
        if (max == 0) {
            allCount = count + 1;
        }else{
            allCount = count == max ? count : (count + 1);
        }
    }else{
        allCount = count;
    }
    CGFloat allWidth = (itemSize.width + 5.f) * allCount;
    NSInteger allLineCount = allWidth / width + 1;
    NSInteger allHeight = allLineCount * (itemSize.height + 10.f);
    return allHeight;
}

#pragma mark -- collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isAdd) {
        if (self.maxCount == 0) {
            return self.dataArray.count + 1;
        }else{
            return self.maxCount == self.dataArray.count ? self.dataArray.count : (self.dataArray.count + 1);
        }
    }else{
        return self.dataArray.count;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SHImageListViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(SHImageListViewCollectionViewCell)
                                                                           forIndexPath:indexPath];
    if (indexPath.row == _dataArray.count) { //如果能添加照片,并且是最后一个
        cell.imageView.image = [[UIImage imageNamed:self.addImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        if ([self.dataArray[indexPath.row] isKindOfClass:[UIImage class]]) {//如果是图片
            cell.imageView.image = self.dataArray[indexPath.row];
        }else if ([self.dataArray[indexPath.row] isKindOfClass:[NSString class]]){//URL
            [cell.imageView yy_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholder:DEFAULTIMAGE];
        }else if ([self.dataArray[indexPath.row] isKindOfClass:[NSDictionary class]]){//如果是路径字典
            NSDictionary *dict = self.dataArray[indexPath.row];
            for (NSInteger i = 0; i < self.urlKeyArray.count - 1; i ++) {
                dict = dict[self.urlKeyArray[i]];
            }
            [cell.imageView yy_setImageWithURL:[NSURL URLWithString:dict[self.urlKeyArray[self.urlKeyArray.count - 1]]] placeholder:DEFAULTIMAGE];
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isAdd) {
        if (indexPath.row == self.dataArray.count) {
            if (self.addImageClickBlock) {
                self.addImageClickBlock();
            }
        }else{
            if (self.imageClickBlock) {
                self.imageClickBlock(indexPath.row);
            }
        }
    } else {
        SHPhotoBorwserViewController *borwserVC = [[SHPhotoBorwserViewController alloc] init];
        borwserVC.imageArray = self.dataArray;
        borwserVC.currentIndex = indexPath.row;
        borwserVC.isEdit = NO;
        borwserVC.urlKeyArray = self.urlKeyArray;
        CMBaseNavigationController *browserNai = [[CMBaseNavigationController alloc] initWithRootViewController:borwserVC];
        [APP_DELEGATE.window.rootViewController presentViewController:browserNai animated:YES completion:^{}];
    }
}
@end
