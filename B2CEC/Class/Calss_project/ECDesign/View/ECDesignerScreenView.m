 //
//  ECDesignerScreenView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerScreenView.h"
#import "ECDesignerScreenTitleCollectionViewCell.h"
#import "ECDesignerScreenTableViewCell.h"

@interface ECDesignerScreenView()<
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIView *bgView;

@property (assign,nonatomic) BOOL isShow;

@end

@implementation ECDesignerScreenView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.type = -1;
        _isShow = NO;
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _collectionView.backgroundColor = self.backgroundColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    
    [_collectionView registerClass:[ECDesignerScreenTitleCollectionViewCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerScreenTitleCollectionViewCell)];
    
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    if (!_bgView) {
        _bgView = [UIView new];
    }
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    [_bgView addGestureRecognizer:tapGesture];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)hidden{
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.f);
    }];
    
    [self.superview setNeedsUpdateConstraints];
    [self.superview updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.tableView removeFromSuperview];
    }];
    _isShow = NO;
}

- (void)setTitleArray:(NSMutableArray *)titleArray{
    _titleArray = titleArray;
    [self.collectionView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECDesignerScreenTitleCollectionViewCell *cell = [ECDesignerScreenTitleCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.dataStr = _titleArray[indexPath.row][0];
    cell.isHiddenLine = indexPath.row == (_titleArray.count - 1);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREENWIDTH / (_titleArray.count * 1.f), 40.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isShow) {
        [self hidden];
    }else{
        if (self.clickTitleBlock) {
            self.clickTitleBlock(indexPath.row);
        }
        self.type = indexPath.row;
        if (((NSArray *)[self.dataArray objectAtIndexWithCheck:self.type]).count != 0) {
            WEAK_SELF
            [self.superview addSubview:_bgView];
            [self.superview addSubview:_tableView];
            
            [_tableView reloadData];
            
            [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_equalTo(0.f);
            }];
            
            [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(SCREENWIDTH / (weakSelf.titleArray.count * 1.f) * indexPath.row);
                make.top.mas_equalTo(weakSelf.mas_bottom);
                make.width.mas_equalTo(SCREENWIDTH / (weakSelf.titleArray.count * 1.f));
                make.height.mas_equalTo(0.f);
            }];
            
            [self.superview layoutIfNeeded];
            
            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(32.f * ((NSArray *)[self.dataArray objectAtIndexWithCheck:self.type]).count);
            }];
            
            [self.superview setNeedsUpdateConstraints];
            [self.superview updateConstraintsIfNeeded];
    
            [UIView animateWithDuration:0.25f animations:^{
                [self.superview layoutIfNeeded];
            }];
            _isShow = YES;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == -1) {
        return 0;
    }
    return ((NSArray *)[self.dataArray objectAtIndexWithCheck:self.type]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECDesignerScreenTableViewCell *cell = [ECDesignerScreenTableViewCell cellWithTableView:tableView];
    cell.title = [[[self.dataArray objectAtIndexWithCheck:self.type] objectAtIndexWithCheck:indexPath.row] objectAtIndexWithCheck:0];
    cell.isSelect = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hidden];
    [self.titleArray replaceObjectAtIndex:self.type withObject:[[self.dataArray objectAtIndexWithCheck:self.type] objectAtIndexWithCheck:indexPath.row]];
    [self.collectionView reloadData];
    if (self.selectTypeBlock) {
        self.selectTypeBlock();
    }
}

@end
