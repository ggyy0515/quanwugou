//
//  ECCartViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCartViewController.h"
#import "ECCartProductCell.h"
#import "ECCartProductModel.h"
#import "ECCartSectionHeader.h"
#import "ECCartFactoryModel.h"
#import "ECCartBottomView.h"
#import "ECConfirmOrderViewController.h"


@interface ECCartViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <ECCartFactoryModel *> *dataSource;
@property (nonatomic, strong) ECCartBottomView *bottomView;

@end

@implementation ECCartViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    ADD_OBSERVER_NOTIFICATION(self, @selector(loadDataSource), NOTIFICATION_NAME_RELOAD_CART_DATA, nil);
    
    [self createUI];
    [self loadDataSource];
}

- (void)dealloc {
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_RELOAD_CART_DATA, nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [self batchModifyProductCount];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_bottomView) {
        _bottomView = [[ECCartBottomView alloc] init];
    }
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(49.f);
    }];
    _bottomView.isEdit = NO;
    _bottomView.price = 0.f;
    [_bottomView setClickOrderBtn:^{
        //去结算
        [weakSelf gotoConfirmOrder];
    }];
    
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50.f, 30.f)];
    }
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
    _editBtn.titleLabel.font = FONT_32;
    [_editBtn setTitleColor:UIColorFromHexString(@"#1a191e") forState:UIControlStateNormal];
    [_editBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.bottomView.isEdit = !weakSelf.bottomView.isEdit;
        sender.selected = weakSelf.bottomView.isEdit;
    }];
    _editBtn.selected = _bottomView.isEdit;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[ECCartProductCell class]
       forCellReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECCartProductCell)];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = BaseColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
    //---------action block
    //全选、取消全选
    [_bottomView setClickAllBtn:^(BOOL selectAll) {
        CGFloat __block price = 0;
        [weakSelf.dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                price = price + model.count.integerValue * model.price.floatValue;
                model.isSelectet = selectAll;
            }];
        }];
        [weakSelf.tableView reloadData];
        weakSelf.bottomView.price = price;
    }];
    //删除
    [_bottomView setClickDeleteBtn:^{
        if ([weakSelf loadSelectedProductsCount] > 0) {
            [weakSelf deleteProductWithCartIdString:[weakSelf loadSelectedCartIdString]];
        } else {
            [SVProgressHUD showInfoWithStatus:@"还没有选择商品哦"];
        }
    }];
    //转到收藏
    [_bottomView setClickCollectBtn:^{
        if ([weakSelf loadSelectedProductsCount] > 0) {
            [weakSelf requestCollectProduct:[weakSelf loadSelectCollectIDString]];
        } else {
            [SVProgressHUD showInfoWithStatus:@"还没有选择商品哦"];
        }
    }];
    
}

#pragma mark - Actions

- (void)loadDataSource {
    [ECHTTPServer requestCartListWithUserId:[Keychain objectForKey:EC_USER_ID]
                                    succeed:^(NSURLSessionDataTask *task, id result) {
                                        if (IS_REQUEST_SUCCEED(result)) {
                                            DISMISSSVP
                                            [_dataSource removeAllObjects];
                                            [result[@"cart"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                ECCartFactoryModel *model = [ECCartFactoryModel yy_modelWithDictionary:dic];
                                                [_dataSource addObject:model];
                                            }];
                                            [_tableView reloadData];
                                        } else {
                                            EC_SHOW_REQUEST_ERROR_INFO
                                        }
                                    }
                                     failed:^(NSURLSessionDataTask *task, NSError *error) {
                                        RequestFailure
                                     }];
}

//获取当前数据源中选中商品的数量（选中的条目数量）
- (NSInteger)loadSelectedProductsCount {
    NSInteger __block count = 0;
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.isSelectet) {
                count ++;
            }
        }];
    }];
    return count;
}

