//
//  SHVideoPlayerView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHVideoPlayerView : UIView

@property (strong,nonatomic) NSString *videoUrl;

@property (copy,nonatomic) void (^fullScreenClick)(BOOL isFull);

- (void)stopPlayer;

@end
