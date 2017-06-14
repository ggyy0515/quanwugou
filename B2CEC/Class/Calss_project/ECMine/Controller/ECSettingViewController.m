//
//  ECSettingViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/1.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECSettingViewController.h"
#import "ECMineTitleTableViewCell.h"
#import "ECSettingSwitchTableViewCell.h"

#import "ECAccountSecurityViewController.h"
#import "ECAdvertisingViewController.h"

@interface ECSettingViewController ()

@property (strong,nonatomic) UIButton *submitBtn;

@end

@implementation ECSettingViewController

- (void)addNotificationObserver{
    ADD_OBSERVER_NOTIFICATION(self, @selector(backtoMain), NOTIFICATION_USER_LOGIN_SUCCESS, nil);
}

- (void)dealloc{
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_SUCCESS, nil);
}

- (void)backtoMain{
    [SELF_BASENAVI popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    [self addNotificationObserver];
    [self createUI];
}

- (void)createUI{
    WEAK_SELF
    
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8.f);
        make.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(52.f * 5);
    }];
    
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
    }
    if (EC_USER_WHETHERLOGIN) {
        [_submitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    }else{
        [_submitBtn setTitle:@"前往登录" forState:UIControlStateNormal];
    }
    [_submitBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = FONT_32;
    _submitBtn.backgroundColor = [UIColor whiteColor];
    _submitBtn.layer.borderColor = LineDefaultsColor.CGColor;
    _submitBtn.layer.borderWidth = 0.5f;
    _submitBtn.layer.cornerRadius = 5.f;
    _submitBtn.layer.masksToBounds = YES;
    [_submitBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
            [weakSelf.submitBtn setTitle:@"前往登录" forState:UIControlStateNormal];
        }];
    }];
    
    [self.view addSubview:_submitBtn];
    
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.tableView.mas_bottom).offset(24.f);
        make.height.mas_equalTo(49.f);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 2:{
            ECSettingSwitchTableViewCell *cell = [ECSettingSwitchTableViewCell cellWithTableView:tableView];
            cell.name = @"消息开关";
            cell.on = YES;
            [cell setSwitchChangeBlock:^(BOOL on) {
                if (on) {
                    [APP_DELEGATE setJPushAlias:[Keychain objectForKey:EC_USER_ID]];
                }else{
                    [APP_DELEGATE setJPushAlias:@""];
                }
            }];
            return cell;
        }
            break;
        default:{
            ECMineTitleTableViewCell *cell = [ECMineTitleTableViewCell cellWithTableView:tableView];
            cell.titleFont = FONT_32;
            switch (indexPath.row) {
                case 0:{
                    [cell setIconImage:nil WithTitle:@"账号与安全"];
                    cell.detailTitle = @"";
                }
                    break;
                case 1:{
                    [cell setIconImage:nil WithTitle:@"版本号"];
                    cell.detailTitle = [[ECHTTPServer loadApiVersion] substringFromIndex:4];
                }
                    break;
                case 3:{
                    [cell setIconImage:nil WithTitle:@"清除缓存"];
                    cell.detailTitle = [NSString stringWithFormat:@"%.2fM",[self filePath]];
                }
                    break;
                case 4:{
                    [cell setIconImage:nil WithTitle:@"关于"];
                    cell.detailTitle = @"";
                }
                    break;
            }
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.row) {
        case 0:{
            if (EC_USER_WHETHERLOGIN) {
                ECAccountSecurityViewController *accountSecurityVC = [[ECAccountSecurityViewController alloc] init];
                [SELF_BASENAVI pushViewController:accountSecurityVC animated:YES titleLabel:@"账号与安全"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"您尚未登录，请先登录"];
            }
        }
            break;
        case 3:{
            AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                 andText:@"是否清除缓存?"
                                                                         andCancelButton:YES
                                                                            forAlertType:AlertInfo
                                                                   withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                       if (blockBtn == blockAlert.defaultButton) {
                                                                           [weakSelf clearFile];
                                                                       }
                                                                   }];
            [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
            alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [alert.defaultButton setTitle:@"清除缓存" forState:UIControlStateNormal];
            alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [alert show];
        }
            break;
        case 4:{
            ECAdvertisingViewController *aboutVC = [[ECAdvertisingViewController alloc] init];
            aboutVC.url =  [NSString stringWithFormat:@"%@%@/common/about", HOST_ADDRESS, [ECHTTPServer loadApiVersion]];
            aboutVC.isHavRightNav = NO;
            [SELF_BASENAVI pushViewController:aboutVC animated:YES titleLabel:@"关于"];
        }
            break;
            
        default:
            break;
    }
}

- (float)filePath{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachPath];
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

- (void)clearFile{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
}

-(void)clearCachSuccess{
    [SVProgressHUD showSuccessWithStatus:@"清除缓存成功"];
    [self.tableView reloadData];
}


@end
