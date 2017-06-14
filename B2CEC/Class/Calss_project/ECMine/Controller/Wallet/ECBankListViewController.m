//
//  ECBankListViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECBankListViewController.h"
#import "ECBankListModel.h"

@interface ECBankListViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ECBankListViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_tableView) {
        _tableView = [UITableView new];
    }
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(UITableViewCell)];
}

#pragma mark - Actions

- (void)loadDataSource {
    SHOWSVP
    [ECHTTPServer requestBankListSucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            [_dataSource removeAllObjects];
            [result[@"info"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                ECBankListModel *model = [ECBankListModel yy_modelWithDictionary:dic];
                [_dataSource addObject:model];
            }];
            [_tableView reloadData];
        } else {
            EC_SHOW_REQUEST_ERROR_INFO
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

#pragma mark - UITableView Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(UITableViewCell)
                                                            forIndexPath:indexPath];
    ECBankListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    [cell.imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                           placeholder:[UIImage imageNamed:@"face1"]];
    cell.textLabel.text = model.name;
    cell.textLabel.font = FONT_32;
    cell.textLabel.textColor = DarkColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ECBankListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    if (_didSelectBank) {
        _didSelectBank(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
