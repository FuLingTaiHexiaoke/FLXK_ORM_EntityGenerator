//
//  PsyDBHelper.h
//  PSYLife-NewStructure
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface FLXKDBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (FLXKDBHelper *)shareInstance;

+ (NSString *)dbPath;

//- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;
@end
