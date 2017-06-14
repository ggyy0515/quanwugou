//
//  ECOrderDetailStateCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailStateCell.h"
#import "ECOrderListModel.h"

@interface ECOrderDetailStateCell ()

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation ECOrderDetailStateCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    /*
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
    }
    [self.contentView addSubview:_stateLabel];
    _stateLabel.font = [UIFont systemFontOfSize:22.f];
    _stateLabel.textColor = [UIColor whiteColor];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView).offset(16.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.height.mas_equalTo(weakSelf.stateLabel.font.lineHeight);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-120.f);
    }];
     */
}

- (void)setModel:(ECOrderListModel *)model {
    _model = model;
//    _stateLabel.text = [self getOrderStateTitleWithMainStateString:model.state subStateString:model.subState];
    NSString *name = [self getOrderStateTitleWithMainStateString:model.state subStateString:model.subState];
    [_imageView setImage:[UIImage imageNamed:name]];
}

- (NSString *)getOrderStateTitleWithMainStateString:(NSString *)mainStateString subStateString:(NSString *)subStateString {
    if ([mainStateString isEqualToString:@"For_the_payment"]) {
        if ([subStateString isEqualToString:@"daijiedan"]) {
            return @"待接单";
        }
        else if ([subStateString isEqualToString:@"gongchangjiedan"]) {
            //工厂接单
            return @"生产中";
        }
        else if ([subStateString isEqualToString:@"shengchanwancheng"]) {
            return @"生产完成";
        }
        else if ([subStateString isEqualToString:@"daifuweikuan"]) {
            return @"待付尾款";
        }
        else {
            return @"待付款";
        }
    }
    
    else if ([mainStateString isEqualToString:@"To_send_the_goods"]) {
        return @"待发货";
    }
    else if ([mainStateString isEqualToString:@"For_the_goods"]) {
        return @"待收货";
    }
    else if ([mainStateString isEqualToString:@"For_the_Comment"]) {
        return @"待评价";
    }
    else if ([mainStateString isEqualToString:@"Return"]) {
        if ([subStateString isEqualToString:@"In_Return"]) {
            return @"退货中";
        }
        else {
            return @"已退货";
        }
    }
    else if ([mainStateString isEqualToString:@"Complete"]) {
        return @"交易完成";
    }
    else {
        return @"交易取消";
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
