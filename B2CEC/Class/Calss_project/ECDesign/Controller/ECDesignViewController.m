//
//  ECDesignViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignViewController.h"
#import "ECDesignerScreenView.h"

#import "ECDesignerTableViewCell.h"
#import "ECDesignerModel.h"
#import "ECUserInfoViewController.h"

#import "ECWorksTableViewCell.h"
#import "ECWorksModel.h"
#import "ECWorksDetailViewController.h"

#import "ECSelectCityViewController.h"
#import "ECDesignerSearchViewController.h"

@interface ECDesignViewController ()

@property (strong,nonatomic) UIView *navView;

@property (strong,nonatomic) UIButton *designerBtn;

@property (strong,nonatomic) UIButton *worksBtn;

//@property (strong,nonatomic) UIButton *taskBtn;

@property (strong,nonatomic) UIButton *searchBtn;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) ECDesignerScreenView *screenView;

@property (strong,nonatomic) NSMutableArray *titleArray1;
@property (strong,nonatomic) NSMutableArray *dataArray1;

@property (strong,nonatomic) NSMutableArray *titleArray2;
@property (strong,nonatomic) NSMutableArray *dataArray2;

//@property (strong,nonatomic) NSMutableArray *titleArray3;
//@property (strong,nonatomic) NSMutableArray *dataArray3;

@property (assign,nonatomic) NSInteger type;

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (assign,nonatomic) NSInteger pageIndex;

//----滑动手势----//
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, assign) CGFloat beganX;

@property (nonatomic, assign) CGFloat beganY;
//----滑动手势----//

@end

@implementation ECDesignViewController

- (void)addNotificationObserver{
    ADD_OBSERVER_NOTIFICATION(self, @selector(updateRequestData), NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(updateRequestData), NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)dealloc{
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)updateRequestData{
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotificationObserver];
    [self createData];
    [self createNavUI];
    [self createUI];
}

- (void)createData{
    self.type = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray new];
    _titleArray1 = [NSMutableArray new];
    NSString *city = [CMLocationManager sharedCMLocationManager].userDesignerCityName.length == 0 ? @"城市" : [CMLocationManager sharedCMLocationManager].userDesignerCityName;
    NSString *cityType = [city isEqualToString:@"城市"] ? @"" : city;
    [_titleArray1 addObject:@[city,cityType]];
    [_titleArray1 addObject:@[@"擅长风格",@""]];
    [_titleArray1 addObject:@[@"排序",@""]];
    _dataArray1 = [NSMutableArray new];
    [_dataArray1 addObject:@[]];
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:@[@"全部风格",@""]];
    for (CMWorksTypeModel *model in [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasestyle) {
        [array addObject:@[model.NAME,model.BIANMA]];
    }
    [_dataArray1 addObject:array.mutableCopy];
    [_dataArray1 addObject:@[@[@"时间",@""],
                             @[@"粉丝量",@"FANS_COUNT"],
                             @[@"作品量",@"WORK_COUNT"],
                             @[@"关注量",@"ATTENTION_COUNT"]]];
    
    _titleArray2 = [NSMutableArray new];
    [_titleArray2 addObject:@[@"风格",@""]];
    [_titleArray2 addObject:@[@"类型",@""]];
    [_titleArray2 addObject:@[@"房型",@""]];
    [_titleArray2 addObject:@[@"排序",@""]];
    _dataArray2 = [NSMutableArray new];
    [array removeAllObjects];
    [array addObject:@[@"全部风格",@""]];
    for (CMWorksTypeModel *model in [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasestyle) {
        [array addObject:@[model.NAME,model.BIANMA]];
    }
    [_dataArray2 addObject:array.mutableCopy];
    [array removeAllObjects];
    [array addObject:@[@"全部类型",@""]];
    for (CMWorksTypeModel *model in [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasetype) {
        [array addObject:@[model.NAME,model.BIANMA]];
    }
    [_dataArray2 addObject:array.mutableCopy];
    [array removeAllObjects];
    [array addObject:@[@"全部房型",@""]];
    for (CMWorksTypeModel *model in [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allhousetype) {
        [array addObject:@[model.NAME,model.BIANMA]];
    }
    [_dataArray2 addObject:array.mutableCopy];
    [_dataArray2 addObject:@[@[@"时间",@""],
                             @[@"点赞量",@"praise"],
                             @[@"收藏量",@"collect"]]];
    
//    _titleArray3 = [NSMutableArray new];
//    [_titleArray3 addObject:@[@"任务1",@""]];
//    [_titleArray3 addObject:@[@"任务2",@""]];
//    [_titleArray3 addObject:@[@"任务3",@""]];
//    _dataArray3 = [NSMutableArray new];
//    [_dataArray3 addObjectsFromArray:@[@[],@[],@[]]];   
}

- (void)createNavUI{
    WEAK_SELF
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREENWIDTH / 2.f, 44.f)];
    }
    
    if (!_designerBtn) {
        _designerBtn = [UIButton new];
    }
    [_designerBtn setTitle:@"设计师" forState:UIControlStateNormal];
    [_designerBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _designerBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_designerBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
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
        if (weakSelf.type == 2) {
            return ;
        }
        weakSelf.type = 2;
        [weakSelf clickTypeUpdateUI];
    }];
    
