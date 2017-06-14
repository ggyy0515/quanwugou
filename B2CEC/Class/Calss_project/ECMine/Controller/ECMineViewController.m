//
//  ECMineViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMineViewController.h"
#import "ECMineNoneTableViewCell.h"
#import "ECMineUserInfoTableViewCell.h"
#import "ECMineTitleTableViewCell.h"
#import "ECMineOrderTableViewCell.h"
#import "ECMineModel.h"

#import "ECAddressManagementViewController.h"
#import "ECDesignerRegisterViewController.h"
#import "ECSettingViewController.h"
#import "ECUserInfoViewController.h"
#import "ECCollectViewController.h"
#import "ECServiceViewController.h"
#import "ECTeamManagementViewController.h"
#import "ECOrderListViewController.h"
#import "ECWalletViewController.h"
#import "ECDesignerOrderListViewController.h"
#import "ECMaterialLibraryViewController.h"
#import "ECPointManagmentViewController.h"
#import "ECCartViewController.h"
#import "ECNoticeViewController.h"
#import "ECAdvertisingViewController.h"

@interface ECMineViewController ()

//右上角消息中心
@property (strong,nonatomic) UIView *messageView;

@property (strong,nonatomic) UIButton *messageBtn;

@property (strong,nonatomic) UIView *messageRedView;

@property (strong,nonatomic) NSMutableArray *firstNameArray;

@property (strong,nonatomic) NSMutableArray *secondNameArray;

@property (strong,nonatomic) NSMutableArray *thirdNameArray;

@property (strong,nonatomic) NSMutableArray *fourthNameArray;

@property (assign,nonatomic) NSInteger type;

@property (strong,nonatomic) ECMineModel *mineModel;

@end

@implementation ECMineViewController

- (void)addNotificationObserver{
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestMineData), NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestMineData), NOTIFICATION_USER_LOGIN_EXIST, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestMineData), NOTIFICATION_USER_DESIGNER_REGISTER, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestMineData), NOTIFICATION_USER_UPDATE_USERINFO, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestMineData), NOTIFICATION_NAME_USER_POINT_CHANGED, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestMineData), NOTIFICATION_NAME_WALLET_BLANCEN_CHANGE, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestMineData), NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(updateMessageView), NOTIFICATION_GET_PUSH, nil);
}

- (void)dealloc{
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_EXIST, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_DESIGNER_REGISTER, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_UPDATE_USERINFO, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_USER_POINT_CHANGED, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_WALLET_BLANCEN_CHANGE, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_GET_PUSH, nil);
}

- (void)updateMessageView {
    _messageRedView.hidden = NO;
}

- (void)createBasicNameArray{
    [self.firstNameArray removeAllObjects];
    [self.secondNameArray removeAllObjects];
    [self.thirdNameArray removeAllObjects];
    [self.fourthNameArray removeAllObjects];
    
    [self.firstNameArray addObject:@[@"my_wallet",@"我的钱包"]];
    [self.firstNameArray addObject:@[@"point",@"积分管理"]];
    [self.firstNameArray addObject:@[@"shop_666",@"购物车"]];
    [self.firstNameArray addObject:@[@"design",@"设计订单"]];
    if (self.type == 2) {
        [self.firstNameArray addObject:@[@"distribution",@"团队管理"]];
        [self.firstNameArray addObject:@[@"desinger_icon2",@"我的Q码"]];
    }
    if (self.type == 1) {
        [self.firstNameArray addObject:@[@"desinger_icon2",@"我的Q码"]];
    }
    
    [self.secondNameArray addObject:@[@"collection",@"我的收藏"]];
    if (self.type == 2) {
        [self.secondNameArray addObject:@[@"library",@"素材库"]];
    }
    [self.secondNameArray addObject:@[@"address",@"管理收货地址"]];
    [self.secondNameArray addObject:@[@"feedback",@"服务与反馈"]];
    
    if (self.type != 2) {
        [self.thirdNameArray addObject:@[@"desinger_icon2",@"注册为设计师"]];
    }
    
    [self.fourthNameArray addObject:@[@"set-up",@"设置"]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    self.navigationItem.title = @"个人中心";
    [self createUI];
    [self addNotificationObserver];
    [self createBasicNameArray];
    [self requestMineData];
}

- (void)createData{
    _type = -1;
    _firstNameArray = [NSMutableArray new];
    _secondNameArray = [NSMutableArray new];
    _thirdNameArray = [NSMutableArray new];
    _fourthNameArray = [NSMutableArray new];
}

- (void)createUI{
    WEAK_SELF
    
    if (!_messageView) {
        _messageView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_messageView addSubview:_messageBtn];
    [_messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [_messageBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf gotoNoticeCenter];
    }];
    
    if (!_messageRedView) {
        _messageRedView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 8.f, 8.f)];
    }
    _messageRedView.center = CGPointMake(_messageBtn.center.x + 7.f, _messageBtn.center.y - 7);
    [_messageView addSubview:_messageRedView];
    _messageRedView.backgroundColor = CompColor;
    _messageRedView.layer.cornerRadius = 4.f;
    _messageRedView.layer.masksToBounds = YES;
    _messageRedView.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_messageView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStyleGrouped;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestMineData];
    }];
}

