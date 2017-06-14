//
//  Keychain.h
//  ExclusiveTeacher
//
//  Created by Tristan on 15/3/10.
//  Copyright (c) 2015年 Tristan. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
@interface Keychain : NSObject
/**
 *  获取对象
 *
 *  @param aKey key
 *
 *  @return
 */
+ (NSString*)objectForKey:(NSString*)aKey;
/**
 *  删除对象
 *
 *  @param aKey key
 */
+ (void)removeObjectForKey:(NSString*)aKey;
/**
 *  存储对象
 *
 *  @param anObject obj
 *  @param aKey     key
 */
+ (void)setObject:(NSString*)anObject forKey:(NSString*)aKey;

@end
