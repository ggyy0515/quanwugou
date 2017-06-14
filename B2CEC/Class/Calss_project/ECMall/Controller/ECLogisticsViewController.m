//
//  ECLogisticsViewController.m
//  B2CEC
//
//  Created by 曙华 on 16/7/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECLogisticsViewController.h"
#import "ECTextTableViewCell.h"
#import "ECLogisticsOrderCell.h"
#import "ECLogisticsAddresCell.h"
#import "ECOrderProductModel.h"
#import "ECOrderListModel.h"
@interface ECLogisticsViewController ()

@property (nonatomic, copy) NSArray *dataArr;

@property (nonatomic, copy) NSString *state;

@end

@implementation ECLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dataArr = [NSArray new];
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)creatUI{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableViewStyle = UITableViewStyleGrouped;
    WEAK_SELF
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf.view);
        make.right.mas_equalTo(weakSelf.view).offset(-8);
        make.left.mas_equalTo(weakSelf.view).offset(8);
    }];
}


- (void)loadDataSource{
    SHOWSVP
    [ECHTTPServer requestExpressDeliveryWithCom:_model.expressCode
                                    OrderNumber:_model.expressNumber
                                        succeed:^(NSURLSessionDataTask *task, id result) {
                                            DISMISSSVP
                                            _dataArr = result[@"queryLogistics"][@"data"];
                                            _state = result[@"queryLogistics"][@"state"];
                                            [self.tableView reloadData];
                                        }
                                         failed:^(NSURLSessionDataTask *task, NSError *error) {
                                             RequestFailure
                                         }];
}

#pragma mark - tabelViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return _dataArr.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ECTextTableViewCell *cell = [ECTextTableViewCell cellWithTableView:tableView];
            cell.name = [NSString stringWithFormat:@"订单号：%@",_model.orderNo];
            cell.nameColor = LightMoreColor;
            cell.nameFont = 14.f;
            
            cell.detail = [NSString stringWithFormat:@"%@ 下单",_model.createTime];
            cell.detailColor = LightColor;
            cell.detailFont = 12.f;
           
            return cell;
        }else{
            ECLogisticsOrderCell *cell = [ECLogisticsOrderCell cellWithTableView:tableView];
            cell.logisticsNum = _model.expressNumber;
            cell.express = _model.express;
            cell.logisticsState = _state;
            cell.imageUrl = ((ECOrderProductModel *)[_model.productList objectAtIndex:0]).image;
            return cell;
        }
    }
    
    if (indexPath.row == 0) {
        ECTextTableViewCell *cell = [ECTextTableViewCell cellWithTableView:tableView];
        cell.name = @"物流跟踪";
        cell.nameColor = LightMoreColor;
        cell.nameFont = 12.f;
        return cell;
    }
    ECLogisticsAddresCell *cell = [ECLogisticsAddresCell cellWithTableView:tableView];
    cell.addressLabel.text = [_dataArr objectAtIndexWithCheck:indexPath.row-1][@"context"];
    cell.dateLabel.text = [_dataArr objectAtIndexWithCheck:indexPath.row-1][@"time"];
    if (indexPath.row == 1) {
        cell.isFristOrFinall = 1;
    }else if (indexPath.row == _dataArr.count) {
        cell.isFristOrFinall = 2;
    }else{
        cell.isFristOrFinall = 0;
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40.f;
        }
        return 72.f;
    }
    
    if (indexPath.row == 0) {
        return 30.f;
    }
    NSString *str = @"【深圳市】 快件已到达 深圳转运中心我的大吊早已饥渴难耐";
    CGFloat addressHeight = [CMPublicMethod getHeightWithContent:str width:SCREENWIDTH-48 font:14.f];
    return 68.f+addressHeight-20.f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 8.f;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
