//
//  ECPostLogsImageListTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPostLogsImageListTableViewCell.h"

@interface ECPostLogsImageListTableViewCell()

@property (nonatomic, strong) SHImageListView *imageListView;

@end

@implementation ECPostLogsImageListTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECPostLogsImageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPostLogsImageListTableViewCell)];
    if (cell == nil) {
        cell = [[ECPostLogsImageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPostLogsImageListTableViewCell)];
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
    WEAK_SELF
    
    if (!_imageListView) {
        _imageListView = [[SHImageListView alloc] initWithFrame:CGRectZero];
    }
    _imageListView.isAdd = YES;
    _imageListView.itemSize = CGSizeMake(60.f, 60.f);
    [_imageListView setImageClickBlock:^(NSInteger index) {
        if (weakSelf.imageClickBlock) {
            weakSelf.imageClickBlock(index);
        }
    }];
    [_imageListView setAddImageClickBlock:^{
        if (weakSelf.addImageClickBlock) {
            weakSelf.addImageClickBlock();
        }
    }];
    
    [self.contentView addSubview:_imageListView];
    
    [_imageListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12.f);
        make.right.bottom.mas_equalTo(-12.f);
    }];
}

- (void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    _imageListView.itemSize = itemSize;
}

- (void)setAddImage:(NSString *)addImage{
    _addImage = addImage;
    _imageListView.addImage = addImage;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    NSMutableArray *images = [NSMutableArray new];
    for (id data in imageArray) {
        if ([data isKindOfClass:[NSString class]]) {
            [images addObject:IMAGEURL(data)];
        }else{
            [images addObject:data];
        }
    }
    _imageListView.imageArray = images;
}

@end
