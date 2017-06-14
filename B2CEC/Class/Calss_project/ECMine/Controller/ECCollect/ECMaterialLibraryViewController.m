//
//  ECMaterialLibraryViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMaterialLibraryViewController.h"
#import "ECDesignerScreenView.h"
#import "ECMaterialLibraryModel.h"
#import "ECMaterialLibrarTableViewCell.h"

#import "ECMaterialLibraryCollectViewController.h"

@interface ECMaterialLibraryViewController ()

@property (strong,nonatomic) UIButton *collectBtn;

@property (strong,nonatomic) ECDesignerScreenView *screenView;

@property (strong,nonatomic) NSMutableArray *titleArray1;
@property (strong,nonatomic) NSMutableArray *dataArray1;

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (assign,nonatomic) NSInteger pageIndex;

@end

@implementation ECMaterialLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}

- (void)createData{
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray new];

    NSMutableArray *array = [NSMutableArray new];
    _titleArray1 = [NSMutableArray new];
    [_titleArray1 addObject:@[@"风格",@""]];
    [_titleArray1 addObject:@[@"类型",@""]];
    [_titleArray1 addObject:@[@"排序",@""]];
    
    _dataArray1 = [NSMutableArray new];
    [array removeAllObjects];
    [array addObject:@[@"全部风格",@""]];
    for (CMWorksTypeModel *model in [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasestyle) {
        [array addObject:@[model.NAME,model.BIANMA]];
    }
    [_dataArray1 addObject:array.mutableCopy];
    [array removeAllObjects];
    [array addObject:@[@"全部类型",@""]];
    for (CMWorksTypeModel *model in [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasetype) {
        [array addObject:@[model.NAME,model.BIANMA]];
    }
    [_dataArray1 addObject:array.mutableCopy];
    [_dataArray1 addObject:@[@[@"时间",@""],
                             @[@"收藏量",@"collect"]]];
}

- (void)createUI{
    WEAK_SELF
    
    if (!_collectBtn) {
        _collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 44.f)];
    }
    [_collectBtn setTitle:@"收藏夹" forState:UIControlStateNormal];
    [_collectBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _collectBtn.titleLabel.font = FONT_32;
    [_collectBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        ECMaterialLibraryCollectViewController *vc = [[ECMaterialLibraryCollectViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"收藏夹"];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_collectBtn];

    
    if (!_screenView) {
        _screenView = [ECDesignerScreenView new];
    }
    _screenView.backgroundColor = [UIColor whiteColor];
    _screenView.titleArray = self.titleArray1;
    _screenView.dataArray = self.dataArray1;
    [_screenView setSelectTypeBlock:^{
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    
    [self.view addSubview:_screenView];
    
    [_screenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(40.f);
    }];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.screenView.mas_bottom);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf requestMaterialLibraryData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestMaterialLibraryData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestMaterialLibraryData{
    WEAK_SELF
    NSArray *array = self.screenView.titleArray;
    [ECHTTPServer requestMaterialLibraryWithStyle:array[0][1]
                                         WithType:array[1][1]
                                        WithOrder:array[2][1]
                                    WithPageIndex:self.pageIndex
                                          succeed:^(NSURLSessionDataTask *task, id result) {
                                            if (IS_REQUEST_SUCCEED(result)) {
                                                if (weakSelf.pageIndex == 1) {
                                                    [weakSelf.dataArray removeAllObjects];
                                                }
                                                for (NSDictionary *dict in result[@"materialList"]) {
                                                    [weakSelf.dataArray addObject:[ECMaterialLibraryModel yy_modelWithDictionary:dict]];
                                                }
                                                [weakSelf.tableView reloadData];
                                                if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.pageIndex) {
                                                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                }else{
                                                    [weakSelf.tableView.mj_footer endRefreshing];
                                                }
                                            }
                                            [weakSelf.tableView.mj_header endRefreshing];
                                        } failed:^(NSURLSessionDataTask *task, NSError *error) {
                                            [weakSelf.tableView.mj_header endRefreshing];
                                            [weakSelf.tableView.mj_footer endRefreshing];
                                        }];
}

- (void)requestCollect:(NSInteger)row{
    SHOWSVP
    WEAK_SELF
    ECMaterialLibraryModel *model = [self.dataArray objectAtIndexWithCheck:row];
    [ECHTTPServer requestCollectMaterialLibrary:model.libID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            ECMaterialLibraryModel *weakModel = [weakSelf.dataArray objectAtIndexWithCheck:row];
            if ([weakModel.isCollect isEqualToString:@"0"]) {
                weakModel.isCollect = @"1";
                weakModel.collect = [NSString stringWithFormat:@"%ld",weakModel.collect.integerValue + 1];
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }else{
                weakModel.isCollect = @"0";
                weakModel.collect = [NSString stringWithFormat:@"%ld",weakModel.collect.integerValue - 1];
                [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            }
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECMaterialLibrarTableViewCell *cell = [ECMaterialLibrarTableViewCell cellWithTableView:tableView];
    cell.model = [self.dataArray objectAtIndexWithCheck:indexPath.row];
    [cell setCollectBlock:^(NSInteger row) {
        [weakSelf requestCollect:row];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 101.f + SCREENWIDTH * (350.f / 750.f);
}

@end