//    if (!_taskBtn) {
//        _taskBtn = [UIButton new];
//    }
//    [_taskBtn setTitle:@"任务" forState:UIControlStateNormal];
//    [_taskBtn setTitleColor:MainColor forState:UIControlStateNormal];
//    _taskBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
//    [_taskBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
//        if (weakSelf.type == 3) {
//            return ;
//        }
//        weakSelf.type = 3;
//        [weakSelf clickTypeUpdateUI];
//    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = MainColor;
    
    [_navView addSubview:_designerBtn];
    [_navView addSubview:_worksBtn];
//    [_navView addSubview:_taskBtn];
    [_navView addSubview:_lineView];
    
    [_designerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.navView.mas_centerX).offset(-16.f);
    }];
    
    [_worksBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.navView.mas_centerX).offset(16.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
//    [_taskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_equalTo(0.f);
//        make.left.mas_equalTo(weakSelf.worksBtn.mas_right).offset(32.f);
//    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.designerBtn);
        make.bottom.mas_equalTo(weakSelf.designerBtn.mas_bottom);
        make.height.mas_equalTo(2.f);
    }];
    
    self.navigationItem.titleView = _navView;
    
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_searchBtn setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [_searchBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        ECDesignerSearchViewController *searchVC = [[ECDesignerSearchViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:searchVC animated:YES titleLabel:@"搜索"];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBtn];
}

- (void)createUI{
    WEAK_SELF
    if (!_screenView) {
        _screenView = [ECDesignerScreenView new];
    }
    _screenView.backgroundColor = [UIColor whiteColor];
    _screenView.titleArray = self.titleArray1;
    _screenView.dataArray = self.dataArray1;
    [_screenView setClickTitleBlock:^(NSInteger index) {
        if (index == 0 && weakSelf.type == 1) {
            ECSelectCityViewController *selectCityVC = [[ECSelectCityViewController alloc] init];
            selectCityVC.type = 2;
            [WEAKSELF_BASENAVI pushViewController:selectCityVC animated:YES titleLabel:@"选择城市"];
            [selectCityVC setSelectCityBlock:^(ECCityModel *model, ECCityModel *detailModel) {
                if (detailModel == nil) {
                    [weakSelf.titleArray1 replaceObjectAtIndex:0 withObject:@[model.NAME,model.NAME]];
                }else{
                    [weakSelf.titleArray1 replaceObjectAtIndex:0 withObject:@[detailModel.NAME,detailModel.NAME]];
                }
                weakSelf.screenView.titleArray = weakSelf.titleArray1;
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
        }
    }];
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
        switch (weakSelf.type) {
            case 1:{
                [weakSelf requestDesigner];
            }
                break;
            case 2:{
                [weakSelf requestWorks];
            }
                break;
//            case 3:{
//                [weakSelf requestTasks];
//            }
//                break;
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        switch (weakSelf.type) {
            case 1:{
                [weakSelf requestDesigner];
            }
                break;
            case 2:{
                [weakSelf requestWorks];
            }
                break;
//            case 3:{
//                [weakSelf requestTasks];
//            }
//                break;
        }
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:_pan];
}

- (void)clickTypeUpdateUI{
    [self.screenView hidden];
    //控制底部细线移动
    switch (self.type) {
        case 1:{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.designerBtn);
                make.bottom.mas_equalTo(self.designerBtn.mas_bottom);
                make.height.mas_equalTo(2.f);
            }];
            
            self.screenView.titleArray = self.titleArray1;
            self.screenView.dataArray = self.dataArray1;
        }
            break;
        case 2:{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.worksBtn);
                make.bottom.mas_equalTo(self.worksBtn.mas_bottom);
                make.height.mas_equalTo(2.f);
            }];
            
            self.screenView.titleArray = self.titleArray2;
            self.screenView.dataArray = self.dataArray2;
        }
            break;
