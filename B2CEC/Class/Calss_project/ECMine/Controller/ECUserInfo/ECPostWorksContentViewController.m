//
//  ECPostWorksContentViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPostWorksContentViewController.h"
#import "ECDesignerRegisterAddImageTableViewCell.h"
#import "ECDesignerRegisterJobCourseTableViewCell.h"
#import "ECDesignerRegisterImageTableViewCell.h"

#define basicImageHeight   100.f
#define basicTextHeight    64.f

@interface ECPostWorksContentViewController ()

@property (strong,nonatomic) UIButton *submitBtn;

@property (strong,nonatomic) UITextView *getHeightTextView;

@property (strong,nonatomic) ZLPhotoActionSheet *actionSheet;

@property (assign,nonatomic) BOOL isTop;

@end

@implementation ECPostWorksContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}

- (void)createData{
    self.isTop = NO;
    self.view.backgroundColor = BaseColor;
}

- (void)createUI{
    WEAK_SELF
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_submitBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = FONT_32;
    [_submitBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.tableView endEditing:YES];
        if (weakSelf.model.contentArray.count == 1 && ((NSString *)(weakSelf.model.contentArray.firstObject[@"content"])).length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入正文"];
            return ;
        }
        if ([[USERDEFAULT objectForKey:EC_USER_STATUS] isEqualToString:@"2"]) {//如果是设计师
            AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                                 andText:@"是否同时申请推荐到首页？"
                                                                         andCancelButton:YES
                                                                            forAlertType:AlertInfo
                                                                   withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                                       weakSelf.isTop = blockBtn == blockAlert.defaultButton;
                                                                       [weakSelf beginRequest];
                                                                   }];
            [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
            alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [alert.defaultButton setTitle:@"推荐到首页" forState:UIControlStateNormal];
            alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [alert show];
        }else{
            [weakSelf beginRequest];
        }
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_submitBtn];
    
    if (!_getHeightTextView) {
        _getHeightTextView = [UITextView new];
    }
    _getHeightTextView.font = FONT_32;
    _getHeightTextView.hidden = YES;
    [self.view addSubview:_getHeightTextView];
    [_getHeightTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(12.f);
    }];
}

- (void)beginRequest{
    SHOWSVP
    WEAK_SELF
    [self requestUploadImageListSucceed:^(NSArray *pathArr) {
        //头像图片
        NSInteger index = 0;
        if (weakSelf.model.coverImage != nil) {
            index ++;
            weakSelf.model.cover = pathArr[0][@"path"];
        }
        //分离个人介绍图片与文字
        NSMutableArray *introArray = [NSMutableArray new];
        for (NSInteger page = 0; page < weakSelf.model.contentArray.count; page ++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:weakSelf.model.contentArray[page]];
            if ([dict[@"content"] isKindOfClass:[NSString class]]) {
                [introArray addObject:dict];
            }else{
                [dict setValue:pathArr[index][@"path"] forKey:@"content"];
                [introArray addObject:dict];
                index ++;
            }
        }
        weakSelf.model.content = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:introArray options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        //先发起上传文件请求
        [weakSelf requestSubmitWorks];
    }];
}

