//
//  ECPublicDataModel+CoreDataProperties.m
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "ECPublicDataModel+CoreDataProperties.h"

@implementation ECPublicDataModel (CoreDataProperties)

+ (NSFetchRequest<ECPublicDataModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ECPublicDataModel"];
}

@dynamic hotline;
@dynamic hotlineId;
@dynamic imageHeader;
@dynamic timeStamp;
@dynamic informationShareUrl;
@dynamic productShareUrl;
@dynamic caseShareUrl;


@end