//        case 3:{
//            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.equalTo(self.taskBtn);
//                make.bottom.mas_equalTo(self.taskBtn.mas_bottom);
//                make.height.mas_equalTo(2.f);
//            }];
//            
//            self.screenView.titleArray = self.titleArray3;
//            self.screenView.dataArray = self.dataArray3;
//        }
//            break;
    }
    [self.navView setNeedsUpdateConstraints];
    [self.navView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25f animations:^{
        [self.navView layoutIfNeeded];
    }];
    [self.tableView.mj_header beginRefreshing];
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
                if (_type < 2) {
                    [self changeNum:1];
                }
            }
        }
        _beganX = 0;
        _beganY = 0;
    }
}

-(void)changeNum:(NSInteger)num {
    self.type = self.type + num;
    [self clickTypeUpdateUI];
}

- (void)requestDesigner{
    WEAK_SELF
    NSArray *array = self.screenView.titleArray;
    [ECHTTPServer requestDesignerListWithOrderBy:array[2][1]
                                        WithCity:array[0][1]
                                       WithStyle:array[1][1]
                                   WithPageIndex:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
                                       if (IS_REQUEST_SUCCEED(result)) {
                                           if (weakSelf.pageIndex == 1) {
                                               [weakSelf.dataArray removeAllObjects];
                                           }
                                           for (NSDictionary *dict in result[@"designList"]) {
                                               [weakSelf.dataArray addObject:[ECDesignerModel yy_modelWithDictionary:dict]];
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

- (void)requestWorks{
    WEAK_SELF
    NSArray *array = self.screenView.titleArray;
    [ECHTTPServer requestDesignerCaseListWithStyle:array[0][1]
                                          WithType:array[1][1]
                                         WithHouse:array[2][1]
                                         WithOrder:array[3][1]
                                     WithPageIndex:self.pageIndex
                                           succeed:^(NSURLSessionDataTask *task, id result) {
                                               if (IS_REQUEST_SUCCEED(result)) {
                                                   if (weakSelf.pageIndex == 1) {
                                                       [weakSelf.dataArray removeAllObjects];
                                                   }
                                                   for (NSDictionary *dict in result[@"caseList"]) {
                                                       [weakSelf.dataArray addObject:[ECWorksModel yy_modelWithDictionary:dict]];
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

//- (void)requestTasks{
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
//    ECLog(@"request Tasks : %@",self.screenView.titleArray);
//}

- (void)requestFocusClickWithIndex:(NSInteger)index{
    SHOWSVP
    WEAK_SELF
    ECDesignerModel *model = self.dataArray[index];
    [ECHTTPServer requestFocusAndFansFocusWithUserID:model.USER_ID succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            ECDesignerModel *mode = weakSelf.dataArray[index];
            if ([mode.ATTENTION isEqualToString:@"1"] || mode.ATTENTION.length == 0) {
                mode.ATTENTION = @"0";
            }else{
                mode.ATTENTION = @"1";
            }
            [weakSelf.tableView reloadData];
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
    switch (self.type) {
        case 1:{
            ECDesignerTableViewCell *cell = [ECDesignerTableViewCell cellWithTableView:tableView];
            [cell setFocusClickBlock:^(NSInteger row) {
                if (EC_USER_WHETHERLOGIN) {
                    [weakSelf requestFocusClickWithIndex:row];
                }else{
                    [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
                    }];
                }
            }];
            cell.model = self.dataArray[indexPath.row];
            return cell;
        }
            break;
        case 2:{
            ECWorksTableViewCell *cell = [ECWorksTableViewCell cellWithTableView:tableView];
            cell.model = self.dataArray[indexPath.row];
            return cell;
        }
            break;
//        case 3:{
//            return nil;
//        }
//            break;
        default:{
            return nil;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case 1:{
            return 93.f + SCREENWIDTH * (168.f / 750.f);
        }
            break;
        case 2:{
            return 101.f + SCREENWIDTH * (350.f / 750.f);
        }
            break;
//        case 3:{
//            return 0.f;
//        }
//            break;
        default:{
            return 0.f;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case 1:{
            ECDesignerModel *model = self.dataArray[indexPath.row];
            ECUserInfoViewController *userInfoVC = [[ECUserInfoViewController alloc] init];
            userInfoVC.userid = model.USER_ID;
            userInfoVC.isEdit = NO;
            [SELF_BASENAVI pushViewController:userInfoVC animated:YES titleLabel:@""];
        }
            break;
        case 2:{
            ECWorksModel *model = self.dataArray[indexPath.row];
            ECWorksDetailViewController *worksDetailVC = [[ECWorksDetailViewController alloc] init];
            worksDetailVC.worksID = model.worksID;
            [SELF_BASENAVI pushViewController:worksDetailVC animated:YES titleLabel:@"详情"];
        }
            break;
//        case 3:{
//        }
//            break;
        default:{
        }
            break;
    }
}

@end
