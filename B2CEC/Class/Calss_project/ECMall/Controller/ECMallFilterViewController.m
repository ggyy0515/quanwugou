//
//  ECMallFilterViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallFilterViewController.h"
#import "ECFilterPriceTableViewCell.h"
#import "ECFilterTableViewCell.h"
#import "ECMallFilterHeaderView.h"
#import "ECMallDataParser.h"
#import "ECMallTagModel.h"
#import "ECMallHouseModel.h"

@interface ECMallFilterViewController ()

/*!
 *  重置
 */
@property (strong,nonatomic) UIButton *clearBtn;
/*!
 *  确认
 */
@property (strong,nonatomic) UIButton *confirmBtn;
/*!
 *  属性列表
 */
@property (strong,nonatomic) NSMutableArray *dataArray;
/*!
 *  当前选中的属性
 */
@property (strong,nonatomic) NSMutableArray *currentIndexArray;
/*!
 *  最低价
 */
@property (assign,nonatomic) CGFloat minPrice;
/*!
 *  最高价
 */
@property (assign,nonatomic) CGFloat maxPrice;
/**
 二级分类
 */
@property (nonatomic, copy) NSString *secondType;
/**
 筛选时选中的馆的编码
 */
@property (nonatomic, copy) NSString *sHouseCode;
/**
 二级分类数据源 (重用ECMallTagModel)
 */
@property (nonatomic, strong) NSMutableArray <ECMallTagModel *> *secondTypeDataSource;
/**
 场馆数据源
 */
@property (nonatomic, strong) NSMutableArray <ECMallHouseModel *> *houseDataSource;
/**
 选择的馆的序号
 */
@property (nonatomic, assign) NSInteger houseIndex;
/**
 选择的二级分类的序号
 */
@property (nonatomic, assign) NSInteger secondTypeIndex;


@end

@implementation ECMallFilterViewController

- (instancetype)init {
    if (self = [super init]) {
        _secondTypeDataSource = [NSMutableArray array];
        _houseDataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    _houseIndex = -1;
    _secondTypeIndex = -1;
    [self createBasicData];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataFilterSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    // 开启 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)createBasicData{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    if (_currentIndexArray == nil) {
        _currentIndexArray = [NSMutableArray new];
    }
    _minPrice = 0.f;
    _maxPrice = 0.f;
}

- (void)createUI{
    WEAK_SELF
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(20.f);
        make.bottom.mas_equalTo(-50.f);
    }];
    
    //
    if (!_clearBtn) {
        _clearBtn = [UIButton new];
    }
    [_clearBtn setTitle:@"重置" forState:UIControlStateNormal];
    [_clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _clearBtn.backgroundColor = MainColor;
    _clearBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:_clearBtn];
    [_clearBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf clearFilter];
    }];
    
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
    }
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = UIColorFromHexString(@"#EB3A41");
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:_confirmBtn];
    [_confirmBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        //判断价格区间是否有误
        if (weakSelf.minPrice > weakSelf.maxPrice) {
            [CMPublicMethod showInfoWithString:@"最低价格不能大于最高价格"];
            return ;
        }
        NSMutableArray *attrArray = [NSMutableArray new];
        for (int i = 0; i < weakSelf.dataArray.count; i ++) {
            if ([weakSelf.currentIndexArray[i] integerValue] != -1) {
                [attrArray addObject:@{@"attrcode":weakSelf.dataArray[i][@"ATTRCODE"],
                                       @"attrvalue":weakSelf.dataArray[i][@"VALUES"][[weakSelf.currentIndexArray[i] integerValue]][@"NAME"]}];
            }
        }
        
        if (attrArray.count == 0) {
            weakSelf.attrs = nil;
        }
        
        if (weakSelf.submitFiltrateClick) {
            weakSelf.submitFiltrateClick(weakSelf.minPrice, weakSelf.maxPrice, attrArray.count == 0 ? nil : [attrArray JSONString], weakSelf.sHouseCode, weakSelf.secondType);
        }
        [weakSelf.navigationController dismissCurrentPopinControllerAnimated:YES];
    }];
    
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.tableView.mas_bottom);
        make.width.mas_equalTo(weakSelf.confirmBtn.mas_width);
    }];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.width.equalTo(weakSelf.clearBtn);
        make.right.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.clearBtn.mas_right);
    }];
}

