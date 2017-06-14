//
//  ECDesignerOrderListViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderListViewController.h"
#import "ECDesignerOrderTypeView.h"
#import "ECDesignerOrderModel.h"
#import "ECDesignerOrderListTableViewCell.h"

#import "ECCommitOrderInfoModel.h"

#import "ECPlaceOrderViewController.h"
#import "ECDesignerOrderOfferViewController.h"
#import "ECPaymentViewController.h"
#import "ECDesignerOrderCommentViewController.h"
#import "ECDesignerOrderDetailViewController.h"

@interface ECDesignerOrderListViewController ()

@property (strong,nonatomic) ECDesignerOrderTypeView *typeView;

@property (strong,nonatomic) NSArray *typeDataArray;

@property (strong,nonatomic) NSMutableArray *dataArray;

@property (assign,nonatomic) NSInteger pageIndex;

//----滑动手势----//
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, assign) CGFloat beganX;

@property (nonatomic, assign) CGFloat beganY;
//----滑动手势----//

@end

@implementation ECDesignerOrderListViewController

- (void)addNotificationObserver{
    ADD_OBSERVER_NOTIFICATION(self, @selector(updateRequestData), NOTIFICATION_DESIGNER_PAY_SUCCESS, nil);
}

- (void)dealloc{
    REMOVE_NOTIFICATION(self, NOTIFICATION_DESIGNER_PAY_SUCCESS, nil);
}

- (void)updateRequestData{
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotificationObserver];
    [self createData];
    [self createUI];
}

- (void)createData{
    _dataArray = [NSMutableArray new];
    if (self.isDesigner) {
        _typeDataArray = @[@[@"待接单",@"yixiadan"],
                           @[@"已报价",@"daiqueren"],
                           @[@"进行中",@"jinxingzhong"],
                           @[@"已完成",@"Designer_complate,daipingjia,complate"],
                           @[@"其他",@"yiquxiao,reback_money_ing,yituikuan"]];
    }else{
        _typeDataArray = @[@[@"已下单",@"yixiadan"],
                           @[@"待确认",@"daiqueren"],
                           @[@"进行中",@"jinxingzhong,Designer_complate"],
                           @[@"已完成",@"daipingjia,complate"],
                           @[@"其他",@"yiquxiao,reback_money_ing,yituikuan"]];
    }
}

- (void)createUI{
    WEAK_SELF
    
    if (!_typeView) {
        _typeView = [ECDesignerOrderTypeView new];
    }
    _typeView.dataArray = self.typeDataArray;
    _typeView.currentIndex = 0;
    [_typeView setDidSelectIndex:^(NSInteger index) {
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf requestOrderList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestOrderList];
    }];
    
    [self.view addSubview:_typeView];
    
    [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.typeView.mas_bottom);
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:_pan];
    _pan.enabled = NO;
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
                if (self.typeView.currentIndex > 0) {
                    [self changeNum:-1];
                }
            }else if (translation.x < _beganX && (_beganX - translation.x) > OFFSET_TRIGGER_DIRECTION){
                //goForward
                if (self.typeView.currentIndex < 4) {
                    [self changeNum:1];
                }
            }
        }
        _beganX = 0;
        _beganY = 0;
    }
}

-(void)changeNum:(NSInteger)num {
    self.typeView.currentIndex = self.typeView.currentIndex + num;
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestOrderList{
    WEAK_SELF
    NSString *state = [[self.typeDataArray objectAtIndexWithCheck:self.typeView.currentIndex] objectAtIndexWithCheck:1];
    NSLog(@"state : %@",state);
    [ECHTTPServer requestDesignerOrderListWithState:state WithPageIndex:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            NSLog(@"%@",result);
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"list"]) {
                ECDesignerOrderModel *model = [ECDesignerOrderModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
            weakSelf.pan.enabled = YES;
            if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.pageIndex) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        RequestFailure
    }];
}

