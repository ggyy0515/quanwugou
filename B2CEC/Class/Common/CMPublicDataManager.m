//
//  CMPublicDataManager.m
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMPublicDataManager.h"

@interface CMPublicDataManager ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *storeCoordinator;

@end

@implementation CMPublicDataManager

@synthesize context = _context;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize storeCoordinator = _storeCoordinator;

singleton_implementation(CMPublicDataManager)

# if DEBUG
- (BOOL)willDealloc {
    return NO;
}
# endif

- (NSManagedObjectContext *)context {
    if (!_context) {
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = self.storeCoordinator;
    }
    return _context;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if (!_storeCoordinator) {
        _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"publicData.data"]];
        NSError *error = nil;
        NSPersistentStore *store = [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                   configuration:nil
                                                                             URL:url
                                                                         options:nil
                                                                           error:&error];
        if (store == nil) {
            [SVProgressHUD showErrorWithStatus:[error description]];
        }
    }
    return _storeCoordinator;
}

- (ECPublicDataModel *)publicDataModel {
    if (!_publicDataModel) {
        [self loadPublicDataFromCache];
    }
    if (!_publicDataModel.imageHeader) {
        [self loadPublicDataFromCache];
    }
//    NSString *imageHeader = _publicDataModel.imageHeader;
//    ECLog(@"%@", imageHeader);
    return _publicDataModel;
}

- (void)loadPublicDataFromCache {
    WEAK_SELF
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ECPublicDataModel"
                                 inManagedObjectContext:self.context];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray <ECPublicDataModel *> *models = [self.context executeFetchRequest:request
                                                                        error:&error];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error.description];
        return;
    }
    if (models.count > 0) {
        _publicDataModel = models.firstObject;
    } else {
        [self loadPublicDataFromNetwork:^{
            [weakSelf loadPublicDataFromCache];
        }];
    }
}

- (void)loadPublicDataFromNetwork:(void(^)())completeBlock {
    WEAK_SELF
    [ECHTTPServer requestBaseDataSucceed:^(NSURLSessionDataTask *task, id result) {
        [self clearCacheSucceed:^(BOOL succeed) {
            if (succeed) {
                NSManagedObject *model = [NSEntityDescription insertNewObjectForEntityForName:@"ECPublicDataModel"
                                                                       inManagedObjectContext:self.context];
                [model setValue:result[@"baseImagePath"] forKey:@"imageHeader"];
                [model setValue:result[@"hotline"] forKey:@"hotline"];
                [model setValue:result[@"hotlineid"] forKey:@"hotlineId"];
                [model setValue:@([[NSDate date] timeIntervalSince1970]) forKey:@"timeStamp"];
                [model setValue:result[@"informationShareUrl"] forKey:@"informationShareUrl"];
                [model setValue:result[@"productShareUrl"] forKey:@"productShareUrl"];
                [model setValue:result[@"caseShareUrl"] forKey:@"caseShareUrl"];
                
                /*还没添加邮费的模型，先忽略
                NSManagedObject *freightInfo = [NSEntityDescription insertNewObjectForEntityForName:@"ECPublicData_freight"
                                                                             inManagedObjectContext:self.context];
                NSString *freight = [result[@"freightInfo"][@"freight"] stringValue];
                [freightInfo setValue:freight forKey:@"freight"];
                [freightInfo setValue:result[@"freightInfo"][@"freightType"] forKey:@"freightType"];
                NSString *fprice = [result[@"freightInfo"][@"price"] stringValue];
                [freightInfo setValue:fprice forKey:@"price"];
                [model setValue:freightInfo forKey:@"freightInfo"];
                */
                 
                NSError *error = nil;
                BOOL succeed = [weakSelf.context save:&error];
                if (!succeed) {
                    [SVProgressHUD showErrorWithStatus:error.description];
                } else {
                    [APP_DELEGATE.logServer insertDetailTableWithInterface:@"参数管理器"
                                                                      type:type_info
                                                                      text:@"网络参数加载成功，本地缓存成功"];
                    if (completeBlock) {
                        completeBlock();
                    }
                }
            }
        }];
    }
                                  failed:^(NSURLSessionDataTask *task, NSError *error) {
                                  }];
}

- (void)clearCacheSucceed:(void(^)(BOOL succeed))compliteBlock {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ECPublicDataModel"
                                 inManagedObjectContext:self.context];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"查询错误"];
        compliteBlock (NO);
        return;
    }
    if (objs.count > 0) {
        NSManagedObject *obj = [objs lastObject];
        [self.context deleteObject:obj];
    }
    if (compliteBlock) {
        compliteBlock (YES);
    }
}



@end