- (void)loadDataFilterSource{
    //获取筛选条件的key
    NSString *key = [NSString stringWithFormat:@"%@%@", _houseCode ? _houseCode : @"", _catCode];
    //判断是否请求过改分类编码，如果请求过，则直接使用，否则请求服务器
    if ([UnarchiveSearchCondition objectForKey:key] == nil) {
        SHOWSVP
        [ECMallDataParser loadProductFiltrateWithHouseCode:_houseCode ? _houseCode : @""
                                                   catCode:_catCode
                                                 WithBlock:^(BOOL isSucceed) {
                                                     if (isSucceed) {
                                                         [self configDataSource];
                                                     }
                                                 }];
    } else {
        [self configDataSource];
    }
    
}


/**
 设置缓存中的数据源
 */
- (void)configDataSource {
    //获取筛选条件的key
    NSString *key = [NSString stringWithFormat:@"%@%@", _houseCode ? _houseCode : @"", _catCode];
    //筛选条件数据
    self.dataArray = [[UnarchiveSearchCondition objectForKey:key] objectForKey:@"filtrates"];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_currentIndexArray addObject:@(-1)];
    }];
    //二级分类数据
    NSArray *array = [UnarchiveSearchCondition objectForKey:key][@"secondType"];
    [_secondTypeDataSource removeAllObjects];
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        ECMallTagModel *model = [ECMallTagModel yy_modelWithDictionary:dic];
        [_secondTypeDataSource addObject:model];
    }];
    //场馆数据
    if ([UnarchiveSearchCondition objectForKey:key][@"productHall"]) {
        array = [UnarchiveSearchCondition objectForKey:key][@"productHall"];
        [_houseDataSource removeAllObjects];
        [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            ECMallHouseModel *model = [ECMallHouseModel yy_modelWithDictionary:dic];
            [_houseDataSource addObject:model];
        }];
    }
    if (self.attrs.length != 0) {
        [self updateCurrentIndex];
    }
    //重载表单
    [self.tableView reloadData];
}

