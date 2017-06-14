//
//  ECCollectViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCollectViewController.h"
//商品
#import "ECMallProductCell.h"
#import "ECMallProductModel.h"
#import "ECMallProductDetailViewController.h"
//作品
#import "ECWorksTableViewCell.h"
#import "ECWorksModel.h"
#import "ECWorksDetailViewController.h"
//资讯
#import "ECHomeSingleImageTableViewCell.h"
#import "ECHomeMoreImageTableViewCell.h"
#import "ECHomeNoneImageTableViewCell.h"
#import "ECHomeBigImageTableViewCell.h"
#import "ECHomeVideoTableViewCell.h"
#import "ECHomeNewsListModel.h"
#import "ECNewsInfoViewController.h"
#import "ECNewsBigImageViewViewController.h"
#import "ECAdvertisingViewController.h"
#import "ECNewsVideoInfoViewController.h"

@interface ECCollectViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UIView *navView;

@property (strong,nonatomic) UIButton *productBtn;

@property (strong,nonatomic) UIButton *worksBtn;

@property (strong,nonatomic) UIButton *newsBtn;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIButton *editBtn;

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) NSMutableArray *dataArray;

@property (assign,nonatomic) NSInteger pageIndex;

@property (assign,nonatomic) NSInteger type;

@property (assign,nonatomic) BOOL isEdit;

//----滑动手势----//
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, assign) CGFloat beganX;

@property (nonatomic, assign) CGFloat beganY;
//----滑动手势----//

@end

@implementation ECCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createNavUI];
    [self createUI];
}

- (void)createData{
    self.isEdit = NO;
    self.type = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray new];
}

- (void)createNavUI{
    WEAK_SELF
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREENWIDTH / 2.f, 44.f)];
    }
    
    if (!_productBtn) {
        _productBtn = [UIButton new];
    }
    [_productBtn setTitle:@"商品" forState:UIControlStateNormal];
    [_productBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _productBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_productBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.type == 1) {
            return ;
        }
        weakSelf.type = 1;
        [weakSelf clickTypeUpdateUI];
    }];
    
    if (!_worksBtn) {
        _worksBtn = [UIButton new];
    }
    [_worksBtn setTitle:@"案例" forState:UIControlStateNormal];
    [_worksBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _worksBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_worksBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.type == 3) {
            return ;
        }
        weakSelf.type = 3;
        [weakSelf clickTypeUpdateUI];
    }];
    
    if (!_newsBtn) {
        _newsBtn = [UIButton new];
    }
    [_newsBtn setTitle:@"资讯" forState:UIControlStateNormal];
    [_newsBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _newsBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_newsBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.type == 2) {
            return ;
        }
        weakSelf.type = 2;
        [weakSelf clickTypeUpdateUI];
    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = MainColor;
    
    [_navView addSubview:_productBtn];
    [_navView addSubview:_worksBtn];
    [_navView addSubview:_newsBtn];
    [_navView addSubview:_lineView];
    
    [_productBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.worksBtn.mas_left).offset(-32.f);
    }];
    
    [_worksBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.navView.mas_centerX);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_newsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.worksBtn.mas_right).offset(32.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.productBtn);
        make.bottom.mas_equalTo(weakSelf.productBtn.mas_bottom);
        make.height.mas_equalTo(2.f);
    }];
    
    self.navigationItem.titleView = _navView;
    
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [_editBtn setTitleColor:LightColor forState:UIControlStateNormal];
    _editBtn.titleLabel.font = FONT_32;
    [_editBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.editBtn.selected = !weakSelf.isEdit;
        weakSelf.isEdit = !weakSelf.isEdit;
        if (weakSelf.type == 1) {
            [weakSelf.collectionView reloadData];
        }else{
            [weakSelf.tableView reloadData];
        }
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
}

- (void)createUI{
    WEAK_SELF
    
    //
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 8.f;
        layout.itemSize = CGSizeMake((SCREENWIDTH - 24.f) / 2.f, (SCREENWIDTH - 24.f) / 2.f + 30.f + 12.f +16.f);
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECMallProductCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallProductCell)];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf requestCollectDataList];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestCollectDataList];
    }];
    
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStyleGrouped;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf requestCollectDataList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestCollectDataList];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:_pan];
    _pan.enabled = NO;
}

- (void)clickTypeUpdateUI{
    //还原编辑按钮
    self.isEdit = NO;
    self.editBtn.selected = NO;
    //控制视图
    self.collectionView.hidden = self.type != 1;
    self.tableView.hidden = self.type == 1;
    //控制底部细线移动
    switch (self.type) {
        case 1:{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.productBtn);
                make.bottom.mas_equalTo(self.productBtn.mas_bottom);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
        case 2:{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.newsBtn);
                make.bottom.mas_equalTo(self.newsBtn.mas_bottom);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
        default:{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.worksBtn);
                make.bottom.mas_equalTo(self.worksBtn.mas_bottom);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
    }
    [self.navView setNeedsUpdateConstraints];
    [self.navView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25f animations:^{
        [self.navView layoutIfNeeded];
    }];
    //控制数据刷新
    switch (self.type) {
        case 1:{
            [self.collectionView.mj_header beginRefreshing];
        }
            break;
        default:{
            [self.tableView.mj_header beginRefreshing];
        }
            break;
    }
}

