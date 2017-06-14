//
//  ECProductAttrViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAttrViewController.h"
#import "ECProductAttrModel.h"
#import "ECProductAttrCell.h"
#import "ECProductAttrHeadrView.h"

@interface ECProductAttrViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ECProductAttrViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
    }
    [self.view addSubview:_closeBtn];
    [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _closeBtn.titleLabel.font = FONT_32;
    [_closeBtn setBackgroundColor:MainColor];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(49.f);
    }];
    [_closeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.navigationController dismissCurrentPopinControllerAnimated:YES];
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.closeBtn.mas_top);
    }];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECProductAttrHeadrView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAttrHeadrView)];
    [_collectionView registerClass:[ECProductAttrCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAttrCell)];
}


#pragma mark - Setter

- (void)setDataSource:(NSMutableArray<ECProductAttrModel *> *)dataSource {
    _dataSource = dataSource;
    [_collectionView reloadData];
}


#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENWIDTH, 44.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECProductAttrModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    CGFloat height = ceil([model.attrValue boundingRectWithSize:CGSizeMake(SCREENWIDTH - 24.f - 80.f - 10.f, 10000)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:FONT_28}
                                                        context:nil].size.height + 20.f);
    if (height < 55.f) height = 55.f;
    return CGSizeMake(SCREENWIDTH, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ECProductAttrHeadrView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAttrHeadrView)
                                                                               forIndexPath:indexPath];
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECProductAttrCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAttrCell)
                                                                        forIndexPath:indexPath];
    ECProductAttrModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
