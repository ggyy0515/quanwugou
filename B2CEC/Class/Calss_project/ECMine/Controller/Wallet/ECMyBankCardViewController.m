//
//  ECMyBankCardViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMyBankCardViewController.h"
#import "ECBankCardListModel.h"
#import "ECBankCardListCell.h"
#import "ECAddCardViewController.h"

@interface ECMyBankCardViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    SWTableViewCellDelegate
>

@property (nonatomic, assign) MyBankCardType listType;
@property (nonatomic, strong) NSMutableArray <ECBankCardListModel *> *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation ECMyBankCardViewController

#pragma mark - Life Cycle

- (instancetype)initWithMyBankCardType:(MyBankCardType)type {
    if (self = [super init]) {
        _listType = type;
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_OBSERVER_NOTIFICATION(self, @selector(loadDataSourceWithoutSvp), NOTIFICATION_NAME_ADD_BANK_CARD, nil);
    [self createUI];
    [self loadDataSource];
}

- (void)dealloc {
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_ADD_BANK_CARD, nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22.f, 22.f)];
    }
    [_addBtn setImage:[UIImage imageNamed:@"navdown_more"] forState:UIControlStateNormal];
    [_addBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf gotoAddCardVC];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_addBtn];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _tableView.backgroundColor = BaseColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 0.f;
    [_tableView registerClass:[ECBankCardListCell class]
       forCellReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECBankCardListCell)];
}

#pragma mark - Actions

- (void)loadDataSource {
    SHOWSVP
    [self loadDataSourceWithoutSvp];
}

- (void)loadDataSourceWithoutSvp {
    [ECHTTPServer requestMyWalletInfoWithUserId:[Keychain objectForKey:EC_USER_ID]
                                        succeed:^(NSURLSessionDataTask *task, id result) {
                                            if (IS_REQUEST_SUCCEED(result)) {
                                                DISMISSSVP
                                                [_dataSource removeAllObjects];
                                                [result[@"banks"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                    ECBankCardListModel *bankModel = [ECBankCardListModel yy_modelWithDictionary:dic];
                                                    [_dataSource addObject:bankModel];
                                                }];
                                                [_tableView reloadData];
                                            } else {
                                                EC_SHOW_REQUEST_ERROR_INFO
                                            }
                                        }
                                         failed:^(NSURLSessionDataTask *task, NSError *error) {
                                             RequestFailure
                                         }];
}



- (void)gotoAddCardVC {
    ECAddCardViewController *vc = [[ECAddCardViewController alloc] init];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"绑定银行卡"];
}

#pragma mark - UITableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    header.backgroundColor = BaseColor;
    CGFloat height = 10.f;
    if (section == 0) {
        height = 12.f;
    }
    header.frame = CGRectMake(0, 0, SCREENWIDTH, height);
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECBankCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECBankCardListCell)
                                                               forIndexPath:indexPath];
    cell.delegate = self;
    ECBankCardListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.section];
    cell.model = model;
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    WEAK_SELF
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    ECBankCardListModel *model = [_dataSource objectAtIndexWithCheck:cellIndexPath.section];
    NSString *shortNum = @"";
    if (model.bankNo.length >= 4) {
        shortNum = [model.bankNo substringWithRange:NSMakeRange(model.bankNo.length - 4, 4)];
    }
    NSString *tips = [NSString stringWithFormat:@"确认删除尾号%@的银行卡?", shortNum];
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                         andText:tips
                                                                 andCancelButton:YES
                                                                    forAlertType:AlertInfo
                                                           withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                               if (blockBtn == blockAlert.defaultButton) {
                                                                   SHOWSVP
                                                                   [ECHTTPServer requestDeleteBankCardWithCardId:model.bankId
                                                                                                         succeed:^(NSURLSessionDataTask *task, id result) {
                                                                                                             if (IS_REQUEST_SUCCEED(result)) {
                                                                                                                 RequestSuccess(result);
                                                                                                                 [weakSelf.dataSource removeObjectAtIndex:cellIndexPath.section];
                                                                                                                 [weakSelf.tableView reloadData];
                                                                                                             } else {
                                                                                                                 EC_SHOW_REQUEST_ERROR_INFO
                                                                                                             }
                                                                                                         }
                                                                                                          failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                                              RequestFailure
                                                                                                          }];
                                                               }
                                                           }];
    [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
    alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert.defaultButton setTitle:@"删除" forState:UIControlStateNormal];
    alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert show];
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_listType == MyBankCardType_select && _didSelectCard) {
        ECBankCardListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.section];
        _didSelectCard(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