- (void)updateCurrentIndex{
    NSArray *attrsArray = [NSJSONSerialization JSONObjectWithData:[self.attrs dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSDictionary *firstDict = [self.dataArray objectAtIndexWithCheck:i];
        if ([firstDict[@"ATTRCODE"] isEqualToString:attrsArray[0][@"attrcode"]]) {
            NSArray *valuesArray = (NSArray *)firstDict[@"VALUES"];
            for (int k = 0; k < valuesArray.count; k ++) {
                NSDictionary *secDict = [valuesArray objectAtIndexWithCheck:k];
                if ([secDict[@"NAME"] isEqualToString:attrsArray[0][@"attrvalue"]]) {
                    [self.currentIndexArray replaceObjectAtIndex:i withObject:@(k)];
                }
            }
        }
    }
}

- (void)clearFilter{
    for (int i = 0; i < self.dataArray.count; i ++) {
        [self.currentIndexArray replaceObjectAtIndex:i withObject:@(-1)];
    }
    self.minPrice = 0.f;
    self.maxPrice = 0.f;
    self.houseIndex = -1;
    self.secondTypeIndex = -1;
    self.sHouseCode = nil;
    self.secondType = nil;
    self.attrs = nil;
    [self.tableView reloadData];
    if (self.submitFiltrateClick) {
        self.submitFiltrateClick(self.minPrice/*0*/, self.maxPrice/*0*/, nil, self.sHouseCode/*nil*/, self.secondType/*nil*/);
    }
}


#pragma mark  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count + 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    
    switch (indexPath.section) {
        case 0:
        {//价格区间
            ECFilterPriceTableViewCell *cell = [ECFilterPriceTableViewCell cellWithTableView:tableView isPickDate:NO];
            cell.leftString = @"最低价";
            cell.rightString = @"最高价";
            cell.minPrice = _minPrice;
            cell.maxPrice = _maxPrice;
            [cell setChangePriceBlock:^(CGFloat minPrice, CGFloat maxPrice) {
                weakSelf.minPrice = minPrice;
                weakSelf.maxPrice = maxPrice;
            }];
            return cell;
        }

        case 1:
        {
            //场馆
            ECFilterTableViewCell *cell = [ECFilterTableViewCell cellWithTableView:tableView conditionType:ConditionCellType_house];
            cell.houseDataSource = _houseDataSource;
            cell.currentIndex = _houseIndex;
            [cell setCurrentClick:^(NSInteger currentIndex, ConditionCellType type) {
                if (type == ConditionCellType_house) {
                    weakSelf.houseIndex = currentIndex;
                    ECMallHouseModel *model = [weakSelf.houseDataSource objectAtIndexedSubscript:currentIndex];
                    weakSelf.sHouseCode = model.code;
                }
            }];
            return cell;
        }
            
        case 2:
        {
            //二级分类
            ECFilterTableViewCell *cell = [ECFilterTableViewCell cellWithTableView:tableView conditionType:ConditionCellType_secondType];
            cell.secondTypeDataSource = _secondTypeDataSource;
            cell.currentIndex = _secondTypeIndex;
            [cell setCurrentClick:^(NSInteger currentIndex, ConditionCellType type) {
                if (type == ConditionCellType_secondType) {
                    weakSelf.secondTypeIndex = currentIndex;
                    ECMallTagModel *model = [weakSelf.secondTypeDataSource objectAtIndexWithCheck:currentIndex];
                    weakSelf.secondType = model.code;
                }
            }];
            return cell;
        }
            
            
        default:
        {
            //其他条件
            ECFilterTableViewCell *cell = [ECFilterTableViewCell cellWithTableView:tableView conditionType:ConditionCellType_other];
            cell.dataArray = self.dataArray[indexPath.section - 3][@"VALUES"];
            cell.currentIndex = [_currentIndexArray[indexPath.section - 3] integerValue];
            [cell setCurrentClick:^(NSInteger currentIndex, ConditionCellType cellType) {
                if (cellType == ConditionCellType_other) {
                    [weakSelf.currentIndexArray replaceObjectAtIndex:(indexPath.section - 3) withObject:@(currentIndex)];
                }
            }];
            return cell;
        }
    }
    /*
    switch (indexPath.section) {
        case 0:{//价格区间
            ECFilterPriceTableViewCell *cell = [ECFilterPriceTableViewCell cellWithTableView:tableView isPickDate:NO];
            cell.leftString = @"最低价";
            cell.rightString = @"最高价";
            cell.minPrice = _minPrice;
            cell.maxPrice = _maxPrice;
            [cell setChangePriceBlock:^(CGFloat minPrice, CGFloat maxPrice) {
                weakSelf.minPrice = minPrice;
                weakSelf.maxPrice = maxPrice;
            }];
            return cell;
        }
        default:{//其他条件
            ECFilterTableViewCell *cell = [ECFilterTableViewCell cellWithTableView:tableView conditionType:ConditionCellType_other];
            cell.dataArray = self.dataArray[indexPath.section - 1][@"VALUES"];
            cell.currentIndex = [_currentIndexArray[indexPath.section - 1] integerValue];
            [cell setCurrentClick:^(NSInteger currentIndex, ConditionCellType cellType) {
                if (cellType == ConditionCellType_other) {
                    [weakSelf.currentIndexArray replaceObjectAtIndex:(indexPath.section - 1) withObject:@(currentIndex)];
                }
            }];
            return cell;
        }
    } */
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ECMallFilterHeaderView *headerView = [ECMallFilterHeaderView new];
    switch (section) {
        case 0:
        {
            //价格区间
            headerView.name = @"价格区间";
        }
            break;
        case 1:
        {
            //馆
            headerView.name = @"展馆";
        }
            break;
        case 2:
        {
            //二级分类
            headerView.name = @"品类";
        }
            break;

        default:
        {
            //其它条件
            headerView.name = self.dataArray[section - 3][@"ATTRNAME"];
        }
            break;
    }
//    headerView.name = section == 0 ? @"价格区间" : self.dataArray[section - 1][@"ATTRNAME"];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (_houseCode && ![_houseCode isEqualToString:@""]) {
            return 0;
        }
    }
    return 46.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 43.f;
        }
        case 1:
        {
            if (_houseCode && ![_houseCode isEqualToString:@""]) {
                return 0;
            }
            return ((CGRectGetWidth(tableView.frame) - 46.f)/5.5f * ceil(_houseDataSource.count / 5.f));
        }
        case 2:
        {
            return (43.f * ceil(_secondTypeDataSource.count / 3.f));
        }

            
        default:
        {
            return (43.f * ceil(((NSArray *)self.dataArray[indexPath.section - 3][@"VALUES"]).count / 3.f));
        }
            break;
    }
//    return indexPath.section == 0 ? 43.f : (43.f * ceil(((NSArray *)self.dataArray[indexPath.section - 1][@"VALUES"]).count / 3.f));
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
