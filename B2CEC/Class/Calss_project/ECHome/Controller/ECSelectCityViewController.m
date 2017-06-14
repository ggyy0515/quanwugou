//
//  ECSelectCityViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECSelectCityViewController.h"
#import "ECSelectCityTableViewCell.h"

@interface ECSelectCityViewController ()

@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation ECSelectCityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
    if (self.model == nil) {
        [self requestCityData];
    }else{
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.model.subDict];
        [self.tableView reloadData];
    }
}

- (void)createData{
    _dataArray = [NSMutableArray array];
}

- (void)createUI{
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0.f);
    }];
}

- (void)requestCityData{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestCityListSucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            for (NSDictionary *dict in result[@"data"]) {
                ECCityModel *model = [ECCityModel yy_modelWithDictionary:dict];
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

- (void)setSettingCity:(NSString *)name{
    switch (self.type) {
        case 0:{
            [CMLocationManager sharedCMLocationManager].userNewsCityName = name;
        }
            break;
        case 1:{
            [CMLocationManager sharedCMLocationManager].userCityName = name;
        }
            break;
        case 2:{
            [CMLocationManager sharedCMLocationManager].userDesignerCityName = name;
        }
            break;
        default:
            break;
    }
}

- (void)BackToJoinVC{
    for (NSInteger i = SELF_BASENAVI.viewControllers.count - 1; i >= 0; i --) {
        if (![[SELF_BASENAVI.viewControllers objectAtIndex:i] isKindOfClass:[ECSelectCityViewController class]]) {
            [SELF_BASENAVI popToViewController:[SELF_BASENAVI.viewControllers objectAtIndex:i] animated:YES];
            return;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECSelectCityTableViewCell *cell = [ECSelectCityTableViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    if (self.model == nil) {
        ECCityModel *model = self.dataArray[indexPath.row];
        if (model.subDict.count == 0) {
            [self setSettingCity:model.NAME];
            if (self.selectCityBlock) {
                self.selectCityBlock(model,nil);
            }
            [self BackToJoinVC];
        }else{
            ECSelectCityViewController *selectCityVC = [[ECSelectCityViewController alloc] init];
            selectCityVC.model = model;
            selectCityVC.type = self.type;
            [SELF_BASENAVI pushViewController:selectCityVC animated:YES titleLabel:@"选择城市"];
            [selectCityVC setSelectCityBlock:^(ECCityModel *model, ECCityModel *detailModel) {
                if (weakSelf.selectCityBlock) {
                    weakSelf.selectCityBlock(model,detailModel);
                }
                [weakSelf BackToJoinVC];
            }];
        }
    }else{
        ECCityModel *model = self.dataArray[indexPath.row];
        [self setSettingCity:model.NAME];
        if (self.selectCityBlock) {
            self.selectCityBlock(self.model,model);
        }
    }
}

@end
