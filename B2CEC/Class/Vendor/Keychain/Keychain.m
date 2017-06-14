//
//  Keychain.m
//  ExclusiveTeacher
//
//  Created by Tristan on 15/3/10.
//  Copyright (c) 2015年 Tristan. All rights reserved.
//

#import "Keychain.h"


static NSString *userId = nil;
static NSString *phone = nil;
static NSString *userInfoId = nil;
static NSString *secret = nil;
static NSString *userLoginName = nil;

@implementation Keychain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}


//保存
+ (void)setObject:(NSString*)anObject forKey:(NSString*)aKey {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:aKey];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:anObject] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    
    if ([aKey isEqualToString:EC_USER_ID]) {
        userId = anObject;
    } else if ([aKey isEqualToString:EC_PHONE]) {
        phone = anObject;
    } else if ([aKey isEqualToString:EC_USERINFO_ID]) {
        userInfoId = anObject;
    } else if ([aKey isEqualToString:EC_SECRET]) {
        secret = anObject;
    } else if ([aKey isEqualToString:EC_USER_LOGINNAME]) {
        userLoginName = anObject;
    }
}

//删除
+ (void)removeObjectForKey:(NSString*)aKey {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:aKey];
    SecItemDelete((__bridge_retained  CFDictionaryRef)keychainQuery);
    
    if ([aKey isEqualToString:EC_USER_ID]) {
        userId = nil;
    } else if ([aKey isEqualToString:EC_PHONE]) {
        phone = nil;
    } else if ([aKey isEqualToString:EC_USERINFO_ID]) {
        userInfoId = nil;
    } else if ([aKey isEqualToString:EC_SECRET]) {
        secret = nil;
    } else if ([aKey isEqualToString:EC_USER_LOGINNAME]) {
        userLoginName = nil;
    }
}


//查询
+ (NSString*)objectForKey:(NSString*)aKey {
    
    if ([aKey isEqualToString:EC_USER_ID]) {
        if (userId != nil && userId.length > 0) {
            return userId;
        }
    } else if ([aKey isEqualToString:EC_PHONE]) {
        if (phone != nil && phone.length > 0) {
            return phone;
        }
    } else if ([aKey isEqualToString:EC_USERINFO_ID]) {
        if (userInfoId != nil && userInfoId.length > 0) {
            return userInfoId;
        }
    } else if ([aKey isEqualToString:EC_SECRET]) {
        if (secret != nil && secret.length > 0) {
            return secret;
        }
    } else if ([aKey isEqualToString:EC_USER_LOGINNAME]) {
        if (userLoginName != nil && userLoginName.length > 0) {
            return userLoginName;
        }
    }
    
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:aKey];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer  id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFTypeRef keyData = NULL;
    OSStatus state = SecItemCopyMatching((__bridge_retained  CFDictionaryRef)keychainQuery, &keyData);// == noErr)
    if (state == noErr)
    {
        while (1) {
            @try
            {
                ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer  NSData *)keyData];
                break;
            }
            @catch (NSException *e)
            {
                NSLog(@"Unarchive of %@ failed: %@", aKey, e);
            }
            @finally
            {
                
            }
        }
    }
    if(ret==nil || [ret isEqual:[NSNull null]]){
        ret = @"";
    }
    
    if ([aKey isEqualToString:EC_USER_ID]) {
        userId = ret.copy;
    } else if ([aKey isEqualToString:EC_PHONE]) {
        phone = ret.copy;
    } else if ([aKey isEqualToString:EC_USERINFO_ID]) {
        userInfoId = ret.copy;
    } else if ([aKey isEqualToString:EC_SECRET]) {
        secret = ret.mutableCopy;
    } else if ([aKey isEqualToString:EC_USER_LOGINNAME]) {
        userLoginName = ret.copy;
    }
    
    return ret;
}


@end