- (void)requestMineData{
    if (EC_USER_WHETHERLOGIN) {
        WEAK_SELF
        [ECHTTPServer requestMineDatasucceed:^(NSURLSessionDataTask *task, id result) {
            if (IS_REQUEST_SUCCEED(result)) {
                weakSelf.mineModel = [ECMineModel yy_modelWithDictionary:result];
                [USERDEFAULT setObject:EC_USER_STATUS forKey:weakSelf.mineModel.user.RIGHTS];
                weakSelf.type = weakSelf.mineModel.user.RIGHTS.integerValue;
                weakSelf.messageRedView.hidden = [weakSelf.mineModel.ISEXISTUNREAD isEqualToString:@"0"];
                [weakSelf createBasicNameArray];
                ECLog(@"%@",result);
            }
            [weakSelf.tableView.mj_header endRefreshing];
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }else{
        self.type = -1;
        self.mineModel = nil;
        [self createBasicNameArray];
        [self.tableView reloadData];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type == 2) {
        return 5;
    }else{
        return 6;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return 2;
        }
            break;
        case 2:{
            return self.firstNameArray.count;
        }
            break;
        case 3:{
            return self.secondNameArray.count;
        }
            break;
        case 4:{
            return self.type == 2 ? self.fourthNameArray.count : self.thirdNameArray.count;
        }
            break;
        default:{
            return self.fourthNameArray.count;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.section) {
        case 0:{
            ECMineUserInfoTableViewCell *cell = [ECMineUserInfoTableViewCell cellWithTableView:tableView];
            cell.type = self.type;
            cell.model = self.mineModel;
            return cell;
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    ECMineTitleTableViewCell *cell = [ECMineTitleTableViewCell cellWithTableView:tableView];
                    [cell setIconImage:nil WithTitle:@"我的订单"];
                    cell.detailTitle = @"查看所有订单";
                    return cell;
                }
                    break;
                default:{
                    ECMineOrderTableViewCell *cell = [ECMineOrderTableViewCell cellWithTableView:tableView];
                    cell.model = self.mineModel;
                    [cell setOrderTypeBlock:^(NSInteger type) {
                        NSString *orderStateString = @"";
                        NSString *pushTitle = @"";
                        switch (type) {
                            case 0:
                            {
                                orderStateString = @"For_the_payment";
                                pushTitle = @"待付款";
                            }
                                break;
                            case 1:
                            {
                                orderStateString = @"To_send_the_goods";
                                pushTitle = @"待发货";
                            }
                                break;
                            case 2:
                            {
                                orderStateString = @"For_the_goods";
                                pushTitle = @"待收货";
                            }
                                break;
                            case 3:
                            {
                                orderStateString = @"For_the_Comment";
                                pushTitle = @"待评价";
                            }
                                break;
                            case 4:
                            {
                                orderStateString = @"Return";
                                pushTitle = @"退换货";
                            }
                                break;
                                
                            default:
                                break;
                        }
                        [weakSelf gotoOrderListVCWithStateString:orderStateString title:pushTitle];
                    }];
                    return cell;
                }
                    break;
            }
        }
            break;
        case 2:{
            ECMineTitleTableViewCell *cell = [ECMineTitleTableViewCell cellWithTableView:tableView];
            [cell setIconImage:self.firstNameArray[indexPath.row][0] WithTitle:self.firstNameArray[indexPath.row][1]];
            cell.showDir = YES;
            cell.showRedRound = NO;
            switch (indexPath.row) {
                case 0:{
                    cell.detailTitle = self.type == -1 ? @"" : [NSString stringWithFormat:@"￥%@",self.mineModel.MONEY];
                }
                    break;
                case 1:{
                    cell.detailTitle = self.type == -1 ? @"" : self.mineModel.INTEGRATE;
                }
                    break;
                case 3:{
                    cell.detailTitle = @"";
                    cell.showRedRound = self.mineModel.ISEXISTUNDEAL.integerValue == 1;
                }
                    break;
                case 4:{
                    switch (self.type) {
                        case 1:{
                            cell.showDir = NO;
                            cell.detailTitle = [USERDEFAULT objectForKey:EC_USER_DISCODE];
                        }
                            break;
                        default:{
                            cell.detailTitle = @"";
                        }
                            break;
                    }
                }
                    break;
                case 5:{
                    cell.showDir = NO;
                    cell.detailTitle = [USERDEFAULT objectForKey:EC_USER_DISCODE];
                }
                    break;
                default:{
                    cell.detailTitle = @"";
                }
                    break;
            }
            return cell;
        }
            break;
        case 3:{
            ECMineTitleTableViewCell *cell = [ECMineTitleTableViewCell cellWithTableView:tableView];
            [cell setIconImage:self.secondNameArray[indexPath.row][0] WithTitle:self.secondNameArray[indexPath.row][1]];
            cell.detailTitle = @"";
            return cell;
        }
            break;
        case 4:{
            if (self.type == 2) {
                ECMineTitleTableViewCell *cell = [ECMineTitleTableViewCell cellWithTableView:tableView];
                [cell setIconImage:self.fourthNameArray[indexPath.row][0] WithTitle:self.fourthNameArray[indexPath.row][1]];
                cell.detailTitle = @"";
                return cell;
            }else{
                ECMineTitleTableViewCell *cell = [ECMineTitleTableViewCell cellWithTableView:tableView];
                [cell setIconImage:self.thirdNameArray[indexPath.row][0] WithTitle:self.thirdNameArray[indexPath.row][1]];
                if (self.mineModel == nil) {
                    cell.detailTitle = @"";
                }else{
                    switch (self.mineModel.user.USERSTATE.integerValue) {
                        case 0:{
                            cell.detailTitle = @"审核中";
                        }
                            break;
                        case 2:{
                            cell.detailTitle = @"审核未通过";
                        }
                            break;
                        default:{
                            cell.detailTitle = @"";
                        }
                            break;
                    }
                }
                return cell;
            }
        }
            break;
        default:{
            ECMineTitleTableViewCell *cell = [ECMineTitleTableViewCell cellWithTableView:tableView];
            [cell setIconImage:self.fourthNameArray[indexPath.row][0] WithTitle:self.fourthNameArray[indexPath.row][1]];
            cell.detailTitle = @"";
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return 104.f;
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    return 36.f;
                }
                    break;
                default:{
                    return 93.f;
                }
                    break;
            }
        }
            break;
        case 2:
        case 3:
        case 4:
        default:{
            return 44.f;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:{
            return 8.f;
        }
            break;
        case 2:
        case 3:
        case 4:
        default:{
            return 12.f;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.section) {
        case 0:{
            [self loginState:^{
                ECUserInfoViewController *userInfoVC = [[ECUserInfoViewController alloc] init];
                userInfoVC.userid = [Keychain objectForKey:EC_USER_ID];
                userInfoVC.isEdit = YES;
                [WEAKSELF_BASENAVI pushViewController:userInfoVC animated:YES titleLabel:@""];
            }];
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                NSString *stateString = @"";//@"For_the_payment,To_send_the_goods,For_the_goods,For_the_Comment,Complete,Return,Cancled";
                [self gotoOrderListVCWithStateString:stateString title:@"全部订单"];
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    //我的钱包
                    if (!EC_USER_WHETHERLOGIN) {
                        [APP_DELEGATE callLoginWithViewConcontroller:self
                                                          jumpToMian:NO
                                               clearCurrentLoginInfo:YES
                                                             succeed:^{
                                                                 
                                                             }];
                        return;
                    }
                    ECWalletViewController *vc = [[ECWalletViewController alloc] init];
                    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"我的钱包"];
                }
                    break;
                case 1:{
                    //积分管理
                    if (!EC_USER_WHETHERLOGIN) {
                        [APP_DELEGATE callLoginWithViewConcontroller:self
                                                          jumpToMian:NO
                                               clearCurrentLoginInfo:YES
                                                             succeed:^{
                                                                 
                                                             }];
                        return;
                    }
                    ECPointManagmentViewController *vc = [[ECPointManagmentViewController alloc] init];
                    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"积分管理"];
                }
                    break;
                case 2:{
                    if (!EC_USER_WHETHERLOGIN) {
                        [APP_DELEGATE callLoginWithViewConcontroller:self
                                                          jumpToMian:NO
                                               clearCurrentLoginInfo:YES
                                                             succeed:^{
                                                                 
                                                             }];
                        return;
                    }
                    ECCartViewController *vc = [[ECCartViewController alloc] init];
                    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"购物车"];
                }
                    break;
                case 3:{
                    [self loginState:^{
                        ECDesignerOrderListViewController *designerOrderListVC = [[ECDesignerOrderListViewController alloc] init];
                        designerOrderListVC.isDesigner = weakSelf.mineModel.user.RIGHTS.integerValue == 2;
                        [WEAKSELF_BASENAVI pushViewController:designerOrderListVC animated:YES titleLabel:@"设计订单"];
                    }];
                }
                    break;
                case 4:{
                    switch (self.type) {
                        case 1:{
                            [CMPublicMethod shareToPlatformWithTitle:[USERDEFAULT objectForKey:EC_USER_DISCODE] WithLink:@"" WithQCode:YES];
                        }
                            break;
                        case 2:{
                            [self loginState:^{
                                ECTeamManagementViewController *teamVC = [[ECTeamManagementViewController alloc] init];
                                [WEAKSELF_BASENAVI pushViewController:teamVC animated:YES titleLabel:@"团队管理"];
                            }];
                        }
                            break;
                        default:{
                        }
                            break;
                    }
                }
                    break;
                case 5:{
                    [CMPublicMethod shareToPlatformWithTitle:[USERDEFAULT objectForKey:EC_USER_DISCODE] WithLink:@"" WithQCode:YES];
                }
                    break;
                default:{
                }
                    break;
            }
        }
            break;
        case 3:{
            if (self.type == 2) {
                switch (indexPath.row) {
                    case 0:{
                        [self loginState:^{
                            ECCollectViewController *collectVC = [[ECCollectViewController alloc] init];
                            [WEAKSELF_BASENAVI pushViewController:collectVC animated:YES titleLabel:@"我的收藏"];
                        }];
                    }
                        break;
                    case 1:{
                        [self loginState:^{
                            ECMaterialLibraryViewController *vc = [[ECMaterialLibraryViewController alloc] init];
                            [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"素材"];
                        }];
                    }
                        break;
                    case 2:{
                        [self loginState:^{
                            [weakSelf gotoAddressMagementVC];
                        }];
                    }
                        break;
                    case 3:{
                        [self gotoServiceVC];
                    }
                        break;
                }
            }else{
                switch (indexPath.row) {
                    case 0:{
                        [self loginState:^{
                            ECCollectViewController *collectVC = [[ECCollectViewController alloc] init];
                            [WEAKSELF_BASENAVI pushViewController:collectVC animated:YES titleLabel:@"我的收藏"];
                        }];
                    }
                        break;
                    case 1:{
                        [self loginState:^{
                            [weakSelf gotoAddressMagementVC];
                        }];
                    }
                        break;
                    case 2:{
                        [self gotoServiceVC];
                    }
                        break;
                }
            }
        }
            break;
        case 4:{
            if (self.type == 2) {
                [weakSelf gotoSettingVC];
            }else{
                [self loginState:^{
                    switch (weakSelf.mineModel.user.USERSTATE.integerValue) {
                        case 0:{
                            [SVProgressHUD showInfoWithStatus:@"正在审核中,请耐心等待"];
                        }
                            break;
                        default:{
                            ECAdvertisingViewController *aboutVC = [[ECAdvertisingViewController alloc] init];
                            aboutVC.url =  [NSString stringWithFormat:@"%@%@/common/designRegProt", HOST_ADDRESS, [ECHTTPServer loadApiVersion]];
                            aboutVC.isHavRightNav = YES;
                            [WEAKSELF_BASENAVI pushViewController:aboutVC animated:YES titleLabel:@"设计师注册协议"];
                            [aboutVC setRightNavClickBlock:^{
                                ECDesignerRegisterViewController *designerRegisterVC = [[ECDesignerRegisterViewController alloc] init];
                                designerRegisterVC.isFirst = weakSelf.mineModel.user.USERSTATE.integerValue == 3 ? YES : NO;
                                [WEAKSELF_BASENAVI pushViewController:designerRegisterVC animated:YES titleLabel:@"设计师注册"];
                            }];
                            
                        }
                            break;
                    }
                }];
            }
        }
            break;
        default:{
            [weakSelf gotoSettingVC];
        }
            break;
    }
}