//获取当前数据源中选中商品的cartid拼接成的cartIdString
- (NSString *)loadSelectedCartIdString {
    NSMutableArray <NSString *> *selectedCartIdList = [NSMutableArray array];
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.isSelectet) {
                [selectedCartIdList addObject:model.cartId];
            }
        }];
    }];
    NSString *cartIdString = [selectedCartIdList componentsJoinedByString:@","];
    return cartIdString;
}
//获取当前数据源中选中商品的表名与商品名用于批量收藏
- (NSString *)loadSelectCollectIDString{
    NSMutableArray *selectedCartIdList = [NSMutableArray array];
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.isSelectet) {
                [selectedCartIdList addObject:@{@"PRODUCT_ID":model.proId,@"PROTABLE":model.protable}];
            }
        }];
    }];
    return [selectedCartIdList JSONString];
}
//从内存中删除当前数据源中选中的商品
- (void)removeSelectedProductInDataSource {
    
    [_dataSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [factoryModel.productList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(ECCartProductModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.isSelectet) {
                [CMPublicDataManager sharedCMPublicDataManager].cartNumber = [CMPublicDataManager sharedCMPublicDataManager].cartNumber - model.count.integerValue;
                [factoryModel.productList removeObject:model];
            }
        }];
        if (factoryModel.productList.count == 0) {
            [_dataSource removeObject:factoryModel];
        }
    }];
    
}

//获取选中商品的总价
- (CGFloat)loadSelectedProductTotalPrice {
    CGFloat __block price = 0;
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.isSelectet) {
                price = price + model.count.integerValue * model.price.floatValue;
            }
        }];
    }];
    return price;
}

//删除商品
- (void)deleteProductWithCartIdString:(NSString *)cartIdString {
    SHOWSVP
    [ECHTTPServer requestDeleteCartProductsWithCartIdString:cartIdString
                                                    succeed:^(NSURLSessionDataTask *task, id result) {
                                                        if (IS_REQUEST_SUCCEED(result)) {
                                                            RequestSuccess(result)
                                                            [self removeSelectedProductInDataSource];
                                                            [_tableView reloadData];
                                                        } else {
                                                            EC_SHOW_REQUEST_ERROR_INFO
                                                        }
                                                    }
                                                     failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                        RequestFailure
                                                     }];
}
//批量收藏商品
- (void)requestCollectProduct:(NSString *)collectStr{
    SHOWSVP
    [ECHTTPServer requestCollectMoreProductWithInfo:collectStr succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            RequestSuccess(result)
        } else {
            EC_SHOW_REQUEST_ERROR_INFO
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

//批量改变商品的数量
- (void)batchModifyProductCount {
    if (_dataSource.count == 0) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{
                                  @"PROQTY":model.count,
                                  @"ORD_CART_ID":model.cartId
                                  };
            [array addObject:dic];
        }];
    }];
    NSString *jsonString = [array JSONString];
    [ECHTTPServer requestModifyCartProductCountWithParamString:jsonString
                                                       succeed:^(NSURLSessionDataTask *task, id result) {
                                                           if (IS_REQUEST_SUCCEED(result)) {
                                                               ECLog(@"批量修改购物车数量成功");
                                                           } else {
                                                               EC_SHOW_REQUEST_ERROR_INFO
                                                           }
                                                       }
                                                        failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                            [SVProgressHUD showErrorWithStatus:@"请求变更购物车数量时发生错误"];
                                                        }];
}

- (void)gotoConfirmOrder {
    NSInteger selectCount = [self loadSelectedProductsCount];
    if (selectCount == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择要结算的商品"];
        return;
    }
    ECConfirmOrderViewController *vc = [[ECConfirmOrderViewController alloc] init];
    NSMutableArray *confirmDataSource = [NSMutableArray array];
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [confirmDataSource addObject:obj.mutableCopy];
    }];
    [confirmDataSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [factoryModel.productList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(ECCartProductModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!model.isSelectet) {
                [factoryModel.productList removeObject:model];
            }
        }];
        if (factoryModel.productList.count == 0) {
            [confirmDataSource removeObject:factoryModel];
        }
    }];
    vc.confirmType = ConfirmOrderType_cartCommit;
    vc.dataSource = confirmDataSource;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"确认订单"];
}

#pragma mark - UITableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ECCartFactoryModel *model = [_dataSource objectAtIndexWithCheck:section];
    return model.productList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 184.f / 2.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ECCartSectionHeader *header = [[ECCartSectionHeader alloc] init];
    ECCartFactoryModel *model = [_dataSource objectAtIndexWithCheck:section];
    header.model = model;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    ECCartProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECCartProductCell)];
    ECCartFactoryModel *factoryModel = [_dataSource objectAtIndexWithCheck:indexPath.section];
    ECCartProductModel *model = [factoryModel.productList objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    [cell setClickSelectBtn:^{
        CGFloat price = [weakSelf loadSelectedProductTotalPrice];
        weakSelf.bottomView.price = price;
    }];
    [cell setChangeCountBlock:^{
        CGFloat price = [weakSelf loadSelectedProductTotalPrice];
        weakSelf.bottomView.price = price;
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
