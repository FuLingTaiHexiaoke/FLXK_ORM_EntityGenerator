////
////  TestEntity.m
////  Psy-TeachersTerminal
////
////  Created by apple on 2016/6/27.
////  Copyright © 2016年 apple. All rights reserved.
////
//
#import "EmotionRecentItems.h"
#import "FLXKDBHelper.h"
//
@implementation EmotionRecentItems

//createTable
+ (BOOL)createTable
{
    __block BOOL res = YES;
    FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];
    [FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db tableExists:@"emotionrecentitems"])
        {
            return ;
        }
        NSString *tableName = NSStringFromClass(self.class);
        NSString *columeAndType = @"id INTEGER,emotionItemName TEXT,emotionItemSmallImageUrl TEXT,emotionItemNormalImageUrl TEXT,emotionItemGifImageUrl TEXT,emotionItemImageType INTEGER,groupId INTEGER";
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
        if (![db executeUpdate:sql]) {
            res = NO;
            *rollback = YES;
        };
    }];
    return res;
};
//dropTable
+ (BOOL)dropTable
{
    __block BOOL res = YES;
    FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];
    [FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db tableExists:@"emotionrecentitems"])
        {
            NSString *tableName = NSStringFromClass(self.class);
            NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF  EXISTS %@;",tableName];
            if (![db executeUpdate:sql]) {
                res = NO;
                *rollback = YES;
            };
        }
    }];
    return res;
};
//selectAll
+ (NSArray<EmotionRecentItems*> *)selectAll
{
    FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];
    NSMutableArray *entitiyResults = [NSMutableArray array];
    [FLXKDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM EmotionRecentItems"];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            EmotionRecentItems *entity = [[EmotionRecentItems alloc] init];
            entity.id=[resultSet longLongIntForColumn:@"id"];
            entity.emotionItemName=[resultSet stringForColumn:@"emotionItemName"];
            entity.emotionItemSmallImageUrl=[resultSet stringForColumn:@"emotionItemSmallImageUrl"];
            entity.emotionItemNormalImageUrl=[resultSet stringForColumn:@"emotionItemNormalImageUrl"];
            entity.emotionItemGifImageUrl=[resultSet stringForColumn:@"emotionItemGifImageUrl"];
            entity.emotionItemImageType=[resultSet longForColumn:@"emotionItemImageType"];
            entity.groupId=[resultSet longLongIntForColumn:@"groupId"];
            [entitiyResults addObject:entity];
            FMDBRelease(entity);
        }
    }];
    return entitiyResults;
};
//selectByCriteria
+ (NSArray<EmotionRecentItems*> *)selectByCriteria:(NSString *)criteria
{
    FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];
    NSMutableArray *entitiyResults = [NSMutableArray array];
    [FLXKDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM EmotionRecentItems %@",criteria];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            EmotionRecentItems *entity = [[EmotionRecentItems alloc] init];
            entity.id=[resultSet longLongIntForColumn:@"id"];
            entity.emotionItemName=[resultSet stringForColumn:@"emotionItemName"];
            entity.emotionItemSmallImageUrl=[resultSet stringForColumn:@"emotionItemSmallImageUrl"];
            entity.emotionItemNormalImageUrl=[resultSet stringForColumn:@"emotionItemNormalImageUrl"];
            entity.emotionItemGifImageUrl=[resultSet stringForColumn:@"emotionItemGifImageUrl"];
            entity.emotionItemImageType=[resultSet longLongIntForColumn:@"emotionItemImageType"];
            entity.groupId=[resultSet longLongIntForColumn:@"groupId"];
            [entitiyResults addObject:entity];
            FMDBRelease(entity);
        }
    }];
    return entitiyResults;
};
//insertWithObject:
+ (BOOL)insertWithObject:(EmotionRecentItems*)obj success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
{
    __block BOOL isRollBack = NO;
    __block BOOL result = NO;
    //NSString *keyString =@"id,emotionItemName,emotionItemSmallImageUrl,emotionItemNormalImageUrl,emotionItemGifImageUrl,emotionItemImageType,groupId";
    //NSString *valueString =@"?,?,?,?,?,?,?";
    //NSString *insertValues =@"@(obj.id),obj.emotionItemName,obj.emotionItemSmallImageUrl,obj.emotionItemNormalImageUrl,obj.emotionItemGifImageUrl,@(obj.emotionItemImageType),@(obj.groupId)";
    
    
    
    FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];
    [FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            NSString *sql = @"INSERT OR REPLACE INTO EmotionRecentItems(id,emotionItemName,emotionItemSmallImageUrl,emotionItemNormalImageUrl,emotionItemGifImageUrl,emotionItemImageType,groupId) VALUES (?,?,?,?,?,?,?)";
            BOOL result = [db executeUpdate:sql,@(obj.id),obj.emotionItemName,obj.emotionItemSmallImageUrl,obj.emotionItemNormalImageUrl,obj.emotionItemGifImageUrl,@(obj.emotionItemImageType),@(obj.groupId)];
            if (!result)
            {
                *rollback = YES;
                isRollBack = YES;
            }
        }
        @catch (NSException *exception) {
            if(failure)
            {
                failure(@"插入数据失败");
            }
        }
        @finally {
            if (isRollBack)
            {
                NSLog(@"insert to database failure content");
                if(failure)
                {
                    failure(@"插入数据失败");
                }
                result= NO;
            }
            else
            {
                result= YES;
                if(success)
                {
                    success();
                }
            }
        }
    }];
    return result;
}
//insertWithObject:
+ (BOOL)insertWithObjects:(NSArray<EmotionRecentItems*>*)objs success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
{
    __block BOOL isRollBack = NO;
    __block BOOL result = NO;
    //NSString *keyString =@"id,emotionItemName,emotionItemSmallImageUrl,emotionItemNormalImageUrl,emotionItemGifImageUrl,emotionItemImageType,groupId";
    //NSString *valueString =@"?,?,?,?,?,?,?";
    //NSString *insertValues =@"@(entity.id),entity.emotionItemName,entity.emotionItemSmallImageUrl,entity.emotionItemNormalImageUrl,entity.emotionItemGifImageUrl,@(entity.emotionItemImageType),@(entity.groupId)";
    
    
    
    FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];
    [FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            EmotionRecentItems* entity = (EmotionRecentItems*)obj;
            
            @try {
                NSString *sql = @"INSERT OR REPLACE INTO EmotionRecentItems(id,emotionItemName,emotionItemSmallImageUrl,emotionItemNormalImageUrl,emotionItemGifImageUrl,emotionItemImageType,groupId) VALUES (?,?,?,?,?,?,?)";
                BOOL result = [db executeUpdate:sql,@(entity.id),entity.emotionItemName,entity.emotionItemSmallImageUrl,entity.emotionItemNormalImageUrl,entity.emotionItemGifImageUrl,@(entity.emotionItemImageType),@(entity.groupId)];
                if (!result)
                {
                    *rollback = YES;
                    isRollBack = YES;
                }
            }
            @catch (NSException *exception) {
                if(failure)
                {
                    failure(@"插入数据失败");
                }
            }
            @finally {
                if (isRollBack)
                {
                    NSLog(@"insert to database failure content");
                    if(failure)
                    {
                        failure(@"插入数据失败");
                    }
                    result= NO;
                }
                else
                {
                    result= YES;
                    if(success)
                    {
                        success();
                    }
                }
            }
        }];
    }];
    return result;
}
//insertWithObject:
+ (BOOL)updateObject:(EmotionRecentItems*)obj withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
{
    __block BOOL isRollBack = NO;
    __block BOOL result = NO;
    //NSString *keyString =@" id= ? , emotionItemName= ? , emotionItemSmallImageUrl= ? , emotionItemNormalImageUrl= ? , emotionItemGifImageUrl= ? , emotionItemImageType= ? , groupId= ? ";
    //NSString *insertValues =@"@(entity.id),entity.emotionItemName,entity.emotionItemSmallImageUrl,entity.emotionItemNormalImageUrl,entity.emotionItemGifImageUrl,@(entity.emotionItemImageType),@(entity.groupId)";
    
    
    
    FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];
    [FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        EmotionRecentItems* entity = (EmotionRecentItems*)obj;
        
        @try {
            NSString *tempSql = [NSString stringWithFormat:@"UPDATE EmotionRecentItems set  id= ? , emotionItemName= ? , emotionItemSmallImageUrl= ? , emotionItemNormalImageUrl= ? , emotionItemGifImageUrl= ? , emotionItemImageType= ? , groupId= ? "];
            NSString *sql = [NSString stringWithFormat:@"%@ %@",tempSql,where];
            BOOL result = [db executeUpdate:sql,@(entity.id),entity.emotionItemName,entity.emotionItemSmallImageUrl,entity.emotionItemNormalImageUrl,entity.emotionItemGifImageUrl,@(entity.emotionItemImageType),@(entity.groupId)];
            if (!result)
            {
                *rollback = YES;
                isRollBack = YES;
            }
        }
        @catch (NSException *exception) {
            if(failure)
            {
                failure(@"插入数据失败");
            }
        }
        @finally {
            if (isRollBack)
            {
                NSLog(@"insert to database failure content");
                if(failure)
                {
                    failure(@"插入数据失败");
                }
                result= NO;
            }
            else
            {
                result= YES;
                if(success)
                {
                    success();
                }
            }
        }
    }];
    return result;
}
//insertWithObject:
+ (BOOL)updateObjects:(NSArray<EmotionRecentItems*>*)objs withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
{
    __block BOOL isRollBack = NO;
    __block BOOL result = NO;
    //NSString *keyString =@" id= ? , emotionItemName= ? , emotionItemSmallImageUrl= ? , emotionItemNormalImageUrl= ? , emotionItemGifImageUrl= ? , emotionItemImageType= ? , groupId= ? ";
    //NSString *insertValues =@"@(entity.id),entity.emotionItemName,entity.emotionItemSmallImageUrl,entity.emotionItemNormalImageUrl,entity.emotionItemGifImageUrl,@(entity.emotionItemImageType),@(entity.groupId)";
    
    
    
    FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];
    [FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            EmotionRecentItems* entity = (EmotionRecentItems*)obj;
            
            @try {
                NSString *tempSql = [NSString stringWithFormat:@"UPDATE EmotionRecentItems set  id= ? , emotionItemName= ? , emotionItemSmallImageUrl= ? , emotionItemNormalImageUrl= ? , emotionItemGifImageUrl= ? , emotionItemImageType= ? , groupId= ? "];
                NSString *sql = [NSString stringWithFormat:@"%@ %@",tempSql,where];
                BOOL result = [db executeUpdate:sql,@(entity.id),entity.emotionItemName,entity.emotionItemSmallImageUrl,entity.emotionItemNormalImageUrl,entity.emotionItemGifImageUrl,@(entity.emotionItemImageType),@(entity.groupId)];
                if (!result)
                {
                    *rollback = YES;
                    isRollBack = YES;
                }
            }
            @catch (NSException *exception) {
                if(failure)
                {
                    failure(@"插入数据失败");
                }
            }
            @finally {
                if (isRollBack)
                {
                    NSLog(@"insert to database failure content");
                    if(failure)
                    {
                        failure(@"插入数据失败");
                    }
                    result= NO;
                }
                else
                {
                    result= YES;
                    if(success)
                    {
                        success();
                    }
                }
            }
        }];
    }];
    return result;
}
//insertWithObject:
+ (BOOL)deleteWithWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure 
{
    __block BOOL isRollBack = NO;
    __block BOOL result = NO;
    FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];
    [FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        
        @try {
            NSString *tableName = NSStringFromClass(self.class);
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@   %@  ",tableName,where];
            BOOL result = [db executeUpdate:sql];
            if (!result)
            {
                isRollBack = YES;
            }
        }
        @catch (NSException *exception) {
            if(failure)
            {
                failure(@"插入数据失败");
            }
        }
        @finally {
            if (isRollBack)
            {
                NSLog(@"insert to database failure content");
                if(failure)
                {
                    failure(@"插入数据失败");
                }
                result= NO;
            }
            else
            {
                result= YES;
                if(success)
                {
                    success();
                }
            }
        }
    }];
    return result;
}
//insertWithObject:
+ (BOOL)clearTableSuccess:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure 
{
    BOOL result = NO;
    result = [EmotionRecentItems deleteWithWhereString:@"" success:success failure:failure]; 
    return result;
}


@end
