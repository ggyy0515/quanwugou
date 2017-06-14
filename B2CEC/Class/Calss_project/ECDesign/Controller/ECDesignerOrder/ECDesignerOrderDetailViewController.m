//
//  ECDesignerOrderDetailViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderDetailViewController.h"
#import "ECDesignerModel.h"
#import "ECDesignerOrderDetailUserInfoTableViewCell.h"
#import "ECDesignerOrderDetailAddressTableViewCell.h"
#import "ECDesignerOrderDetailInfoTableViewCell.h"
#import "ECDesignerOrderDetailContentTableViewCell.h"
#import "ECUserInfoEvaluationCommentTableViewCell.h"
#import "ECDesignerOrderDetailBottomView.h"
#import "ECDesignerOrderCommentTitleTableViewCell.h"

#import "ECCommitOrderInfoModel.h"

#import "ECPlaceOrderViewController.h"
#import "ECDesignerOrderOfferViewController.h"
#import "ECPaymentViewController.h"
#import "ECDesignerOrderCommentViewController.h"
#import "ECDesignerOrderDetailViewController.h"

#import "ChatViewController.h"
#import "ECChatListModel.h"
#import "ECUserInfoCommentModel.h"

@interface ECDesignerOrderDetailViewController ()

@property (strong,nonatomic) ECDesignerOrderDetailModel *detailModel;

@property (strong,nonatomic) ECUserInfoCommentModel *commentModel;

@property (strong,nonatomic) ECDesignerOrderDetailBottomView *bottomView;

@end

@implementation ECDesignerOrderDetailViewController

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

}

