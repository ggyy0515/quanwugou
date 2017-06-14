//
//  ECNoticeChatView.m
//  B2CEC
//
//  Created by Tristan on 2016/12/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNoticeChatView.h"
#import "ECChatListModel.h"
#import "EMConversation.h"
#import "ECChatListCell.h"
#import "ChatViewController.h"

@interface ECNoticeChatView ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    EMChatManagerDelegate
>
{
    dispatch_queue_t refreshQueue;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <ECChatListModel *> *dataSource;

@end

@implementation ECNoticeChatView

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
        [self createUI];
        [self loadConversations];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_tableView registerClass:[ECChatListCell class]
       forCellReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECChatListCell)];
    
}

#pragma mark - Actions

- (void)loadConversations {
    WEAK_SELF
    if (!refreshQueue) {
        refreshQueue = dispatch_queue_create("loadConversations", DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(refreshQueue, ^{
        NSArray <EMConversation *> *conversations = [[EMClient sharedClient].chatManager getAllConversations];        
        if (weakSelf.dataSource.count != conversations.count) {
            NSMutableArray *idList = [NSMutableArray array];
            [conversations enumerateObjectsUsingBlock:^(EMConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [idList addObject:obj.conversationId];
            }];
            
            [ECHTTPServer requestChatListUserInfoWithUserIdArray:idList
                                                         succeed:^(NSURLSessionDataTask *task, id result) {
                                                             if (IS_REQUEST_SUCCEED(result)) {
                                                                 [weakSelf.dataSource removeAllObjects];
                                                                 [result[@"list"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                                     ECChatListModel *model = [ECChatListModel yy_modelWithDictionary:dic];
                                                                     [conversations enumerateObjectsUsingBlock:^(EMConversation * _Nonnull con, NSUInteger idx, BOOL * _Nonnull stop) {
                                                                         if ([con.conversationId isEqualToString:model.firendIds]) {
                                                                             model.conversation = con;
                                                                             *stop = YES;
                                                                         }
                                                                     }];
                                                                     [weakSelf.dataSource addObject:model];
                                                                 }];
                                                                 [weakSelf reSortDateSort];
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [weakSelf.tableView reloadData];
                                                                 });
                                                             } else {
                                                                 EC_SHOW_REQUEST_ERROR_INFO
                                                             }
                                                         }
                                                          failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                              RequestFailure
                                                          }];
        } else {
            [weakSelf.dataSource enumerateObjectsUsingBlock:^(ECChatListModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                [conversations enumerateObjectsUsingBlock:^(EMConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([model.firendIds isEqualToString:obj.conversationId]) {
                        model.conversation = obj;
                        *stop = YES;
                    }
                }];
            }];
            [weakSelf reSortDateSort];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    });
}

- (void)reSortDateSort {
    [_dataSource sortUsingComparator:^NSComparisonResult(ECChatListModel * _Nonnull obj1, ECChatListModel * _Nonnull obj2) {
        EMMessage *message1 = [obj1.conversation latestMessage];
        EMMessage *message2 = [obj2.conversation latestMessage];
        if(message1.timestamp > message2.timestamp) {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }
    }];
}

#pragma mark - UITableView Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECChatListCell)
                                                           forIndexPath:indexPath];
    ECChatListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ECChatListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
    vc.chatListModel = model;
    [SELF_VC_BASEVAV pushViewController:vc animated:YES titleLabel:model.name];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_dataSource removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - EMChatManagerDelegate

- (void)didReceiveMessages:(NSArray *)aMessages {
    ECLog(@"收到环信聊天消息,重新加载聊天列表");
    [self loadConversations];
}

- (void)didUpdateConversationList:(NSArray *)aConversationList {
    [self loadConversations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
