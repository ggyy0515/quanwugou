//
//  ECCommentOrderViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCommentOrderViewController.h"
#import "ECOrderListModel.h"
#import "ECCommentOrderCell.h"
#import "ECOrderProductModel.h"

@interface ECCommentOrderViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ECOrderListModel *model;
/**
 评分数据
 */
@property (nonatomic, strong) NSMutableArray <NSString *> *starLevelArray;
/**
 评论数据
 */
@property (nonatomic, strong) NSMutableArray <NSString *> *commentArray;
/**
 图片数据
 */
@property (nonatomic, strong) NSMutableArray <NSMutableArray *> *imageArray;
//上次选择过的图片数据
@property (nonatomic, strong) NSMutableArray <NSMutableArray *> *lastSelectPhotoArray;

@end

@implementation ECCommentOrderViewController

#pragma mark - Life Cycle

- (instancetype)initWithOrderList:(ECOrderListModel *)model {
    if (self = [super init]) {
        _model = model;
        [self initBaseData];
    }
    return self;
}

- (void)initBaseData {
    _starLevelArray = [NSMutableArray array];
    _commentArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _lastSelectPhotoArray = [NSMutableArray array];
    for (NSInteger index = 0; index < _model.productList.count; index++) {
        [_starLevelArray addObject:@"5"];//初始评分数据
        [_commentArray addObject:@""];//初始评论数据
        [_imageArray addObject:[NSMutableArray array]];//初始图片数据
        [_lastSelectPhotoArray addObject:[NSMutableArray array]];//初始标记上次选择过的  (算法数组)
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitClick:)];
    self.navigationItem.rightBarButtonItem.tintColor = MainColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(8.f, 0, 8.f, 0);
        layout.minimumLineSpacing = 8.f;
        layout.itemSize = CGSizeMake(SCREENWIDTH, 352.f - 60.f + (SCREENWIDTH - 12.f * 6) / 5.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_collectionView registerClass:[ECCommentOrderCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECCommentOrderCell)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)submitClick:(UIBarButtonItem *)sender {
    [self uploadImageData];
}

- (void)uploadImageData {
    SHOWSVP
    NSMutableArray <NSData *> *imageDataArray = [NSMutableArray array];
    [_imageArray enumerateObjectsUsingBlock:^(NSMutableArray <UIImage *> * _Nonnull subArray, NSUInteger idx, BOOL * _Nonnull stop) {
        [subArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            [imageDataArray addObject:data];
        }];
    }];
    NSMutableArray <NSMutableArray *> *commitArray = [NSMutableArray array];
    if (imageDataArray.count != 0) {
        //有添加图片
        [ECHTTPServer requestUploadFileWithFilesData:imageDataArray
                                             succeed:^(NSURLSessionDataTask *task, id result) {
                                                 if (IS_REQUEST_SUCCEED(result)) {
                                                     //初始化返回的路径列表
                                                      NSMutableArray <NSString *> *pathArray = [NSMutableArray array];
                                                     //生成路径列表数据
                                                     [result[@"results"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                         [pathArray addObject:dic[@"path"]];
                                                     }];
                                                     //将列表数据解析到二重数组中
                                                     [_imageArray enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull subImageArray, NSUInteger idx, BOOL * _Nonnull stop) {
                                                         NSMutableArray *cellPathList = [NSMutableArray array];
                                                         for (NSInteger index = 0; index < subImageArray.count; index ++) {
                                                             NSString *path = [pathArray objectAtIndexWithCheck:0];
                                                             if (!path)  path = @"";
                                                             [cellPathList addObject:path];
                                                             [pathArray removeObjectAtIndex:0];
                                                         }
                                                         [commitArray addObject:cellPathList];
                                                     }];
                                                     //提交评论
                                                     [self submitCommentWithCommitArray:commitArray];
                                                 } else {
                                                     EC_SHOW_REQUEST_ERROR_INFO
                                                 }
                                             }
                                              failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                  RequestFailure
                                              }];
    } else {
        //没有添加图片
        for (NSInteger index = 0; index < _imageArray.count; index ++) {
            [commitArray addObject:[NSMutableArray array]];
        }
        [self submitCommentWithCommitArray:commitArray];
    }
    
}

- (void)submitCommentWithCommitArray:(NSMutableArray *)commitArray {
    NSMutableArray *productIdList = [NSMutableArray array];
    [_model.productList enumerateObjectsUsingBlock:^(ECOrderProductModel * _Nonnull productModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [productIdList addObject:productModel.proId];
    }];
    [ECHTTPServer requestCommitCommentWithOrderId:_model.orderId
                                           userId:[Keychain objectForKey:EC_USER_ID]
                                   productIdArray:productIdList
                                     commentArray:_commentArray
                                   starLevelArray:_starLevelArray
                                   imageListAttay:commitArray
                                          succeed:^(NSURLSessionDataTask *task, id result) {
                                              if (IS_REQUEST_SUCCEED(result)) {
                                                  POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA, nil);
                                                  POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_ORDER_DETAIL_DATA, nil);
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  RequestSuccess(result)
                                              } else {
                                                  EC_SHOW_REQUEST_ERROR_INFO
                                              }
                                          } failed:^(NSURLSessionDataTask *task, NSError *error) {
                                              RequestFailure
                                          }];
}

//变更评分后更改评分数据
- (void)changeStarLevel:(NSString *)starLevel atIndex:(NSInteger)index {
    [_starLevelArray replaceObjectAtIndex:index withObject:starLevel];
}

//变更评论后改变数据
- (void)changeComment:(NSString *)comment atIndex:(NSInteger)index {
    [_commentArray replaceObjectAtIndex:index withObject:comment];
}

//添加图片操作
- (void)addImageInCellAtIndex:(NSInteger)index {
    NSMutableArray *cellImageList = [_imageArray objectAtIndexWithCheck:index];
    NSMutableArray *cellLastList = [_lastSelectPhotoArray objectAtIndex:index];
    ZLPhotoActionSheet *sheet = [[ZLPhotoActionSheet alloc] init];
    sheet.maxSelectCount = 5;
    [sheet showWithSender:self
                  animate:YES
    lastSelectPhotoModels:[_lastSelectPhotoArray objectAtIndexWithCheck:index]
               completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                   [cellImageList removeAllObjects];
                   [cellLastList removeAllObjects];
                   [cellImageList addObjectsFromArray:selectPhotos];
                   [cellLastList addObjectsFromArray:selectPhotoModels];
                   [_collectionView reloadData];
               }];
}

#pragma mark - UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.productList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    ECCommentOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECCommentOrderCell)
                                                                         forIndexPath:indexPath];
    ECOrderProductModel *model = [_model.productList objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    [cell setStarLevel:[_starLevelArray objectAtIndexWithCheck:indexPath.row]];
    [cell setComment:[_commentArray objectAtIndexWithCheck:indexPath.row]];
    cell.imageList = [_imageArray objectAtIndexWithCheck:indexPath.row];
    cell.lastSelectArray = [_lastSelectPhotoArray objectAtIndexWithCheck:indexPath.row];
    
    [cell setStarLevelChanged:^(NSString *starLevel, NSIndexPath *cellIndexPath) {
        [weakSelf changeStarLevel:starLevel atIndex:cellIndexPath.row];
    }];
    [cell setCommentChanged:^(NSString *comment, NSIndexPath *cellIndexPath) {
        [weakSelf changeComment:comment atIndex:cellIndexPath.row];
    }];
    [cell setAddImageAction:^(NSIndexPath *cellIndexPath) {
        [weakSelf addImageInCellAtIndex:cellIndexPath.row];
    }];
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