- (void)requestUploadImageListSucceed:(void(^)(NSArray *pathArr))succeed{
    NSMutableArray *dataArray = [NSMutableArray new];
    //加入头像图片
    if (self.model.coverImage != nil) {
        [dataArray addObject:[CMPublicMethod getFitImageWithImage:self.model.coverImage]];
    }
    //加入个人介绍图片
    for (NSDictionary *dict in self.model.contentArray) {
        if ([dict[@"type"] integerValue] == 1 && [dict[@"content"] isKindOfClass:[UIImage class]]) {
            [dataArray addObject:[CMPublicMethod getFitImageWithImage:dict[@"content"]]];
        }
    }
    //判断图片数组是否为空，如果为空则直接返回
    if (dataArray.count == 0) {
        succeed(dataArray);
        return;
    }
    //发起上传请求
    [ECHTTPServer requestUploadFileWithFilesData:dataArray succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            succeed(result[@"results"]);
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestSubmitWorks{
    WEAK_SELF
    [ECHTTPServer requestSubmitWorksWithUserID:self.model.userid
                                     WithStyle:self.model.style
                                      WithType:self.model.type
                                 WithHouseType:self.model.housetype
                                     WithTitle:self.model.title
                                     WithCover:self.model.cover
                                   WithContent:self.model.content
                                       WithTop:self.isTop
                                       succeed:^(NSURLSessionDataTask *task, id result) {
                                       if (IS_REQUEST_SUCCEED(result)) {
                                           [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                                           if (weakSelf.model.style == nil ) {
                                               POST_NOTIFICATION(NOTIFICATION_POSTWORKS_LOGS_ARTICLE, @{@"type":@"0"});
                                           }else{
                                               POST_NOTIFICATION(NOTIFICATION_POSTWORKS_LOGS_ARTICLE, @{@"type":@"1"});
                                           }
                                           [WEAKSELF_BASENAVI popToViewController:WEAKSELF_BASENAVI.viewControllers[WEAKSELF_BASENAVI.viewControllers.count - 3] animated:YES];
                                       }else{
                                           RequestError
                                       }
                                   } failed:^(NSURLSessionDataTask *task, NSError *error) {
                                       RequestFailure
                                   }];
}

- (CGFloat)getHeightWithContent:(NSString *)content{
    _getHeightTextView.text = content;
    CGFloat height = fmaxf([_getHeightTextView sizeThatFits:CGSizeMake((SCREENWIDTH - 24.f), MAXFLOAT)].height, 64.f);
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.contentArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    if (indexPath.row == self.model.contentArray.count) {
        ECDesignerRegisterAddImageTableViewCell *cell = [ECDesignerRegisterAddImageTableViewCell cellWithTableView:tableView];
        [cell setAddImageBlock:^{
            weakSelf.actionSheet = [[ZLPhotoActionSheet alloc] init];
            weakSelf.actionSheet.maxSelectCount = 99;
            [weakSelf.actionSheet showWithSender:weakSelf animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                //先判断数组上一个元素是不是空字符串
                NSDictionary *dict = weakSelf.model.contentArray.lastObject;
                if (weakSelf.model.contentArray.count != 1 &&
                    [dict[@"type"] integerValue] == 0 &&
                    ((NSString *)dict[@"content"]).length == 0) {
                    [weakSelf.model.contentArray removeLastObject];
                    [weakSelf.model.contentHeightArray removeLastObject];
                    [weakSelf.model.contentFlagArray removeLastObject];
                }
                
                for (UIImage *image in selectPhotos) {
                    [weakSelf.model.contentArray addObject:@{@"content":image,@"type":@"1"}];
                    [weakSelf.model.contentHeightArray addObject:@(basicImageHeight)];
                    [weakSelf.model.contentFlagArray addObject:@(NO)];
                }
                [weakSelf.model.contentArray addObject:@{@"content":@"",@"type":@"0"}];
                [weakSelf.model.contentHeightArray addObject:@(basicTextHeight)];
                [weakSelf.model.contentFlagArray addObject:@(NO)];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.model.contentArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }];
        }];
        return cell;
    }else{
        NSDictionary *dict = self.model.contentArray[indexPath.row];
        if ([dict[@"type"] integerValue] == 0) {
            ECDesignerRegisterJobCourseTableViewCell *cell = [ECDesignerRegisterJobCourseTableViewCell cellWithTableView:tableView];
            cell.placepolder = @"编辑正文";
            cell.content = dict[@"content"];
            [cell setCourseTextChangeBlock:^(NSString *course) {
                NSDictionary *replaceDict = @{@"content":course,@"type":@"0"};
                [weakSelf.model.contentArray replaceObjectAtIndex:(indexPath.row) withObject:replaceDict];
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView endUpdates];
            }];
            return cell;
        }else{
            ECDesignerRegisterImageTableViewCell *cell = [ECDesignerRegisterImageTableViewCell cellWithTableView:tableView];
            [cell setGetImageSizeBlock:^(NSInteger row, CGFloat height) {
                height = height == 0.f ? basicImageHeight : height;
                [weakSelf.model.contentHeightArray replaceObjectAtIndex:(row) withObject:@(height)];
                [weakSelf.model.contentFlagArray replaceObjectAtIndex:(row) withObject:@(YES)];
                [weakSelf.tableView reloadData];
            }];
            [cell setDeleteImageBlock:^(NSInteger row) {
                [weakSelf.model.contentArray removeObjectAtIndex:row];
                [weakSelf.model.contentHeightArray removeObjectAtIndex:row];
                [weakSelf.model.contentFlagArray removeObjectAtIndex:row];
                //判断最后当前删除的下一位是否是空白输入栏，并且上一位是否文字输入栏，如果是，则删除
                NSDictionary *dict1 = [weakSelf.model.contentArray objectAtIndexWithCheck:row];
                NSDictionary *dict2 = [weakSelf.model.contentArray objectAtIndexWithCheck:row - 1];
                if ([dict1[@"type"] integerValue] == 0 &&
                    [dict2[@"type"] integerValue] == 0 &&
                    ((NSString *)dict1[@"content"]).length == 0) {
                    [weakSelf.model.contentArray removeObjectAtIndex:row];
                    [weakSelf.model.contentHeightArray removeObjectAtIndex:row];
                    [weakSelf.model.contentFlagArray removeObjectAtIndex:row];
                }
                [weakSelf.tableView reloadData];
            }];
            cell.indexpath = indexPath;
            cell.isFlag = [self.model.contentFlagArray[indexPath.row] boolValue];
            if ([dict[@"content"] isKindOfClass:[NSString class]]) {
                cell.iconImageUrl = dict[@"content"];
            }else{
                cell.iconImage = (UIImage *)dict[@"content"];
            }
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.model.contentArray.count) {
        return 84.f;
    }else{
        NSDictionary *dict = self.model.contentArray[indexPath.row];
        if ([dict[@"type"] integerValue] == 0) {
            return 24.f + [self getHeightWithContent:dict[@"content"]];
        }else{
            return [self.model.contentHeightArray[indexPath.row] floatValue] + 24.f;
        }
    }
}

@end
