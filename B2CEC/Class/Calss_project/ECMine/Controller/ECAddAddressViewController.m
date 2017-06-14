//
//  ECAddAddressViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAddAddressViewController.h"
#import "ECAddAddressTableViewCell.h"
#import "ECSelectCityViewController.h"

@interface ECAddAddressViewController ()

@property (strong,nonatomic) NSString *address;

@end

@implementation ECAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = BaseColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestAddAddressWithName:(NSString *)name
                        WithPhone:(NSString *)phone
                      WithAddress:(NSString *)address
                WithAddressDetail:(NSString *)addressDetail
                     WithDefaults:(BOOL)isDefaults{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestAddAddressWithName:name WithPhone:phone WithAddress:address WithAddressDetail:addressDetail WithDefauls:isDefaults succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.addAddressBlock) {
                weakSelf.addAddressBlock();
            }
            [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestEditAddressWithName:(NSString *)name
                         WithPhone:(NSString *)phone
                       WithAddress:(NSString *)address
                 WithAddressDetail:(NSString *)addressDetail{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestEditAddressWithAddressID:self.model.delivery_id WithName:name WithPhone:phone WithAddress:address WithAddressDetail:addressDetail succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.addAddressBlock) {
                weakSelf.addAddressBlock();
            }
            [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECAddAddressTableViewCell *cell = [ECAddAddressTableViewCell cellWithTableView:tableView];
    if (self.model == nil) {
        cell.address = self.address;
    }else{
        cell.model = self.model;
    }
    [cell setSelectCityBlock:^{
        ECSelectCityViewController *selectCityVC = [[ECSelectCityViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:selectCityVC animated:YES titleLabel:@"选择城市"];
        [selectCityVC setSelectCityBlock:^(ECCityModel *model, ECCityModel *detailModel) {
            if (weakSelf.model == nil) {
                if (detailModel == nil) {
                    weakSelf.address = model.NAME;
                }else{
                    weakSelf.address = [NSString stringWithFormat:@"%@,%@",model.NAME,detailModel.NAME];
                }
            }else{
                if (detailModel == nil) {
                    weakSelf.model.area = model.NAME;
                }else{
                    weakSelf.model.area = [NSString stringWithFormat:@"%@,%@",model.NAME,detailModel.NAME];
                }
            }
            [weakSelf.tableView reloadData];
        }];
    }];
    [cell setSaveAddressBlock:^(NSString *name,NSString *phone,NSString *address,NSString *addressDetail,BOOL isDefaults) {
        if (weakSelf.model == nil) {
            [weakSelf requestAddAddressWithName:name WithPhone:phone WithAddress:address WithAddressDetail:addressDetail WithDefaults:isDefaults];
        }else{
            [weakSelf requestEditAddressWithName:name WithPhone:phone WithAddress:address WithAddressDetail:addressDetail];
        }
        
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
