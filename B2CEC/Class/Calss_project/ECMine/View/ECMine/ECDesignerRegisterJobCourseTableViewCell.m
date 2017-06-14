//
//  ECDesignerRegisterJobCourseTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/30.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerRegisterJobCourseTableViewCell.h"

@interface ECDesignerRegisterJobCourseTableViewCell()<
UITextViewDelegate
>

@property (strong,nonatomic) SHTextView *courseTextView;

@end

@implementation ECDesignerRegisterJobCourseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerRegisterJobCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterJobCourseTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerRegisterJobCourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterJobCourseTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    if (!_courseTextView) {
        _courseTextView = [SHTextView new];
    }
    _courseTextView.placeholderColor = LightPlaceholderColor;
    _courseTextView.textColor = DarkMoreColor;
    _courseTextView.font = FONT_32;
    _courseTextView.scrollEnabled = NO;
    _courseTextView.delegate = self;
    
    [self.contentView addSubview:_courseTextView];
    
    [_courseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12.f);
        make.right.bottom.mas_equalTo(-12.f);
    }];
}

- (void)setPlacepolder:(NSString *)placepolder{
    _placepolder = placepolder;
    _courseTextView.placeholder = placepolder;
}

- (void)setContent:(NSString *)content{
    _content = content;
    _courseTextView.text = content;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.courseTextChangeBlock) {
        self.courseTextChangeBlock(textView.text);
    }
}

@end