- (void)createUI{
    WEAK_SELF
    if (!_bottomView) {
        _bottomView = [ECDesignerOrderDetailBottomView new];
    }
    _bottomView.hidden = YES;
    _bottomView.isDesigner = self.isDesigner;
    [_bottomView setClickOperationBlock:^(NSInteger type) {
        switch (type) {
            case 0:{//婉拒
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定婉拒该订单吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf requestCancelDesignerOrder];
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
                [weakSelf gotoDesignerOrderOfferWithIsDelete:YES];
            }
                break;
            case 2:{//取消订单
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定取消该订单吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf requestCancelDesignerOrder];
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
                [weakSelf gotoEditOrderInfo];
            }
                break;
            case 4:{//确认并支付
                [weakSelf gotoPatMentVC];
            }
                break;
            case 5:{//设计师确认完工
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定该订单已完成吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf requestDesignerOrderCompleteWithState:0];
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
                                                                               [weakSelf requestDesignerOrderCompleteWithState:1];
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
                                                                               [weakSelf requestDesignerOrderReturnMoney];
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
                [weakSelf gotoDesignerOrderComment];
            }
                break;
            case 9:{//设计师修改报价
                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                     andText:@"您确定修改该订单报价吗?"
                                                                             andCancelButton:YES
                                                                                forAlertType:AlertInfo
                                                                       withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                           if (blockBtn == blockAlert.defaultButton) {
                                                                               [weakSelf requestDesignerOrderReturnMoney];
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
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestOrderDetail];
    }];
    
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(45.f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestOrderDetail{
    WEAK_SELF
    [ECHTTPServer requestDesignerOrderDetail:self.orderid succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            NSLog(@"%@",result);
            weakSelf.detailModel = [ECDesignerOrderDetailModel yy_modelWithDictionary:result[@"designeOrder"]];
            weakSelf.commentModel = [ECUserInfoCommentModel yy_modelWithDictionary:result[@"commentInfo"]];
            weakSelf.bottomView.hidden = NO;
            weakSelf.bottomView.model = weakSelf.detailModel;
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)requestCancelDesignerOrder{
    WEAK_SELF
    SHOWSVP
    [ECHTTPServer requestCancelDesignerOrder:self.detailModel.orderid succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.isDesigner) {
                [SVProgressHUD showSuccessWithStatus:@"已婉拒该订单"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"已取消该订单"];
            }
            if (weakSelf.updateSuccessBlock) {
                weakSelf.updateSuccessBlock();
            }
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestDesignerOrderOfferWithMoney:(CGFloat)money WithIsDelete:(BOOL)isDelete{
    WEAK_SELF
    SHOWSVP
    [ECHTTPServer requestDesignerOrderOfferWithID:self.detailModel.orderid WithMoney:money succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            [SVProgressHUD showSuccessWithStatus:@"报价成功,等待对方确认"];
            if (weakSelf.updateSuccessBlock) {
                weakSelf.updateSuccessBlock();
            }
            if (isDelete) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }else{
                weakSelf.detailModel.money = [NSString stringWithFormat:@"%f",money];
                weakSelf.bottomView.model = weakSelf.detailModel;
            }
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestDesignerOrderCompleteWithState:(NSInteger)type{
    WEAK_SELF
    SHOWSVP
    NSString *state = type == 0 ? @"Designer_complate" : @"daipingjia";
    [ECHTTPServer requestDesignerOrderCompleteWithOrderID:self.detailModel.orderid WithState:state succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.updateSuccessBlock) {
                weakSelf.updateSuccessBlock();
            }
            if (type == 0) {
                [SVProgressHUD showSuccessWithStatus:@"您已确认完工,等待对方确认"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"您已确认完工"];
            }
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestDesignerOrderReturnMoney{
    WEAK_SELF
    SHOWSVP
    [ECHTTPServer requestDesignerOrderReturnMoney:self.detailModel.orderid succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            RequestSuccess(result);
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)gotoEditOrderInfo{
    WEAK_SELF
    ECPlaceOrderModel *orderModel = [[ECPlaceOrderModel alloc] init];
    orderModel.orderID = self.detailModel.orderid;
    orderModel.designer_id = self.detailModel.designer_id;
    orderModel.describe = self.detailModel.describe;
    orderModel.housearea = self.detailModel.housearea;
    orderModel.cycle = self.detailModel.cycle;
    orderModel.location = self.detailModel.location;
    orderModel.lat = self.detailModel.lat;
    orderModel.lng = self.detailModel.lng;
    orderModel.housetype = self.detailModel.housetype;
    orderModel.decoratetype = self.detailModel.decoratetype;
    orderModel.style = self.detailModel.style;
    orderModel.claim = self.detailModel.claim;
    orderModel.imgurls = self.detailModel.imgurls;
    
    ECPlaceOrderViewController *placeOrderVC = [[ECPlaceOrderViewController alloc] init];
    placeOrderVC.orderModel = orderModel;
    placeOrderVC.designerName = self.detailModel.dname;
    placeOrderVC.designerTitleImage = self.detailModel.dtitle_img;
    placeOrderVC.isUpdate = YES;
    [SELF_BASENAVI pushViewController:placeOrderVC animated:YES titleLabel:@"修改订单"];
    [placeOrderVC setSubmitSuccessBlock:^{
        if (weakSelf.updateSuccessBlock) {
            weakSelf.updateSuccessBlock();
        }
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

- (void)gotoDesignerOrderOfferWithIsDelete:(BOOL)isDelete{
    WEAK_SELF
    [ECDesignerOrderOfferViewController showOfferVCInSuperViewController:self verifyResultBlock:^(CGFloat money) {
        [weakSelf requestDesignerOrderOfferWithMoney:money WithIsDelete:isDelete];
    }];
}

- (void)gotoPatMentVC{
    ECCommitOrderInfoModel *payModel = [[ECCommitOrderInfoModel alloc] init];
    payModel.orderNumbers = @[self.detailModel.orderid];
    payModel.totalPrice = self.detailModel.money;
    payModel.leftPay = @"0";
    payModel.nowPay = self.detailModel.money;
    payModel.type = @"designpay";
    
    ECPaymentViewController *vc = [[ECPaymentViewController alloc] initWithPopClass:[self class]];
    vc.model = payModel;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"支付总额"];
}

- (void)gotoDesignerOrderComment{
    ECDesignerOrderCommentViewController *designerOrderCommentVC = [[ECDesignerOrderCommentViewController alloc] init];
    designerOrderCommentVC.orderID = self.detailModel.orderid;
    designerOrderCommentVC.designerIconImage = self.detailModel.dtitle_img;
    designerOrderCommentVC.designerName = self.detailModel.dname;
    [SELF_BASENAVI pushViewController:designerOrderCommentVC animated:YES titleLabel:@"评价"];
    
    WEAK_SELF
    [designerOrderCommentVC setCommentSuccessBlock:^{
        if (weakSelf.updateSuccessBlock) {
            weakSelf.updateSuccessBlock();
        }
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.detailModel == nil) {
        return 0;
    }
    if ([self.detailModel.state isEqualToString:@"complate"]) {//如果是已评价  则显示评价
        return 5;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 4 ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.section) {
        case 0:{
            ECDesignerOrderDetailUserInfoTableViewCell *cell = [ECDesignerOrderDetailUserInfoTableViewCell cellWithTableView:tableView];
            cell.isDesigner = self.isDesigner;
            cell.model = self.detailModel;
            [cell setChatClickBlock:^{
                ECChatListModel *chatModel = [[ECChatListModel alloc] init];
                if (weakSelf.isDesigner) {
                    chatModel.firendIds = weakSelf.detailModel.user_id;
                    chatModel.name = weakSelf.detailModel.uname;
                    chatModel.headImage = weakSelf.detailModel.utitle_img;
                    ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:weakSelf.detailModel.user_id conversationType:EMConversationTypeChat];
                    vc.chatListModel = chatModel;
                    [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:weakSelf.detailModel.uname];
                }else{
                    chatModel.firendIds = weakSelf.detailModel.designer_user_id;
                    chatModel.name = weakSelf.detailModel.dname;
                    chatModel.headImage = weakSelf.detailModel.dtitle_img;
                    ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:weakSelf.detailModel.designer_user_id conversationType:EMConversationTypeChat];
                    vc.chatListModel = chatModel;
                    [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:weakSelf.detailModel.dname];
                }
            }];
            return cell;
        }
            break;
        case 1:{
            ECDesignerOrderDetailAddressTableViewCell *cell = [ECDesignerOrderDetailAddressTableViewCell cellWithTableView:tableView];
            cell.location = self.detailModel.location;
            return cell;
        }
            break;
        case 2:{
            ECDesignerOrderDetailInfoTableViewCell *cell = [ECDesignerOrderDetailInfoTableViewCell cellWithTableView:tableView];
            cell.model = self.detailModel;
            return cell;
        }
            break;
        case 3:{
            ECDesignerOrderDetailContentTableViewCell *cell = [ECDesignerOrderDetailContentTableViewCell cellWithTableView:tableView];
            cell.content = self.detailModel.claim;
            cell.imgUrls = self.detailModel.imgurls;
            return cell;
        }
            break;
        default:{
            switch (indexPath.row) {
                case 0:{
                    ECDesignerOrderCommentTitleTableViewCell *cell = [ECDesignerOrderCommentTitleTableViewCell cellWithTableView:tableView];
                    return cell;
                }
                    break;
                default:{
                    ECUserInfoEvaluationCommentTableViewCell *cell = [ECUserInfoEvaluationCommentTableViewCell cellWithTableView:tableView];
                    cell.model = self.commentModel;
                    return cell;
                }
                    break;
            }
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return 134.f;
        }
            break;
        case 1:{
            return 64.f;
        }
            break;
        case 2:{
            return 305.f;
        }
            break;
        case 3:{
            CGFloat height = 75.f + [CMPublicMethod getHeightWithContent:self.detailModel.claim width:(SCREENWIDTH - 24.f) font:16.f];
            if (self.detailModel.imgurls.count == 0) {
                return height;
            }
            height += 12.f;
            height += ceill(self.detailModel.imgurls.count / 3.f) * ((SCREENWIDTH - 44.f) / 3.f * (144.f / 220.f));
            height += (ceil(self.detailModel.imgurls.count / 3.f) - 1) * 10.f;
            return height;
        }
            break;
        default:{
            switch (indexPath.row) {
                case 0:{
                    return 44.f;
                }
                    break;
                default:{
                    CGFloat height = [CMPublicMethod getHeightWithContent:self.commentModel.comment width:(SCREENWIDTH - 24.f) font:16.f] + 104.f;
                    if (self.commentModel.imgurls.count != 0) {
                        height += 88.f;
                    }
                    return height;
                }
                    break;
            }
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.detailModel.state isEqualToString:@"complate"]) {//如果是已评价  则显示评价
        return section == 4 ? 0.f : 12.f;
    }
    return section == 3 ? 0.f : 12.f;
}

@end
