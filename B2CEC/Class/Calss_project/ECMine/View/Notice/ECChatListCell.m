//
//  ECChatListCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECChatListCell.h"
#import "ECChatListModel.h"
#import "EMConversation.h"

@interface ECChatListCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *unReaLdabel;

@end

@implementation ECChatListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_headImageView) {
        _headImageView = [UIImageView new];
    }
    [self.contentView addSubview:_headImageView];
    [_headImageView setImage:[UIImage imageNamed:@"face1"]];
    _headImageView.layer.cornerRadius = 26.f;
    _headImageView.layer.masksToBounds = YES;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(12.f);
        make.size.mas_equalTo(CGSizeMake(52.f, 52.f));
    }];
    
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
    }
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = FONT_24;
    _timeLabel.textColor = LightColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.headImageView.mas_top).offset(6.f);
        make.size.mas_equalTo(CGSizeMake(60.f, weakSelf.timeLabel.font.lineHeight));
    }];
    
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = DarkMoreColor;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.timeLabel);
        make.right.mas_equalTo(weakSelf.timeLabel.mas_left).offset(-12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
    }];
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font = FONT_28;
    _contentLabel.textColor = LightColor;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(8.f);
        make.right.mas_equalTo(weakSelf.timeLabel.mas_left);
        make.height.mas_equalTo(weakSelf.contentLabel.font.lineHeight);
    }];
    
    if (!_unReaLdabel) {
        _unReaLdabel = [UILabel new];
    }
    [self.contentLabel addSubview:_unReaLdabel];
    _unReaLdabel.textAlignment = NSTextAlignmentCenter;
    _unReaLdabel.font = FONT_24;
    _unReaLdabel.textColor = [UIColor whiteColor];
    _unReaLdabel.layer.cornerRadius = 10.f;
    _unReaLdabel.layer.masksToBounds = YES;
    _unReaLdabel.backgroundColor = UIColorFromHexString(@"#EB3A41");
    [_unReaLdabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(weakSelf.headImageView);
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
    }];
}

- (void)setModel:(ECChatListModel *)model {
    _model = model;
    [_headImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.headImage)]
                           placeholder:[UIImage imageNamed:@"face1"]];
    _nameLabel.text = model.name;
    EMMessage *message = model.conversation.latestMessage;
    if (message.body.type == EMMessageBodyTypeText) {
        _contentLabel.text = [(EMTextMessageBody *)message.body text];
    } else if (message.body.type == EMMessageBodyTypeImage) {
        _contentLabel.text = @"[图片]";
    } else if (message.body.type == EMMessageBodyTypeVideo) {
        _contentLabel.text = @"[视频]";
    } else if (message.body.type == EMMessageBodyTypeLocation) {
        _contentLabel.text = @"[位置]";
    } else if (message.body.type == EMMessageBodyTypeVoice) {
        _contentLabel.text = @"[语音]";
    } else if (message.body.type == EMMessageBodyTypeVoice) {
        _contentLabel.text = @"[文件]";
    } else {
        _contentLabel.text = @"[连接请求]";
    }
    ECLog(@"%lld", message.timestamp);
    NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:message.timestamp];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp];
    NSDateFormatter *dateFt = [[NSDateFormatter alloc] init];
    [dateFt setDateFormat:@"MM月dd日"];
    NSString *time = [dateFt stringFromDate:date];
    _timeLabel.text = time;
    if (model.conversation.unreadMessagesCount == 0) {
        _unReaLdabel.hidden = YES;
    }
    _unReaLdabel.text = [NSString stringWithFormat:@"%d", model.conversation.unreadMessagesCount];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