- (void)requestCancelDesignerOrder:(NSInteger)index{
    WEAK_SELF
    SHOWSVP
    ECDesignerOrderModel *model = [self.dataArray objectAtIndexWithCheck:index];
    [ECHTTPServer requestCancelDesignerOrder:model.orderID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.isDesigner) {
                [SVProgressHUD showSuccessWithStatus:@"已婉拒该订单"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"已取消该订单"];
            }
            [weakSelf.dataArray removeObjectAtIndex:index];
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestDesignerOrderOffer:(NSInteger)index WithMoney:(CGFloat)money WithIsDelete:(BOOL)isDelete{
    WEAK_SELF
    SHOWSVP
    ECDesignerOrderModel *model = [self.dataArray objectAtIndexWithCheck:index];
    [ECHTTPServer requestDesignerOrderOfferWithID:model.orderID WithMoney:money succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            [SVProgressHUD showSuccessWithStatus:@"报价成功,等待对方确认"];
            if (isDelete) {
                [weakSelf.dataArray removeObjectAtIndex:index];
            }else{
                ECDesignerOrderModel *weakModel = [weakSelf.dataArray objectAtIndexWithCheck:index];
                weakModel.money = [NSString stringWithFormat:@"%f",money];
            }
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestDesignerOrderComplete:(NSInteger)index WithState:(NSInteger)type{
    WEAK_SELF
    SHOWSVP
    NSString *state = type == 0 ? @"Designer_complate" : @"daipingjia";
    ECDesignerOrderModel *model = [self.dataArray objectAtIndexWithCheck:index];
    [ECHTTPServer requestDesignerOrderCompleteWithOrderID:model.orderID WithState:state succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (type == 0) {
                [SVProgressHUD showSuccessWithStatus:@"您已确认完工,等待对方确认"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"您已确认完工"];
            }
            [weakSelf.dataArray removeObjectAtIndex:index];
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestDesignerOrderReturnMoney:(NSInteger)index{
    WEAK_SELF
    SHOWSVP
    ECDesignerOrderModel *model = [self.dataArray objectAtIndexWithCheck:index];
    [ECHTTPServer requestDesignerOrderReturnMoney:model.orderID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            RequestSuccess(result);
            [weakSelf.dataArray removeObjectAtIndex:index];
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)gotoEditOrderInfo:(NSInteger)index{
    WEAK_SELF
    ECDesignerOrderModel *model = [self.dataArray objectAtIndexWithCheck:index];
    
    ECPlaceOrderModel *orderModel = [[ECPlaceOrderModel alloc] init];
    orderModel.orderID = model.orderID;
    orderModel.designer_id = model.designer_id;
    orderModel.describe = model.describe;
    orderModel.housearea = model.housearea;
    orderModel.cycle = model.cycle;
    orderModel.location = model.location;
    orderModel.lat = model.lat;
    orderModel.lng = model.lng;
    orderModel.housetype = model.housetype;
    orderModel.decoratetype = model.decoratetype;
    orderModel.style = model.style;
    orderModel.claim = model.claim;
    orderModel.imgurls = model.imgurls;
    
    ECPlaceOrderViewController *placeOrderVC = [[ECPlaceOrderViewController alloc] init];
    placeOrderVC.orderModel = orderModel;
    placeOrderVC.designerName = model.dname;
    placeOrderVC.designerTitleImage = model.dtitle_img;
    placeOrderVC.isUpdate = YES;
    [SELF_BASENAVI pushViewController:placeOrderVC animated:YES titleLabel:@"修改订单"];
    [placeOrderVC setSubmitSuccessBlock:^{
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

- (void)gotoDesignerOrderOffer:(NSInteger)index WithIsDelete:(BOOL)isDelete{
    WEAK_SELF
    [ECDesignerOrderOfferViewController showOfferVCInSuperViewController:self verifyResultBlock:^(CGFloat money) {
        [weakSelf requestDesignerOrderOffer:index WithMoney:money WithIsDelete:isDelete];
    }];
}

- (void)gotoPatMentVC:(NSInteger)index{
    ECDesignerOrderModel *model = [self.dataArray objectAtIndexWithCheck:index];
    
    ECCommitOrderInfoModel *payModel = [[ECCommitOrderInfoModel alloc] init];
    payModel.orderNumbers = @[model.orderID];
    payModel.totalPrice = model.money;
    payModel.leftPay = @"0";
    payModel.nowPay = model.money;
    payModel.type = @"designpay";
    
    ECPaymentViewController *vc = [[ECPaymentViewController alloc] initWithPopClass:[self class]];
    vc.model = payModel;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"支付总额"];
}

- (void)gotoDesignerOrderComment:(NSInteger)index{
    ECDesignerOrderModel *model = [self.dataArray objectAtIndexWithCheck:index];
    
    ECDesignerOrderCommentViewController *designerOrderCommentVC = [[ECDesignerOrderCommentViewController alloc] init];
    designerOrderCommentVC.orderID = model.orderID;
    designerOrderCommentVC.designerIconImage = model.dtitle_img;
    designerOrderCommentVC.designerName = model.dname;
    [SELF_BASENAVI pushViewController:designerOrderCommentVC animated:YES titleLabel:@"评价"];
    
    WEAK_SELF
    [designerOrderCommentVC setCommentSuccessBlock:^{
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECDesignerOrderListTableViewCell *cell = [ECDesignerOrderListTableViewCell cellWithTableView:tableView];
    cell.isDesigner = self.isDesigner;
    cell.model = self.dataArray[indexPath.section];
    [cell setClickOperationBlock:^(NSInteger type,NSInteger section) {
        switch (type) {
            case 0:{//婉拒
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定婉拒该订单吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf requestCancelDesignerOrder:section];
                                                                           }
                                                                       }];
                [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
                alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert.defaultButton setTitle:@"婉拒订单" forState:UIControlStateNormal];
                alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert show];
            }
                break;
            case 1:{//报价接单
                [weakSelf gotoDesignerOrderOffer:section WithIsDelete:YES];
            }
                break;
            case 2:{//取消订单
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定取消该订单吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf requestCancelDesignerOrder:section];
                                                                           }
                                                                       }];
                [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
                alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert.defaultButton setTitle:@"取消订单" forState:UIControlStateNormal];
                alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert show];
            }
                break;
            case 3:{//修改订单
                [weakSelf gotoEditOrderInfo:section];
            }
                break;
            case 4:{//确认并支付
                [weakSelf gotoPatMentVC:section];
            }
                break;
            case 5:{//设计师确认完工
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定该订单已完成吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf requestDesignerOrderComplete:section WithState:0];
                                                                           }
                                                                       }];
                [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
                alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert.defaultButton setTitle:@"完成订单" forState:UIControlStateNormal];
                alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert show];
            }
                break;
            case 6:{//用户确认完工
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定该订单已完成吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf requestDesignerOrderComplete:section WithState:1];
                                                                           }
                                                                       }];
                [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
                alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert.defaultButton setTitle:@"完成订单" forState:UIControlStateNormal];
                alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert show];
            }
                break;
            case 7:{//用户点击申请退款
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定对该订单申请退款吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf requestDesignerOrderReturnMoney:section];
                                                                           }
                                                                       }];
                [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
                alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert.defaultButton setTitle:@"申请退款" forState:UIControlStateNormal];
                alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert show];
            }
                break;
            case 8:{//评价
                [weakSelf gotoDesignerOrderComment:section];
            }
                break;
            case 9:{//设计师修改报价
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定修改该订单报价吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf gotoDesignerOrderOffer:section WithIsDelete:NO];
                                                                           }
                                                                       }];
                [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
                alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert.defaultButton setTitle:@"修改报价" forState:UIControlStateNormal];
                alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
                [alert show];
            }
                break;
            default:
                break;
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = ceil(5 / floorf((SCREENWIDTH - 24.f) / 76.f));
    return 170.f + 25 * count + 12.f * (count - 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECDesignerOrderModel *model = [self.dataArray objectAtIndexWithCheck:indexPath.section];
    ECDesignerOrderDetailViewController *designerOrderDetailVC = [[ECDesignerOrderDetailViewController alloc] init];
    designerOrderDetailVC.isDesigner = self.isDesigner;
    designerOrderDetailVC.orderid = model.orderID;;
    [SELF_BASENAVI pushViewController:designerOrderDetailVC animated:YES titleLabel:@"订单详情"];
    [designerOrderDetailVC setUpdateSuccessBlock:^{
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

@end
