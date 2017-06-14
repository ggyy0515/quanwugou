//
//  ECDesignerRegisterViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerRegisterViewController.h"
#import "ECDesignerRegisterTableViewCell.h"
#import "ECDesignerRegisterModel.h"
#import "ECSelectCityViewController.h"
#import "ECDesignRegisterInfoViewController.h"

#define basicImageHeight   100.f
#define basicTextHeight    64.f

@interface ECDesignerRegisterViewController ()

@property (strong,nonatomic) UIButton *nextStepBtn;

@property (strong,nonatomic) NSArray *nameArray;

@property (strong,nonatomic) ECDesignerRegisterModel *model;

@property (strong,nonatomic) NSMutableArray *jobsArray;

@end

@implementation ECDesignerRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
    [self addBasicData];
    [self requestGetJobs];
}

- (void)createData{
    _jobsArray = [NSMutableArray new];
    _nameArray = @[@[@[@"姓名",@"必填"],
                     @[@"性别",@"选填"],
                     @[@"生日",@"选填"],
                     @[@"现居",@"必填"],
                     @[@"籍贯",@"选填"],
                     @[@"职业",@"必填"],
                     @[@"毕业院校",@"必填"],
                     @[@"从业年限",@"必填"],
                     @[@"收费标准",@"￥/m²"],
                     @[@"擅长风格",@"必填"]],
                   @[@[@"手机",@"必填"],
                     @[@"邮箱",@"选填"],
                     @[@"所属公司",@"选填"]]];
    
    _model = [ECDesignerRegisterModel getNullDesignerRegisterModel];
}

