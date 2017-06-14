//
//  ECSelectAddressViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECSelectAddressViewController.h"
#import "ECSelectAddressTableViewCell.h"
#import "ECAddressManagementViewController.h"

@interface ECSelectAddressViewController ()

@property (strong,nonatomic) UIButton *managmentBtn;

@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation ECSelectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
    [self requestAddressList];
}

- (void)createData{
    _dataArray = [NSMutableArray new];
}

- (void)createUI{
    WEAK_SELF
    
    if (!_managmentBtn) {
        _managmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_managmentBtn setTitle:@"管理" forState:UIControlStateNormal];
    [_managmentBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _managmentBtn.titleLabel.font = FONT_32;
    [_managmentBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        ECAddressManagementViewController *addressManagmentVC = [[ECAddressManagementViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:addressManagmentVC animated:YES titleLabel:@"管理收货地址"];
        [addressManagmentVC setNeedReloadDataInSuperVCCallBack:^(NSMutableArray *dataSource) {
            weakSelf.dataArray = dataSource.mutableCopy;
            [weakSelf.tableView reloadData];
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_managmentBtn];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestAddressList{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestAddressListsucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            [weakSelf.dataArray removeAllObjects];
            for (NSDictionary *dict in result[@"list"]) {
                ECAddressModel *model = [ECAddressModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
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
    ECSelectAddressTableViewCell *cell = [ECSelectAddressTableViewCell cellWithTableView:tableView];
    [cell setModel:self.dataArray[indexPath.row] WithAddressID:self.addressID];
    [cell setSelectAddressBlock:^(ECAddressModel *model) {
        weakSelf.addressID = model.delivery_id;
        [weakSelf.tableView reloadData];
        if (weakSelf.selectAddressBlock) {
            weakSelf.selectAddressBlock(model);
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECAddressModel *model = self.dataArray[indexPath.row];
    return 64.f + [CMPublicMethod getHeightWithContent:[NSString stringWithFormat:@"%@%@",model.area,model.address] width:(SCREENWIDTH - 136.f) font:14.f];
}

@end
