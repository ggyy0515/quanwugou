//
//  NSArray+Check.m
//  TrCommerce
//
//  Created by Tristan on 15/11/3.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "NSArray+Check.h"

@implementation NSArray (Check)

/**
 *  通过数组索引获取对象，同时会规避数组为空、索引越界等异常。
 *
 *  @param index 数组索引
 *
 *  @return 返回数组索引位置处的对象。
 */
- (id)objectAtIndexWithCheck:(NSUInteger)index
{
    if ([self count] <= index) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    
    return value;
}

/*!
 *  通过需要删除的下标数组删除数组元素
 *
 *  @param array 需要删除的下标数组
 *
 *  @return 新数组
 */
- (NSArray *)removeObjectAtIndexArray:(NSArray *)array{
    if (self.count == 0 || (array.count > self.count)) {
        return self;
    }
    NSArray *sortArray = [array sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *newArray = [NSMutableArray new];
    [newArray addObjectsFromArray:self];
    for (NSInteger i = sortArray.count; i > 0; i --) {
        [newArray removeObjectAtIndex:[sortArray[i - 1] integerValue] - 1];
    }
    return newArray;
}

@end