- (void)createUI{
    WEAK_SELF
    if (!_nextStepBtn) {
        _nextStepBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 44.f)];
    }
    [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextStepBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _nextStepBtn.titleLabel.font = FONT_32;
    [_nextStepBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.tableView endEditing:YES];
        //判断必填项是否完整
        if (weakSelf.model.name.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
            return ;
        }
        if (weakSelf.model.province.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请选择现居地"];
            return ;
        }
        if (weakSelf.model.name.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
            return ;
        }
        if (weakSelf.model.profession.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入职业"];
            return ;
        }
        if (weakSelf.model.school.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入毕业院校"];
            return ;
        }
        if (weakSelf.model.obtainyears.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入从业年限"];
            return ;
        }
        if (weakSelf.model.charge.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入收费标准"];
            return ;
        }
        if (weakSelf.model.type.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请选择擅长风格"];
            return ;
        }
        if (weakSelf.model.phone.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
            return ;
        }
        ECDesignRegisterInfoViewController *designerVC = [[ECDesignRegisterInfoViewController alloc] init];
        designerVC.model = weakSelf.model;
        [WEAKSELF_BASENAVI pushViewController:designerVC animated:YES titleLabel:@"设计师注册"];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_nextStepBtn];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStyleGrouped;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestGetDesignerInfo{
    WEAK_SELF
    [ECHTTPServer requestGetDesignersucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            weakSelf.model = [ECDesignerRegisterModel yy_modelWithDictionary:result[@"designerInfo"]];
            [weakSelf addBasicData];
            [weakSelf.tableView reloadData];
            NSLog(@"result : %@",result);
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestGetJobs{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestGetDesignerJobsucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            for (NSDictionary *dict in result[@"designerCareerType"]) {
                CMWorksTypeModel *model = [CMWorksTypeModel yy_modelWithDictionary:dict];
                [weakSelf.jobsArray addObject:model];
            }
            if (!weakSelf.isFirst) {
                [weakSelf requestGetDesignerInfo];
            }else{
                [weakSelf.tableView reloadData];
            }
            NSLog(@"result : %@",result);
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)addBasicData{
    self.model.iconImage = nil;
    self.model.introduceArray = [NSMutableArray new];
    self.model.introduceHeightArray = [NSMutableArray new];
    self.model.introduceFlagArray = [NSMutableArray new];
    self.model.certificateArray = [NSMutableArray new];
    self.model.certificateHeightArray = [NSMutableArray new];
    self.model.certificateFlagArray = [NSMutableArray new];
    
    if (self.model.resume.length == 0) {
        [self.model.introduceArray addObject:@{@"content":@"",@"type":@"0"}];
    }else{
        [self.model.introduceArray addObjectsFromArray:[NSJSONSerialization JSONObjectWithData:[self.model.resume dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil]];
    }
    for (NSDictionary *dict in self.model.introduceArray) {
        if ([dict[@"type"] integerValue] == 0) {
            [self.model.introduceHeightArray addObject:@(basicTextHeight)];
        }else{
            [self.model.introduceHeightArray addObject:@(basicImageHeight)];
        }
        [self.model.introduceFlagArray addObject:@(NO)];
    }
    if (self.model.certificateImgUrls.length != 0) {
        [self.model.certificateArray addObjectsFromArray:[NSJSONSerialization JSONObjectWithData:[self.model.certificateImgUrls dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil]];
    }
    for (NSInteger index = 0; index < self.model.certificateArray.count; index ++) {
        [self.model.certificateHeightArray addObject:@(basicImageHeight)];
        [self.model.certificateFlagArray addObject:@(NO)];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.nameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray *)self.nameArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECDesignerRegisterTableViewCell *cell = [ECDesignerRegisterTableViewCell cellWithTableView:tableView];
    cell.indexpath = indexPath;
    [cell setName:self.nameArray[indexPath.section][indexPath.row][0] WithPlaceholder:self.nameArray[indexPath.section][indexPath.row][1]];
    cell.isInput = YES;
    cell.jobsArray = nil;
    cell.keyboardType = -1;
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    cell.dataStr = self.model.name;
                }
                    break;
                case 1:{
                    cell.keyboardType = 0;
                    cell.dataStr = self.model.sex;
                }
                    break;
                case 2:{
                    cell.keyboardType = 1;
                    cell.dataStr = self.model.birth;
                }
                    break;
                case 3:{
                    cell.isInput = NO;
                    cell.dataStr = [NSString stringWithFormat:@"%@%@",self.model.province,self.model.city];
                }
                    break;
                case 4:{
                    cell.isInput = NO;
                    cell.dataStr = self.model.nativeplace;
                }
                    break;
                case 5:{
                    cell.jobsArray = self.jobsArray;
                    cell.keyboardType = 5;
                    cell.dataStr = self.model.profession;
                }
                    break;
                case 6:{
                    cell.dataStr = self.model.school;
                }
                    break;
                case 7:{
                    cell.keyboardType = 3;
                    cell.dataStr = self.model.obtainyears;
                }
                    break;
                case 8:{
                    cell.keyboardType = 3;
                    cell.dataStr = self.model.charge;
                }
                    break;
                default:{
                    cell.keyboardType = 4;
                    cell.dataStr = self.model.type;
                }
                    break;
            }
        }
            break;
        default:{
            switch (indexPath.row) {
                case 0:{
                    cell.dataStr = self.model.phone;
                    cell.keyboardType = 2;
                }
                    break;
                case 1:{
                    cell.dataStr = self.model.email;
                }
                    break;
                default:{
                    cell.dataStr = self.model.company;
                }
                    break;
            }
        }
            break;
    }    
    WEAK_SELF
    [cell setChangeDataBlock:^(NSIndexPath *indexpath,NSString *text) {
        switch (indexpath.section) {
            case 0:{
                switch (indexpath.row) {
                    case 0:{
                        weakSelf.model.name = text;
                    }
                        break;
                    case 1:{
                        weakSelf.model.sex = text;
                    }
                        break;
                    case 2:{
                        weakSelf.model.birth = text;
                    }
                        break;
                    case 5:{
                        weakSelf.model.profession = text;
                    }
                        break;
                    case 6:{
                        weakSelf.model.school = text;
                    }
                        break;
                    case 7:{
                        weakSelf.model.obtainyears = text;
                    }
                        break;
                    case 8:{
                        weakSelf.model.charge = text;
                    }
                        break;
                    default:{
                        weakSelf.model.type = text;
                    }
                        break;
                }
            }
                break;
            case 1:{
                switch (indexpath.row) {
                    case 0:{
                        weakSelf.model.phone = text;
                    }
                        break;
                    case 1:{
                        weakSelf.model.email = text;
                    }
                        break;
                    case 2:{
                        weakSelf.model.company = text;
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
    }];
    [cell setChangeStyleBlock:^(NSIndexPath *indexpath,NSString *name,NSString *bianma) {
        if (indexpath.section == 0 && indexpath.row == 9) {
            weakSelf.model.type = name;
            weakSelf.model.style = bianma;
        }
    }];
    [cell setChangeJobsBlock:^(NSIndexPath *indexpath,NSString *name,NSString *bianma) {
        if (indexpath.section == 0 && indexpath.row == 5) {
            weakSelf.model.profession = name;
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 8.f : 12.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 3:{
                    ECSelectCityViewController *selectCityVC = [[ECSelectCityViewController alloc] init];
                    [SELF_BASENAVI pushViewController:selectCityVC animated:YES titleLabel:@"选择城市"];
                    [selectCityVC setSelectCityBlock:^(ECCityModel *model, ECCityModel *detailModel) {
                        weakSelf.model.province = model.NAME;
                        weakSelf.model.city = detailModel == nil ? @"" : detailModel.NAME;
                        [weakSelf.tableView reloadData];
                    }];
                }
                    break;
                case 4:{
                    ECSelectCityViewController *selectCityVC = [[ECSelectCityViewController alloc] init];
                    [SELF_BASENAVI pushViewController:selectCityVC animated:YES titleLabel:@"选择城市"];
                    [selectCityVC setSelectCityBlock:^(ECCityModel *model, ECCityModel *detailModel) {
                        if (detailModel == nil) {
                            weakSelf.model.nativeplace = model.NAME;
                        }else{
                            weakSelf.model.nativeplace = [NSString stringWithFormat:@"%@%@",model.NAME,model.NAME];
                        }
                        [weakSelf.tableView reloadData];
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

@end