#pragma mark - Actions

- (void)loginState:(void(^)())success{
    if (self.type == -1) {
        [APP_DELEGATE callLoginWithViewConcontroller:self jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
        }];
    }else{
        success();
    }
}

- (void)gotoAddressMagementVC{
    ECAddressManagementViewController *addressMagementVC = [[ECAddressManagementViewController alloc] init];
    [SELF_BASENAVI pushViewController:addressMagementVC animated:YES titleLabel:@"管理收货地址"];
}

- (void)gotoSettingVC{
    ECSettingViewController *settingVC = [[ECSettingViewController alloc] init];
    [SELF_BASENAVI pushViewController:settingVC animated:YES titleLabel:@"设置"];
}

- (void)gotoServiceVC{
    ECServiceViewController *serviceVC = [[ECServiceViewController alloc] init];
    [SELF_BASENAVI pushViewController:serviceVC animated:YES titleLabel:@"服务与反馈"];
}

- (void)gotoOrderListVCWithStateString:(NSString *)state title:(NSString *)title{
    if (!EC_USER_WHETHERLOGIN) {
        [APP_DELEGATE callLoginWithViewConcontroller:self
                                          jumpToMian:NO
                               clearCurrentLoginInfo:YES
                                             succeed:^{
                                                 
                                             }];
        return;
    }
    ECOrderListViewController *vc = [[ECOrderListViewController alloc] init];
    vc.stateString = state;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:title];
}

- (void)gotoNoticeCenter {
    if (!EC_USER_WHETHERLOGIN) {
        [APP_DELEGATE callLoginWithViewConcontroller:self
                                          jumpToMian:NO
                               clearCurrentLoginInfo:YES
                                             succeed:^{
                                                 
                                             }];
        return;
    }
    ECNoticeViewController *vc = [[ECNoticeViewController alloc] init];
    vc.showRightRed = !_messageRedView.hidden;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@""];
}
@end
