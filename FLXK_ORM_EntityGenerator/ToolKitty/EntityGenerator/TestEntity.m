////
////  TestEntity.m
////  Psy-TeachersTerminal
////
////  Created by apple on 2016/6/27.
////  Copyright © 2016年 apple. All rights reserved.
////
//
#import "TestEntity.h"
//#import "PsyDBHelper.h"
//#import "MJExtension.h"
//
@implementation TestEntity
//
//+ (BOOL)createTable
//{
//    __block BOOL res = YES;
//    PsyDBHelper *PsyDB = [PsyDBHelper shareInstance];
//    [PsyDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        NSString *tableName = NSStringFromClass(self.class);
//        NSString *columeAndType = @"name TEXT,age INTEGER";
//        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
//        if (![db executeUpdate:sql]) {
//            res = NO;
//            *rollback = YES;
//        };
//    }];
//    return res;
//};
////selectAll
//+ (NSArray *)selectAll
//{
//    PsyDBHelper *PsyDB = [PsyDBHelper shareInstance];
//    NSMutableArray *entitiyResults = [NSMutableArray array];
//    
//    [PsyDB.dbQueue inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM TestEntity"];
//        FMResultSet *resultSet = [db executeQuery:sql];
//        while ([resultSet next]) {
//            TestEntity *entity = [[TestEntity alloc] init];
//            entity.name=[resultSet stringForColumn:@"name"];
//            entity.age=[resultSet longLongIntForColumn:@"age"];
//            [entitiyResults addObject:entity];
//            FMDBRelease(entity);
//        }
//    }];
//    return entitiyResults;
//};
////selectByCriteria
//+ (NSArray *)selectByCriteria:(NSString *)criteria
//{
//    PsyDBHelper *PsyDB = [PsyDBHelper shareInstance];
//    NSMutableArray *entitiyResults = [NSMutableArray array];
//    [PsyDB.dbQueue inDatabase:^(FMDatabase *db) {
//        if (![db tableExists:@"User"])
//        {
//            [TestEntity createTable];
//        }
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM TestEntity %@",criteria];
//        FMResultSet *resultSet = [db executeQuery:sql];
//        while ([resultSet next]) {
//            TestEntity *entity = [[TestEntity alloc] init];
//            entity.name=[resultSet stringForColumn:@"name"];
//            entity.age=[resultSet longLongIntForColumn:@"age"];
//            [entitiyResults addObject:entity];
//            FMDBRelease(entity);
//        }
//    }];
//    return entitiyResults;
//};
////insertWithObject:
//+ (BOOL)insertWithObject:(TestEntity*)obj success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
//{
//    __block BOOL isRollBack = NO;
//    __block BOOL result = NO;
//    //NSString *keyString =@"name,age";
//    //NSString *valueString =@"?,?";
//    //NSString *insertValues =@"obj.name,@(obj.age)";
//    
//    
//    
//    PsyDBHelper *PsyDB = [PsyDBHelper shareInstance];
//    [PsyDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        @try {
//            NSString *sql = @"INSERT INTO TestEntity(name,age) VALUES (?,?)";
//            BOOL result = [db executeUpdate:sql,obj.name,@(obj.age)];
//            if (!result)
//            {
//                *rollback = YES;
//                isRollBack = YES;
//            }
//        }
//        @catch (NSException *exception) {
//            if(failure)
//            {
//                failure(@"插入数据失败");
//            }
//        }
//        @finally {
//            if (isRollBack)
//            {
//                NSLog(@"insert to database failure content");
//                if(failure)
//                {
//                    failure(@"插入数据失败");
//                }
//                result= NO;
//            }
//            else
//            {
//                result= YES;
//                if(success)
//                {
//                    success();
//                }
//            }
//        }
//    }];
//    return result;
//}
////insertWithObject:
//+ (BOOL)insertWithObjects:(NSArray<TestEntity*>*)objs success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
//{
//    __block BOOL isRollBack = NO;
//    __block BOOL result = NO;
//    //NSString *keyString =@"name,age";
//    //NSString *valueString =@"?,?";
//    //NSString *insertValues =@"entity.name,@(entity.age)";
//    
//    
//    
//    PsyDBHelper *PsyDB = [PsyDBHelper shareInstance];
//    [PsyDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            TestEntity* entity = (TestEntity*)obj;
//            
//            @try {
//                NSString *sql = @"INSERT INTO TestEntity(name,age) VALUES (?,?)";
//                BOOL result = [db executeUpdate:sql,entity.name,@(entity.age)];
//                if (!result)
//                {
//                    *rollback = YES;
//                    isRollBack = YES;
//                }
//            }
//            @catch (NSException *exception) {
//                if(failure)
//                {
//                    failure(@"插入数据失败");
//                }
//            }
//            @finally {
//                if (isRollBack)
//                {
//                    NSLog(@"insert to database failure content");
//                    if(failure)
//                    {
//                        failure(@"插入数据失败");
//                    }
//                    result= NO;
//                }
//                else
//                {
//                    result= YES;
//                    if(success)
//                    {
//                        success();
//                    }
//                }
//            }
//        }];
//    }];
//    return result;
//}
////insertWithObject:
//+ (BOOL)updateObject:(TestEntity*)obj withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
//{
//    __block BOOL isRollBack = NO;
//    __block BOOL result = NO;
//    //NSString *keyString =@" name= ? , age= ? ";
//    //NSString *insertValues =@"entity.name,@(entity.age)";
//    
//    
//    
//    PsyDBHelper *PsyDB = [PsyDBHelper shareInstance];
//    [PsyDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        TestEntity* entity = (TestEntity*)obj;
//        
//        @try {
//            NSString *tempSql = [NSString stringWithFormat:@"UPDATE TestEntity set  name= ? , age= ? "];
//            NSString *sql = [NSString stringWithFormat:@"%@ %@",tempSql,where];
//            BOOL result = [db executeUpdate:sql,entity.name,@(entity.age)];
//            if (!result)
//            {
//                *rollback = YES;
//                isRollBack = YES;
//            }
//        }
//        @catch (NSException *exception) {
//            if(failure)
//            {
//                failure(@"插入数据失败");
//            }
//        }
//        @finally {
//            if (isRollBack)
//            {
//                NSLog(@"insert to database failure content");
//                if(failure)
//                {
//                    failure(@"插入数据失败");
//                }
//                result= NO;
//            }
//            else
//            {
//                result= YES;
//                if(success)
//                {
//                    success();
//                }
//            }
//        }
//    }];
//    return result;
//}
////insertWithObject:
//+ (BOOL)updateObjects:(NSArray<TestEntity*>*)objs withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
//{
//    __block BOOL isRollBack = NO;
//    __block BOOL result = NO;
//    //NSString *keyString =@" name= ? , age= ? ";
//    //NSString *insertValues =@"entity.name,@(entity.age)";
//    
//    
//    
//    PsyDBHelper *PsyDB = [PsyDBHelper shareInstance];
//    [PsyDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            TestEntity* entity = (TestEntity*)obj;
//            
//            @try {
//                NSString *tempSql = [NSString stringWithFormat:@"UPDATE TestEntity set  name= ? , age= ? "];
//                NSString *sql = [NSString stringWithFormat:@"%@ %@",tempSql,where];
//                BOOL result = [db executeUpdate:sql,entity.name,@(entity.age)];
//                if (!result)
//                {
//                    *rollback = YES;
//                    isRollBack = YES;
//                }
//            }
//            @catch (NSException *exception) {
//                if(failure)
//                {
//                    failure(@"插入数据失败");
//                }
//            }
//            @finally {
//                if (isRollBack)
//                {
//                    NSLog(@"insert to database failure content");
//                    if(failure)
//                    {
//                        failure(@"插入数据失败");
//                    }
//                    result= NO;
//                }
//                else
//                {
//                    result= YES;
//                    if(success)
//                    {
//                        success();
//                    }
//                }
//            }
//        }];
//    }];
//    return result;
//}
////insertWithObject:
//+ (BOOL)deleteWithWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
//{
//    __block BOOL isRollBack = NO;
//    __block BOOL result = NO;
//    
//    
//    
//    PsyDBHelper *PsyDB = [PsyDBHelper shareInstance];
//    [PsyDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        
//        @try {
//            NSString *tableName = NSStringFromClass(self.class);
//            NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@   %@  ",tableName,where];
//            BOOL result = [db executeUpdate:sql];
//            if (!result)
//            {
//                isRollBack = YES;
//            }
//        }
//        @catch (NSException *exception) {
//            if(failure)
//            {
//                failure(@"插入数据失败");
//            }
//        }
//        @finally {
//            if (isRollBack)
//            {
//                NSLog(@"insert to database failure content");
//                if(failure)
//                {
//                    failure(@"插入数据失败");
//                }
//                result= NO;
//            }
//            else
//            {
//                result= YES;
//                if(success)
//                {
//                    success();
//                }
//            }
//        }
//    }];
//    return result;
//}
////insertWithObject:
//+ (BOOL)clearTableSuccess:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
//{
//    BOOL result = NO;
//    result = [TestEntity deleteWithWhereString:@"" success:success failure:failure];
//    return result;
//}
//
//
//
//
//
//
//
//
//
//
////
//////to convert object to jsonstring
////+(NSString*)convertToJsonStringWithObject:(TestEntity*)obj{
////    NSString *jsonString = @"";
////    if (obj) {
////        NSArray<TestEntity*>* objs=[NSArray arrayWithObject:obj];
////        [TestEntity convertToJsonStringWithObjects:objs];
////    }
////    else{
////        jsonString =@"Obj is nil,please check!";
////    }
////    return jsonString;
////};
////
//////to convert objects to jsonstring
////+(NSString*)convertToJsonStringWithObjects:(NSArray<TestEntity*>*)objs{
////    NSString *jsonString = @"";
////    if (objs) {
////        NSArray *dictArray = [TestEntity mj_keyValuesArrayWithObjectArray:objs];
////        NSError *error;
////        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
////        if (!error) {
////            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
////        }
////        else{
////            jsonString=error.description;
////        }
////        
////    }
////    else{
////        jsonString =@"Objs is nil,please check!";
////    }
////    return jsonString;
////};
////
//////to convert jsonstring  to object
////+(TestEntity*)convertJsonStringToObj:(NSString*)jsonString{
////    if (jsonString) {
////        TestEntity *obj = [TestEntity mj_objectWithKeyValues::jsonString];
////        NSError *error;
////        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
////        if (!error) {
////            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
////        }
////        else{
////            jsonString=error.description;
////        }
////        
////    }
////    else{
////        jsonString =@"Objs is nil,please check!";
////    }
////    return jsonString;
////}
////
//////to convert jsonstring  to objects
////+(NSArray<TestEntity*>*)convertJsonStringToObjs:(NSString*)jsonString{
////    
////}
////
////
////// write the JsonString convert from obj To File
////+(NSError*)writeJsonStringToFile:(nullable NSString*)filePath withObject:(TestEntity*)obj{
////    NSError* error=nil;
////    if (obj) {
////        NSArray<TestEntity*>* objs=[NSArray arrayWithObject:obj];
////        error=[TestEntity writeJsonStringToFile:filePath withObjects:objs];
////    }
////    else{
////        error= [TestEntity errorWithDescription:@"Obj is nil,please check!"];
////    }
////    return error;
////};
////
////// write the JsonString convert from objs To File
////+(NSError*)writeJsonStringToFile:(nullable NSString*)filePath withObjects:(NSArray<TestEntity*>*)objs {
////    NSError* error=nil;
////    NSString *jsonString = @"";
////    if (objs) {
////        jsonString= [TestEntity convertToJsonStringWithObjects:objs];
////        error=[TestEntity writeJsonString:jsonString ToFile:filePath isAppend:NO];
////    }
////    else{
////        error= [TestEntity errorWithDescription:@"Objs is nil,please check!"];
////    }
////    return error;
////};
////
////+(NSError*)appendJsonStringToFile:(nullable NSString*)filePath withObject:(TestEntity*)obj{
////    NSError* error=nil;
////    if (obj) {
////           id a=NSClassFromString(@"TestEntity");
////        NSArray<a*>* objs1=[NSArray arrayWithObject:obj];
////     
////        NSArray<TestEntity*>* objs=[NSArray arrayWithObject:obj];
////        error=[TestEntity appendJsonStringToFile:filePath withObjects:objs];
////    }
////    else{
////        error= [TestEntity errorWithDescription:@"Obj is nil,please check!"];
////    }
////    return error;
////};
////+(NSError*)appendJsonStringToFile:(nullable NSString*)filePath withObjects:(NSArray<TestEntity*>*)objs{
////    NSError* error=nil;
////    NSString *jsonString = @"";
////    if (objs) {
////        jsonString= [TestEntity convertToJsonStringWithObjects:objs];
////        error=[TestEntity writeJsonString:jsonString ToFile:filePath isAppend:YES];
////    }
////    else{
////        error= [TestEntity errorWithDescription:@"Objs is nil,please check!"];
////    }
////    return error;
////};
////
//////+(TestEntity*)readJsonStringToObjFromFile:(nullable NSString*)filePath{
//////    
//////};
////+(NSArray<TestEntity*>*)readJsonStringToObjsFromFile:(nullable NSString*)filePath{
////    
////    NSFileManager* fileManager  = [NSFileManager defaultManager];
////    if (filePath) {
////        BOOL isDirectory=NO;
////        BOOL isExistDirectory = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
////        if (isDirectory) {
////            return nil;
////        }
////        if (!isExistDirectory) {
////            return nil;
////        }
////        //start to read data to file
////        NSData* a=[NSData dataWithContentsOfFile:filePath];
////        NSArray* dictArray=[NSJSONSerialization  JSONObjectWithData:a options:NSJSONReadingMutableContainers error:nil];
////        // JSON array -> Model array
////        NSArray *objArray = [TestEntity mj_objectArrayWithKeyValuesArray:dictArray];
////        return objArray;
////    }
////    else{
////        NSString* rootPathOfDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
////        NSFileManager* fileManager  = [NSFileManager defaultManager];
////        NSString* designedPath = [rootPathOfDocument stringByAppendingPathComponent:EntityDirectory];
////        BOOL isDirectory=NO;
////        BOOL isExistDirectory = [fileManager fileExistsAtPath:designedPath isDirectory:&isDirectory];
////        if (!isExistDirectory) {
////            return nil;
////        }
////        
////        designedPath = [designedPath stringByAppendingPathComponent:[NSString stringWithFormat:@"TestEntity%@",FileExtension]];
////        BOOL isExist = [fileManager fileExistsAtPath:designedPath];
////        if (!isExist) {
////            return nil;
////        }
////        //start to read data to file
////        NSData* a=[NSData dataWithContentsOfFile:designedPath];
////        NSArray* dictArray=[NSJSONSerialization  JSONObjectWithData:a options:NSJSONReadingMutableContainers error:nil];
////        // JSON array -> Model array
////        NSArray *objArray = [TestEntity mj_objectArrayWithKeyValuesArray:dictArray];
////        return objArray;
////    }
////    
////};
////
////+(NSError*)errorWithDescription:(NSString*)description{
////    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
////    NSError* error=[NSError errorWithDomain:@"TestEntity" code:100000 userInfo:userInfo];
////    return error;
////}
////
////
////+(NSError*)writeJsonString:(nullable NSString*)jsonString ToFile:(nullable NSString*)filePath isAppend:(BOOL)isAppend{
////    NSError* error=nil;
////    NSFileManager* fileManager  = [NSFileManager defaultManager];
////    if (filePath) {
////        BOOL isDirectory=NO;
////        BOOL isExistDirectory = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
////        if (isDirectory) {
////            error=[TestEntity errorWithDescription:[NSString stringWithFormat:@"%@ is Directory!",filePath]];
////        }
////        if (!isExistDirectory) {
////            BOOL res= [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
////            if (res) {
////                
////            }else{
////                return  error=[TestEntity errorWithDescription:@"文件创建失败"];
////            }
////        }
////        //start to write data to file
////        if (isAppend) {
////            NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
////            [fileHandler seekToEndOfFile];
////            [fileHandler writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
////            [fileHandler closeFile];
////        }
////        else{
////            [jsonString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
////        }
////        return error;
////    }
////    else{
////        NSString* rootPathOfDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
////        NSFileManager* fileManager  = [NSFileManager defaultManager];
////        NSString* designedPath = [rootPathOfDocument stringByAppendingPathComponent:EntityDirectory];
////        BOOL isDirectory=NO;
////        BOOL isExistDirectory = [fileManager fileExistsAtPath:designedPath isDirectory:&isDirectory];
////        if (!isExistDirectory) {
////            BOOL res= [fileManager createDirectoryAtPath:designedPath withIntermediateDirectories:YES attributes:nil error:nil];
////            if (res) {
////                
////            }else
////                return  error=[TestEntity errorWithDescription:@"目录创建失败"];
////        }
////        
////        designedPath = [designedPath stringByAppendingPathComponent:[NSString stringWithFormat:@"TestEntity%@",FileExtension]];
////        BOOL isExist = [fileManager fileExistsAtPath:designedPath];
////        if (!isExist) {
////            BOOL res= [fileManager createFileAtPath:designedPath contents:nil attributes:nil];
////            if (res) {
////                
////            }else
////                return  error=[TestEntity errorWithDescription:@"文件创建失败"];
////        }
////        //start to write data to file
////        if (isAppend) {
////            NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:designedPath];
////            [fileHandler seekToEndOfFile];
////            [fileHandler writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
////            [fileHandler closeFile];
////        }
////        else{
////            [jsonString writeToFile:designedPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
////        }
////        return error;
////    }
////}
//
//
@end