- (void)panGesture:(id)sender {
    UIPanGestureRecognizer *panGestureRecognizer;
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        panGestureRecognizer = (UIPanGestureRecognizer *)sender;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan){
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        _beganX = translation.x;
        _beganY = translation.y;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        if (fabs(translation.y - _beganY) < fabs(translation.x - _beganX)) {
            if (translation.x > _beganX && (translation.x - _beganX) > OFFSET_TRIGGER_DIRECTION) {
                //goBack
                if (_type > 1) {
                    [self changeNum:-1];
                }
            }else if (translation.x < _beganX && (_beganX - translation.x) > OFFSET_TRIGGER_DIRECTION){
                //goForward
                if (_type != 2) {
                    [self changeNum:1];
                }
            }
        }
        _beganX = 0;
        _beganY = 0;
    }
}

- (void)changeNum:(NSInteger)num {
    switch (_type) {
        case 1:{
            _type = num > 0 ? 3 : 0;
        }
        break;
        case 2:{
            _type = num > 0 ? 2 : 3;
        }
        break;
        default:{
            _type = num > 0 ? 2 : 1;
        }
        break;
    }
    [self clickTypeUpdateUI];
}

- (void)requestCollectDataList{
    WEAK_SELF
    [ECHTTPServer requestMyCollectWithType:self.type WithPageIndex:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            switch (weakSelf.type) {
                case 1:{
                    for (NSDictionary *dict in result[@"productlist"]) {
                        [weakSelf.dataArray addObject:[ECMallProductModel yy_modelWithDictionary:dict]];
                    }
                    [weakSelf.collectionView reloadData];
                }
                    break;
                case 2:{
                    for (NSDictionary *dict in result[@"inforList"]) {
                        [weakSelf.dataArray addObject:[ECHomeNewsListModel yy_modelWithDictionary:dict]];
                    }
                    [weakSelf.tableView reloadData];
                }
                    break;
                case 3:{
                    for (NSDictionary *dict in result[@"shareList"]) {
                        [weakSelf.dataArray addObject:[ECWorksModel yy_modelWithDictionary:dict]];
                    }
                    [weakSelf.tableView reloadData];
                }
                    break;
            }
            weakSelf.pan.enabled = YES;
            if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.pageIndex) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.collectionView.mj_footer endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestChangeCollectState:(NSString *)collectID WithIndex:(NSInteger)row{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestChangeMyCollectStateWithCollectID:collectID succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result)
        if (IS_REQUEST_SUCCEED(result)) {
            [weakSelf.dataArray removeObjectAtIndex:row];
            if (weakSelf.type == 1) {
                [weakSelf.collectionView reloadData];
            }else{
                [weakSelf.tableView reloadData];
            }
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    ECMallProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallProductCell) forIndexPath:indexPath];
    cell.isDelete = self.isEdit;
    cell.model = self.dataArray[indexPath.row];
    [cell setDeleteBlock:^(NSString *collectID,NSInteger row) {
        [weakSelf requestChangeCollectState:collectID WithIndex:row];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallProductModel *model = [self.dataArray objectAtIndexWithCheck:indexPath.row];
    ECMallProductDetailViewController *vc = [[ECMallProductDetailViewController alloc] init];
    vc.protable = model.protable;
    vc.proId = model.proId;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@""];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    if (self.type == 3) {
        ECWorksTableViewCell *cell = [ECWorksTableViewCell cellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.row];
        cell.isDelete = self.isEdit;
        [cell setDeleteBlock:^(NSString *collectID,NSInteger row) {
            [weakSelf requestChangeCollectState:collectID WithIndex:row];
        }];
        return cell;
    }else{
        ECHomeNewsListModel *model = self.dataArray[indexPath.row];
        switch (model.inforType.integerValue) {
            case 0:{//单图
                ECHomeSingleImageTableViewCell *cell = [ECHomeSingleImageTableViewCell cellWithTableView:tableView];
                cell.model = model;
                cell.isDelete = self.isEdit;
                [cell setDeleteBlock:^(NSString *collectID,NSInteger row) {
                    [weakSelf requestChangeCollectState:collectID WithIndex:row];
                }];
                return cell;
            }
                break;
            case 1:{//多图
                ECHomeMoreImageTableViewCell *cell = [ECHomeMoreImageTableViewCell cellWithTableView:tableView];
                cell.model = model;
                cell.isDelete = self.isEdit;
                [cell setDeleteBlock:^(NSString *collectID,NSInteger row) {
                    [weakSelf requestChangeCollectState:collectID WithIndex:row];
                }];
                return cell;
            }
                break;
            case 2:{//无图
                ECHomeNoneImageTableViewCell *cell = [ECHomeNoneImageTableViewCell cellWithTableView:tableView];
                cell.model = model;
                cell.isDelete = self.isEdit;
                [cell setDeleteBlock:^(NSString *collectID,NSInteger row) {
                    [weakSelf requestChangeCollectState:collectID WithIndex:row];
                }];
                return cell;
            }
                break;
            case 3:{//大图
                ECHomeBigImageTableViewCell *cell = [ECHomeBigImageTableViewCell cellWithTableView:tableView];
                cell.model = model;
                cell.isDelete = self.isEdit;
                [cell setDeleteBlock:^(NSString *collectID,NSInteger row) {
                    [weakSelf requestChangeCollectState:collectID WithIndex:row];
                }];
                return cell;
            }
                break;
            case 5:
            case 6:{//不可直接播放视频
                ECHomeVideoTableViewCell *cell = [ECHomeVideoTableViewCell cellWithTableView:tableView];
                cell.model = model;
                cell.isDelete = self.isEdit;
                [cell setDeleteBlock:^(NSString *collectID,NSInteger row) {
                    [weakSelf requestChangeCollectState:collectID WithIndex:row];
                }];
                return cell;
            }
                break;
            default:{
                return nil;
            }
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 3) {
        return 101.f + SCREENWIDTH * (350.f / 750.f);
    }else{
        ECHomeNewsListModel *model = self.dataArray[indexPath.row];
        switch (model.inforType.integerValue) {
            case 0:{//单图
                return 108.f;
            }
                break;
            case 1:{//多图
                
                return 66.f + [CMPublicMethod getHeightWithContent:model.title width:(SCREENWIDTH - 36.f) font:18.f] + (SCREENWIDTH - 45.f) / 3 * (144.f / 220.f);
            }
                break;
            case 2:{//无图
                return 107.f;
            }
                break;
            case 3:{//大图
                return 66.f + [CMPublicMethod getHeightWithContent:model.title width:(SCREENWIDTH - 36.f) font:18.f] + (SCREENWIDTH - 36.f) * (382.f / 678.f);
            }
                break;
            case 5:
            case 6:{//不可直接播放视频
                return 66.f + [CMPublicMethod getHeightWithContent:model.title width:(SCREENWIDTH - 36.f) font:18.f] + (SCREENWIDTH - 36.f) * (382.f / 678.f);
            }
                break;
            default:{
                return 0.f;
            }
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    if (self.type == 3) {
        ECWorksModel *model = self.dataArray[indexPath.row];
        ECWorksDetailViewController *worksDetailVC = [[ECWorksDetailViewController alloc] init];
        worksDetailVC.worksID = model.worksID;
        [SELF_BASENAVI pushViewController:worksDetailVC animated:YES titleLabel:@"详情"];
    }else{
        ECHomeNewsListModel *model = self.dataArray[indexPath.row];
        __block ECHomeNewsListModel *weakModel = model;
        switch (model.inforType.integerValue) {
            case 0://单图
            case 1://多图
            case 2:{//无图
                ECNewsInfoViewController *newsInfoVC = [[ECNewsInfoViewController alloc] init];
                newsInfoVC.BIANMA = model.classify;
                newsInfoVC.informationId = model.newsID;
                [SELF_BASENAVI pushViewController:newsInfoVC animated:YES titleLabel:model.resource];
                
                [newsInfoVC setSendCommentTextBlock:^{
                    weakModel.commentNum = [NSString stringWithFormat:@"%ld",weakModel.commentNum.integerValue + 1];
                    [weakSelf.tableView reloadData];
                }];
            }
                break;
            case 3:{//大图
                ECNewsBigImageViewViewController *newsBigImageVC = [[ECNewsBigImageViewViewController alloc] init];
                newsBigImageVC.BIANMA = model.classify;
                newsBigImageVC.informationId = model.newsID;
                [SELF_BASENAVI pushViewController:newsBigImageVC animated:YES titleLabel:model.title];
                
                [newsBigImageVC setSendCommentTextBlock:^{
                    weakModel.commentNum = [NSString stringWithFormat:@"%ld",weakModel.commentNum.integerValue + 1];
                    [weakSelf.tableView reloadData];
                }];
            }
                break;
            case 5://直接播放视频
            case 6:{//不可直接播放视频
                ECNewsVideoInfoViewController *videoInfoVC = [[ECNewsVideoInfoViewController alloc] init];
                videoInfoVC.BIANMA = model.classify;
                videoInfoVC.informationId = model.newsID;
                [SELF_BASENAVI pushViewController:videoInfoVC animated:YES titleLabel:model.resource];
                
                [videoInfoVC setSendCommentTextBlock:^{
                    weakModel.commentNum = [NSString stringWithFormat:@"%ld",weakModel.commentNum.integerValue + 1];
                    [weakSelf.tableView reloadData];
                }];
            }
                break;
            default:{
            }
                break;
        }
    }
}

@end
