//
//  ECNewsTypeModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsTypeModel.h"

#define newsTypePath         [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/newsType.plist"]
@implementation ECNewsTypeModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"NAME" : @"NAME",
             @"BIANMA" : @"BIANMA",
             @"ICON" : @"ICON",
             @"ORDER_BY":@"ORDER_BY"
             };
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _NAME = [aDecoder decodeObjectForKey:@"NAME"];
        _BIANMA = [aDecoder decodeObjectForKey:@"BIANMA"];
        _ICON = [aDecoder decodeObjectForKey:@"ICON"];
        _ORDER_BY = [aDecoder decodeObjectForKey:@"ORDER_BY"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.NAME forKey:@"NAME"];
    [aCoder encodeObject:self.BIANMA forKey:@"BIANMA"];
    [aCoder encodeObject:self.ICON forKey:@"ICON"];
    [aCoder encodeObject:self.ORDER_BY forKey:@"ORDER_BY"];
}

- (id)copyWithZone:(NSZone *)zone{
    ECNewsTypeModel *copy = [[[self class] allocWithZone:zone] init];
    copy.NAME = [self.NAME copyWithZone:zone];
    copy.BIANMA = [self.BIANMA copyWithZone:zone];
    copy.ICON = [self.ICON copyWithZone:zone];
    copy.ORDER_BY = [self.ORDER_BY copyWithZone:zone];
    return copy;
}


+ (void)saveNewsType:(NSArray *)array{
    [NSKeyedArchiver archiveRootObject:array toFile:newsTypePath];
}

+ (NSMutableArray *)loadNewsType{
    NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithFile:newsTypePath];
    if (oldArray.count == 0 || oldArray == nil) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray *array1 = [NSMutableArray new];
    NSMutableArray *array2 = [NSMutableArray new];
    [array1 addObjectsFromArray:oldArray[0]];
    [array2 addObjectsFromArray:oldArray[1]];
    [array addObject:array1];
    [array addObject:array2];
    return array;
}
@end
