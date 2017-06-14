//
//  ECAddressManagementViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAddressManagementViewController.h"
#import "ECAddressManagementTableViewCell.h"
#import "ECAddAddressViewController.h"

@interface ECAddressManagementViewController ()

@property (strong,nonatomic) UIButton *addBtn;

@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation ECAddressManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
    [self requestAddressListWithType:0];
}

- (void)createData{
    _dataArray = [NSMutableArray new];
}

- (void)createUI{
    WEAK_SELF
    
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_addBtn setImage:[UIImage imageNamed:@"navdown_more"] forState:UIControlStateNormal];
    [_addBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        ECAddAddressViewController *addAddressVC = [[ECAddAddressViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:addAddressVC animated:YES titleLabel:@"新增收货地址"];
        [addAddressVC setAddAddressBlock:^{
            [weakSelf requestAddressListWithType:4];
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_addBtn];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestAddressListWithType:(NSInteger)type{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestAddressListsucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            switch (type) {
                case 0:{//单纯请求数据
                    DISMISSSVP
                }
                    break;
                case 1:{//设置默认地址之后
                    [SVProgressHUD showSuccessWithStatus:@"设置默认地址成功"];
                }
                    break;
                case 2:{//删除地址之后
                    [SVProgressHUD showSuccessWithStatus:@"删除地址成功"];
                }
                    break;
                case 3:{//编辑地址之后
                    [SVProgressHUD showSuccessWithStatus:@"修改地址成功"];
                }
                    break;
                case 4:{//添加地址之后
                    [SVProgressHUD showSuccessWithStatus:@"添加地址成功"];
                }
                    break;
                default:{
                    DISMISSSVP
                }
                    break;
            }
            [weakSelf.dataArray removeAllObjects];
            for (NSDictionary *dict in result[@"list"]) {
                ECAddressModel *model = [ECAddressModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
            if (weakSelf.needReloadDataInSuperVCCallBack) {
                weakSelf.needReloadDataInSuperVCCallBack(weakSelf.dataArray);
            }
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestSetDefaults:(NSString *)addressID{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestSetDefaultsAddressWithAddressID:addressID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            [weakSelf requestAddressListWithType:1];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestDelete:(NSString *)addressID{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestDeleteAddressWithAddressID:addressID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            [weakSelf requestAddressListWithType:2];
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
    ECAddressManagementTableViewCell *cell = [ECAddressManagementTableViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    [cell setDefaultAdressClickBlock:^(ECAddressModel *model) {
        [weakSelf requestSetDefaults:model.delivery_id];
    }];
    [cell setEditAdressClickBlock:^(ECAddressModel *model) {
        ECAddAddressViewController *addAddressVC = [[ECAddAddressViewController alloc] init];
        addAddressVC.model = model;
        [WEAKSELF_BASENAVI pushViewController:addAddressVC animated:YES titleLabel:@"编辑地址"];
        [addAddressVC setAddAddressBlock:^{
            [weakSelf requestAddressListWithType:3];
        }];
    }];
    [cell setDeleteAdressClickBlock:^(ECAddressModel *model) {
        [weakSelf requestDelete:model.delivery_id];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECAddressModel *model = self.dataArray[indexPath.row];
    return 104.f + [CMPublicMethod getHeightWithContent:[NSString stringWithFormat:@"%@%@",model.area,model.address] width:(SCREENWIDTH - 24.f) font:15.f];
}

@end
