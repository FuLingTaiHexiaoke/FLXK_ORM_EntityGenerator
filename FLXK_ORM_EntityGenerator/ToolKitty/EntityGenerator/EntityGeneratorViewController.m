//
//  EntityGeneratorViewController.m
//  Psy-TeachersTerminal
//
//  Created by apple on 2016/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//
/** SQLite五种数据类型 */
#define SQLTEXT     @"TEXT"
#define SQLINTEGER  @"INTEGER"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"
//#define PrimaryKey  @"primary key"
//#define primaryId   @"pk"
#define PrimaryKey   @"primaryKey"
#define PrimaryKeyRowIndex   @"primaryKeyRowIndex"






#import "EntityGeneratorViewController.h"
#import <objc/runtime.h>


#import "TestEntity.h"

//#import "EntityGeneratorViewController.h"

//if (DEBUG) {
//    UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
//    [btn addTarget:self action:@selector(showEntityGenerator) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor=[UIColor yellowColor];
//    [self.view addSubview:btn];
//}

//-(void)showEntityGenerator{
//    EntityGeneratorViewController* entityGeneratorViewController=[[EntityGeneratorViewController alloc]initWithNibName:@"EntityGeneratorViewController" bundle:nil];
//    [self presentViewController:entityGeneratorViewController animated:YES completion:nil];
//}

@interface EntityGeneratorViewController ()
@property (strong, nonatomic) IBOutlet UITextField *className;
@property (nonatomic) NSString*         classNameString;
@property (nonatomic) NSMutableString*         allFunctions;
@property (nonatomic) NSMutableString*         allInterfaces;
/** 列名 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeNamesOfEachTable;
/** 列类型 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeTypesOfEachTable;

- (IBAction)GrenerateEntitySql:(id)sender;

- (IBAction)createTable:(id)sender;
- (IBAction)insert:(id)sender;
- (IBAction)select:(id)sender;
- (IBAction)selectWhere:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)clear:(id)sender;

@end

@implementation EntityGeneratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.className.text=@"TestEntity";
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=[UIColor yellowColor];
        [self.view addSubview:btn];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)GrenerateEntitySql:(id)sender {
    
    if (!self.className.text) {
        return;
    }
    
    NSDictionary *dic = [self getAllProperties];
    _columeNamesOfEachTable = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"name"]];
    _columeTypesOfEachTable = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"type"]];
    self.allFunctions=[NSMutableString stringWithString:@"\n"];
    self.allInterfaces=[NSMutableString stringWithString:@"\n"];
    [self createTable];
    [self  dropTable];
    [self selectAll];
    [self selectByCriteria];
    
    [self insertWithObject];
    [self insertWithObjects];
    
    [self updateObject];
    [self updateObjects];
    
    [self deleteObject];
    [self clearTable];
    
    NSLog(@"%@",self.allInterfaces);
    NSLog(@"%@",self.allFunctions);
}

- (IBAction)createTable:(id)sender {
    [TestEntity createTable];
}

- (IBAction)insert:(id)sender {
    TestEntity* test=[TestEntity new];
    test.name=@"test";
    test.age=20;
    [TestEntity insertWithObject:test success:nil failure:nil];
}

- (IBAction)select:(id)sender {
    //    [TestEntity selectAll];
  
}

- (IBAction)selectWhere:(id)sender {
//    [TestEntity selectByCriteria:@" where age>1"];
}

//- (IBAction)delete:(id)sender {
////    [TestEntity deleteWithWhereString:@" where  age>1" success:nil failure:nil];
//    
//       NSArray<b_Class*> *classes= [b_Class selectAll];
////    [PsyJsonHelper<b_Class*> convertObjsToJsonString:classes];
//     [PsyJsonHelper<b_Class*>  appendJsonStringFromObjs:classes withType:@"b_Class" ToFile:nil];
//    
//    NSArray<b_Class*> *userArray=   [PsyJsonHelper<b_Class*> convertJsonStringToObjsFromFile:nil withType:@"b_Class"];
//    for (b_Class *user in userArray) {
//        NSLog(@"name=%@, icon=%@", user.ClassName, user.ClassID);
//    }
//}

- (IBAction)clear:(id)sender {
    [TestEntity clearTableSuccess:nil failure:nil];
}
- (void)clearTable
{
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//insertWithObject:\n"];
    NSString *tableName = self.className.text;
    [sqlSelect appendString:@"+ (BOOL)clearTableSuccess:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure \n"];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@" BOOL result = NO;\n"];
    
    [sqlSelect appendFormat:@"result = [%@ deleteWithWhereString:@\"\" success:success failure:failure]; \n",tableName];
    [sqlSelect appendString:@"return result;\n"];
    [sqlSelect appendString:@"}\n"];
    [self.allFunctions appendString:sqlSelect];
    //    NSL/System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearchog(sqlSelect);
}


- (void)deleteObject
{
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//insertWithObject:\n"];
    [sqlSelect appendString:@"+ (BOOL)deleteWithWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure \n"];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"__block BOOL isRollBack = NO;\n"];
    [sqlSelect appendString:@"__block BOOL result = NO;\n"];
    
    [sqlSelect appendString:@"FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];\n"];
    [sqlSelect appendString:@"[FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {\n"];
    //[sqlSelect appendFormat:@"if (![db tableExists:@\"%@\"])\n",self.className.text.lowercaseString];
    //    [sqlSelect appendString:@"{\n"];
    //    [sqlSelect appendFormat:@"[%@ createTable];\n",self.className.text];
    //    [sqlSelect appendString:@"}\n"];
    //    [sqlSelect appendString:@"\n"];
    //    [sqlSelect appendString:@"\n"];
    //    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"@try {\n"];
    [sqlSelect appendString:@" NSString *tableName = NSStringFromClass(self.class);\n"];
    [sqlSelect appendString:@"NSString *sql = [NSString stringWithFormat:@\"DELETE FROM  %%@   %%@  \",tableName,where];\n"];
    [sqlSelect appendFormat:@"BOOL result = [db executeUpdate:sql];\n"];
    [sqlSelect appendString:@"if (!result)\n"];
    [sqlSelect appendString:@"{\n"];
    ;
    [sqlSelect appendString:@" isRollBack = YES;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"@catch (NSException *exception) {\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"@finally {\n"];
    [sqlSelect appendString:@"if (isRollBack)\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"NSLog(@\"insert to database failure content\");\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@"result= NO;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@" else\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db commit];\n"];
    [sqlSelect appendString:@"result= YES;\n"];
    [sqlSelect appendString:@"if(success)\n{\n success();\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"return result;\n"];
    [sqlSelect appendString:@"}\n"];
    //    NSLog(sqlSelect);
    [self.allFunctions appendString:sqlSelect];
    
}


- (void)updateObject
{
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//insertWithObject:\n"];
    
    NSString *tableName = self.className.text;
    [sqlSelect appendFormat:@"+ (BOOL)updateObject:(%@*)obj withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure \n",tableName];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"__block BOOL isRollBack = NO;\n"];
    [sqlSelect appendString:@"__block BOOL result = NO;\n"];
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *insertValues = [NSMutableString string];
    for (int i = 0; i < self.columeNamesOfEachTable.count; i++) {
        NSString *proname = [self.columeNamesOfEachTable objectAtIndex:i];
        [keyString appendFormat:@" %@= ? ,", proname];
        NSString *columeType = [self.columeTypesOfEachTable objectAtIndex:i];
        if ([columeType isEqualToString:SQLTEXT]) {
            [insertValues appendFormat:@"entity.%@,", proname];
            
        } else {
            [insertValues appendFormat:@"@(entity.%@),", proname];
        }
    }
    
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [insertValues deleteCharactersInRange:NSMakeRange(insertValues.length - 1, 1)];
    [sqlSelect appendFormat:@"//NSString *keyString =@\"%@\";\n",keyString];
    [sqlSelect appendFormat:@"//NSString *insertValues =@\"%@\";\n",insertValues];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];\n"];
    [sqlSelect appendString:@"[FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {\n"];
    //[sqlSelect appendFormat:@"if (![db tableExists:@\"%@\"])\n",self.className.text.lowercaseString];
    //    [sqlSelect appendString:@"{\n"];
    //    [sqlSelect appendFormat:@"[%@ createTable];\n",self.className.text];
    //    [sqlSelect appendString:@"}\n"];
    //    [sqlSelect appendString:@"[objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {\n"];
    [sqlSelect appendFormat:@"%@* entity = (%@*)obj;\n",tableName,tableName];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"@try {\n"];
    //    [sqlSelect appendString:@" NSString *tableName = NSStringFromClass(self.class);\n"];
    NSString *tempSql = [NSString stringWithFormat:@"UPDATE %@ set %@",tableName,keyString];
    [sqlSelect appendFormat:@"NSString *tempSql = [NSString stringWithFormat:@\"%@\"];\n",tempSql];
    [sqlSelect appendString:@"NSString *sql = [NSString stringWithFormat:@\"%%@ %%@\",tempSql,where];\n"];
    [sqlSelect appendFormat:@"BOOL result = [db executeUpdate:sql,%@];\n",insertValues];
    [sqlSelect appendString:@"if (!result)\n"];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"*rollback = YES;\n"];
    [sqlSelect appendString:@" isRollBack = YES;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"@catch (NSException *exception) {\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"@finally {\n"];
    [sqlSelect appendString:@"if (isRollBack)\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"NSLog(@\"insert to database failure content\");\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@"result= NO;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@" else\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db commit];\n"];
    [sqlSelect appendString:@"result= YES;\n"];
    [sqlSelect appendString:@"if(success)\n{\n success();\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}];\n"];
    //    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"return result;\n"];
    [sqlSelect appendString:@"}\n"];
    [self.allFunctions appendString:sqlSelect];
    
    //    NSLog(sqlSelect);
}

- (void)updateObjects
{
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//insertWithObject:\n"];
    
    NSString *tableName = self.className.text;
    [sqlSelect appendFormat:@"+ (BOOL)updateObjects:(NSArray<%@*>*)objs withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure \n",tableName];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"__block BOOL isRollBack = NO;\n"];
    [sqlSelect appendString:@"__block BOOL result = NO;\n"];
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *insertValues = [NSMutableString string];
    for (int i = 0; i < self.columeNamesOfEachTable.count; i++) {
        NSString *proname = [self.columeNamesOfEachTable objectAtIndex:i];
        [keyString appendFormat:@" %@= ? ,", proname];
        NSString *columeType = [self.columeTypesOfEachTable objectAtIndex:i];
        if ([columeType isEqualToString:SQLTEXT]) {
            [insertValues appendFormat:@"entity.%@,", proname];
            
        } else {
            [insertValues appendFormat:@"@(entity.%@),", proname];
        }
    }
    
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [insertValues deleteCharactersInRange:NSMakeRange(insertValues.length - 1, 1)];
    [sqlSelect appendFormat:@"//NSString *keyString =@\"%@\";\n",keyString];
    [sqlSelect appendFormat:@"//NSString *insertValues =@\"%@\";\n",insertValues];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];\n"];
    [sqlSelect appendString:@"[FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {\n"];
    //[sqlSelect appendFormat:@"if (![db tableExists:@\"%@\"])\n",self.className.text.lowercaseString];
    //    [sqlSelect appendString:@"{\n"];
    //    [sqlSelect appendFormat:@"[%@ createTable];\n",self.className.text];
    //    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"[objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {\n"];
    [sqlSelect appendFormat:@"%@* entity = (%@*)obj;\n",tableName,tableName];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"@try {\n"];
    //    [sqlSelect appendString:@" NSString *tableName = NSStringFromClass(self.class);\n"];
    NSString *tempSql = [NSString stringWithFormat:@"UPDATE %@ set %@",tableName,keyString];
    [sqlSelect appendFormat:@"NSString *tempSql = [NSString stringWithFormat:@\"%@\"];\n",tempSql];
    [sqlSelect appendString:@"NSString *sql = [NSString stringWithFormat:@\"%%@ %%@\",tempSql,where];\n"];
    [sqlSelect appendFormat:@"BOOL result = [db executeUpdate:sql,%@];\n",insertValues];
    [sqlSelect appendString:@"if (!result)\n"];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"*rollback = YES;\n"];
    [sqlSelect appendString:@" isRollBack = YES;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"@catch (NSException *exception) {\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"@finally {\n"];
    [sqlSelect appendString:@"if (isRollBack)\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"NSLog(@\"insert to database failure content\");\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@"result= NO;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@" else\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db commit];\n"];
    [sqlSelect appendString:@"result= YES;\n"];
    [sqlSelect appendString:@"if(success)\n{\n success();\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"return result;\n"];
    [sqlSelect appendString:@"}\n"];
    //    NSLog(sqlSelect);
    [self.allFunctions appendString:sqlSelect];
}

- (void)insertWithObjects
{
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//insertWithObject:\n"];
    
    NSString *tableName = self.className.text;
    [sqlSelect appendFormat:@"+ (BOOL)insertWithObjects:(NSArray<%@*>*)objs success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure \n",tableName];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"__block BOOL isRollBack = NO;\n"];
    [sqlSelect appendString:@"__block BOOL result = NO;\n"];
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableString *insertValues = [NSMutableString string];
    for (int i = 0; i < self.columeNamesOfEachTable.count; i++) {
        NSString *proname = [self.columeNamesOfEachTable objectAtIndex:i];
        [keyString appendFormat:@"%@,", proname];
        [valueString appendString:@"?,"];
        
        NSString *columeType = [self.columeTypesOfEachTable objectAtIndex:i];
        if ([columeType isEqualToString:SQLTEXT]) {
            [insertValues appendFormat:@"entity.%@,", proname];
            
        } else {
            [insertValues appendFormat:@"@(entity.%@),", proname];
        }
    }
    
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    [insertValues deleteCharactersInRange:NSMakeRange(insertValues.length - 1, 1)];
    [sqlSelect appendFormat:@"//NSString *keyString =@\"%@\";\n",keyString];
    [sqlSelect appendFormat:@"//NSString *valueString =@\"%@\";\n",valueString];
    [sqlSelect appendFormat:@"//NSString *insertValues =@\"%@\";\n",insertValues];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];\n"];
    [sqlSelect appendString:@"[FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {\n"];
    //[sqlSelect appendFormat:@"if (![db tableExists:@\"%@\"])\n",self.className.text.lowercaseString];
    //    [sqlSelect appendString:@"{\n"];
    //    [sqlSelect appendFormat:@"[%@ createTable];\n",self.className.text];
    //    [sqlSelect appendString:@"}\n"];
    
    [sqlSelect appendString:@"[objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {\n"];
    [sqlSelect appendFormat:@"%@* entity = (%@*)obj;\n",tableName,tableName];
    [sqlSelect appendString:@"\n"];
    
    
    [sqlSelect appendString:@"@try {\n"];
    //    [sqlSelect appendString:@" NSString *tableName = NSStringFromClass(self.class);\n"];
    [sqlSelect appendFormat:@"NSString *sql = @\"INSERT OR REPLACE INTO %@(%@) VALUES (%@)\";\n",tableName,keyString,valueString];
    [sqlSelect appendFormat:@"BOOL result = [db executeUpdate:sql,%@];\n",insertValues];
    [sqlSelect appendString:@"if (!result)\n"];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"*rollback = YES;\n"];
    [sqlSelect appendString:@" isRollBack = YES;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"@catch (NSException *exception) {\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"@finally {\n"];
    [sqlSelect appendString:@"if (isRollBack)\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"NSLog(@\"insert to database failure content\");\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@"result= NO;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@" else\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db commit];\n"];
    [sqlSelect appendString:@"result= YES;\n"];
    [sqlSelect appendString:@"if(success)\n{\n success();\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"return result;\n"];
    [sqlSelect appendString:@"}\n"];
    [self.allFunctions appendString:sqlSelect];
    
    //    NSLog(sqlSelect);
    //            [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
}


/**
 * 创建表
 * 如果已经创建，返回YES
 */
- (void)insertWithObject
{
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//insertWithObject:\n"];
    
    NSString *tableName = self.className.text;
    [sqlSelect appendFormat:@"+ (BOOL)insertWithObject:(%@*)obj success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure \n",tableName];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"__block BOOL isRollBack = NO;\n"];
    [sqlSelect appendString:@"__block BOOL result = NO;\n"];
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableString *insertValues = [NSMutableString string];
    for (int i = 0; i < self.columeNamesOfEachTable.count; i++) {
        NSString *proname = [self.columeNamesOfEachTable objectAtIndex:i];
        [keyString appendFormat:@"%@,", proname];
        [valueString appendString:@"?,"];
        
        NSString *columeType = [self.columeTypesOfEachTable objectAtIndex:i];
        if ([columeType isEqualToString:SQLTEXT]) {
            [insertValues appendFormat:@"obj.%@,", proname];
            
        } else {
            [insertValues appendFormat:@"@(obj.%@),", proname];
        }
    }
    
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    [insertValues deleteCharactersInRange:NSMakeRange(insertValues.length - 1, 1)];
    [sqlSelect appendFormat:@"//NSString *keyString =@\"%@\";\n",keyString];
    [sqlSelect appendFormat:@"//NSString *valueString =@\"%@\";\n",valueString];
    [sqlSelect appendFormat:@"//NSString *insertValues =@\"%@\";\n",insertValues];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"\n"];
    [sqlSelect appendString:@"FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];\n"];
    [sqlSelect appendString:@"[FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {\n"];
    //[sqlSelect appendFormat:@"if (![db tableExists:@\"%@\"])\n",self.className.text.lowercaseString];
    //    [sqlSelect appendString:@"{\n"];
    //    [sqlSelect appendFormat:@"[%@ createTable];\n",self.className.text];
    //    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"@try {\n"];
    //    [sqlSelect appendString:@" NSString *tableName = NSStringFromClass(self.class);\n"];
    [sqlSelect appendFormat:@"NSString *sql = @\"INSERT OR REPLACE INTO %@(%@) VALUES (%@)\";\n",tableName,keyString,valueString];
    [sqlSelect appendFormat:@"BOOL result = [db executeUpdate:sql,%@];\n",insertValues];
    [sqlSelect appendString:@"if (!result)\n"];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"*rollback = YES;\n"];
    [sqlSelect appendString:@" isRollBack = YES;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"@catch (NSException *exception) {\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"@finally {\n"];
    [sqlSelect appendString:@"if (isRollBack)\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db rollback];\n"];
    [sqlSelect appendString:@"NSLog(@\"insert to database failure content\");\n"];
    [sqlSelect appendString:@"if(failure)\n{\nfailure(@\"插入数据失败\");\n}\n"];
    [sqlSelect appendString:@"result= NO;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@" else\n"];
    [sqlSelect appendString:@"{\n"];
    //[sqlSelect appendString:@"//[db commit];\n"];
    [sqlSelect appendString:@"result= YES;\n"];
    [sqlSelect appendString:@"if(success)\n{\n success();\n}\n"];
    [sqlSelect appendString:@" }\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"return result;\n"];
    [sqlSelect appendString:@"}\n"];
    [self.allFunctions appendString:sqlSelect];
    
    //    NSLog(sqlSelect);
    //            [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
}

/**
 *
 */
-(void)selectByCriteria{
    //selectByCriteria
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//selectByCriteria\n"];
    [sqlSelect appendFormat:@"+ (NSArray<%@*> *)selectByCriteria:(NSString *)criteria\n",self.className.text];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];\n"];
    [sqlSelect appendString:@"NSMutableArray *entitiyResults = [NSMutableArray array];\n"];
    [sqlSelect appendString:@"[FLXKDB.dbQueue inDatabase:^(FMDatabase *db) {\n"];
    //[sqlSelect appendFormat:@"if (![db tableExists:@\"%@\"])\n",self.className.text.lowercaseString];
    //    [sqlSelect appendString:@"{\n"];
    //    [sqlSelect appendFormat:@"[%@ createTable];\n",self.className.text];
    //    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendFormat:@" NSString *sql = [NSString stringWithFormat:@\"SELECT * FROM %@ ",self.className.text];
    [sqlSelect appendString:@"%%@\",criteria];\n"];
    [sqlSelect appendString:@"FMResultSet *resultSet = [db executeQuery:sql];\n"];
    [sqlSelect appendString:@"while ([resultSet next]) {\n"];
    [sqlSelect appendFormat:@"%@ *entity = [[%@ alloc] init];\n",self.className.text,self.className.text];
    for (int i=0; i< self.columeNamesOfEachTable.count; i++) {
        NSString *columeName = [self.columeNamesOfEachTable objectAtIndex:i];
        NSString *columeType = [self.columeTypesOfEachTable objectAtIndex:i];
        if ([columeType isEqualToString:SQLTEXT]) {
            [sqlSelect appendFormat:@"entity.%@=[resultSet stringForColumn:@\"%@\"];\n",columeName,columeName];
            
        } else {
            [sqlSelect appendFormat:@"entity.%@=[resultSet longLongIntForColumn:@\"%@\"];\n",columeName,columeName];
        }
    }
    [sqlSelect appendString:@"[entitiyResults addObject:entity];\n"];
    [sqlSelect appendString:@" FMDBRelease(entity);\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"return entitiyResults;\n"];
    [sqlSelect appendString:@"};\n"];
    //    NSLog(sqlSelect);
    [self.allFunctions appendString:sqlSelect];
    
    
}
-(void)selectAll{
    //selectAll
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//selectAll\n"];
    [sqlSelect appendFormat:@"+ (NSArray<%@*> *)selectAll\n",self.className.text];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];\n"];
    [sqlSelect appendString:@"NSMutableArray *entitiyResults = [NSMutableArray array];\n"];
    [sqlSelect appendString:@"[FLXKDB.dbQueue inDatabase:^(FMDatabase *db) {\n"];
    //[sqlSelect appendFormat:@"if (![db tableExists:@\"%@\"])\n",self.className.text.lowercaseString];
    //    [sqlSelect appendString:@"{\n"];
    //    [sqlSelect appendFormat:@"[%@ createTable];\n",self.className.text];
    //    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendFormat:@" NSString *sql = [NSString stringWithFormat:@\"SELECT * FROM %@\"];\n ",self.className.text];
    [sqlSelect appendString:@"FMResultSet *resultSet = [db executeQuery:sql];\n"];
    [sqlSelect appendString:@"while ([resultSet next]) {\n"];
    [sqlSelect appendFormat:@"%@ *entity = [[%@ alloc] init];\n",self.className.text,self.className.text];
    for (int i=0; i< self.columeNamesOfEachTable.count; i++) {
        NSString *columeName = [self.columeNamesOfEachTable objectAtIndex:i];
        NSString *columeType = [self.columeTypesOfEachTable objectAtIndex:i];
        if ([columeType isEqualToString:SQLTEXT]) {
            [sqlSelect appendFormat:@"entity.%@=[resultSet stringForColumn:@\"%@\"];\n",columeName,columeName];
            
        } else {
            [sqlSelect appendFormat:@"entity.%@=[resultSet longLongIntForColumn:@\"%@\"];\n",columeName,columeName];
        }
    }
    [sqlSelect appendString:@"[entitiyResults addObject:entity];\n"];
    [sqlSelect appendString:@" FMDBRelease(entity);\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"return entitiyResults;\n"];
    [sqlSelect appendString:@"};\n"];
    //    NSLog(sqlSelect);
    [self.allFunctions appendString:sqlSelect];
    
}

/**
 * 创建表
 * 如果已经创建，返回YES
 */
- (void)createTable
{
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//createTable\n"];
    [sqlSelect appendString:@"+ (BOOL)createTable\n"];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"__block BOOL res = YES;\n"];
    [sqlSelect appendString:@"FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];\n"];
    [sqlSelect appendString:@"[FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {\n"];
    [sqlSelect appendFormat:@"if ([db tableExists:@\"%@\"])\n",self.className.text.lowercaseString];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendFormat:@"return ;\n"];
    [sqlSelect appendString:@"}\n"];
    [sqlSelect appendString:@" NSString *tableName = NSStringFromClass(self.class);\n"];
    [sqlSelect appendFormat:@" NSString *columeAndType = @\"%@\";\n",[self getColumeAndTypeString]];
    [sqlSelect appendString:@"NSString *sql = [NSString stringWithFormat:@\"CREATE TABLE IF NOT EXISTS %%@(%%@);\",tableName,columeAndType];\n"];
    [sqlSelect appendString:@"if (![db executeUpdate:sql]) {\n"];
    [sqlSelect appendString:@"res = NO;\n"];
    [sqlSelect appendString:@"*rollback = YES;\n"];
    //    [sqlSelect appendString:@"return;\n"];
    [sqlSelect appendString:@" };\n"];
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"return res;\n"];
    [sqlSelect appendString:@"};\n"];
    //    NSLog(sqlSelect);
    [self.allFunctions appendString:sqlSelect];
    
    
}

- (void)dropTable
{
    NSMutableString* sqlSelect=[NSMutableString stringWithString:@"//dropTable\n"];
    [sqlSelect appendString:@"+ (BOOL)dropTable\n"];
    [self.allInterfaces appendFormat:@"%@;\n",sqlSelect];
    [sqlSelect appendString:@"{\n"];
    [sqlSelect appendString:@"__block BOOL res = YES;\n"];
    [sqlSelect appendString:@"FLXKDBHelper *FLXKDB = [FLXKDBHelper shareInstance];\n"];
    [sqlSelect appendString:@"[FLXKDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {\n"];
    [sqlSelect appendFormat:@"if ([db tableExists:@\"%@\"])\n",self.className.text.lowercaseString];
    [sqlSelect appendString:@"{\n"];
    
    [sqlSelect appendString:@" NSString *tableName = NSStringFromClass(self.class);\n"];
    //    [sqlSelect appendFormat:@" NSString *columeAndType = @\"%@\";\n",[self getColumeAndTypeString]];
    [sqlSelect appendString:@"NSString *sql = [NSString stringWithFormat:@\"DROP TABLE IF  EXISTS %%@;\",tableName];\n"];
    [sqlSelect appendString:@"if (![db executeUpdate:sql]) {\n"];
    [sqlSelect appendString:@"res = NO;\n"];
    [sqlSelect appendString:@"*rollback = YES;\n"];
    //    [sqlSelect appendString:@"return;\n"];
    [sqlSelect appendString:@" };\n"];
    
    
    [sqlSelect appendString:@"}\n"];
    
    [sqlSelect appendString:@"}];\n"];
    [sqlSelect appendString:@"return res;\n"];
    [sqlSelect appendString:@"};\n"];
    //    NSLog(sqlSelect);
    [self.allFunctions appendString:sqlSelect];
    
    
}


#pragma mark - util method
-(NSString *)getColumeAndTypeString
{
    NSMutableString* pars = [NSMutableString string];
    NSDictionary *dict = [self getAllProperties];
    
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    NSMutableArray *proTypes = [dict objectForKey:@"type"];
    
    for (int i=0; i< proNames.count; i++) {
        
        //        if (i==0) {
        //            [pars appendFormat:@"%@ %@  PRIMARY KEY ",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        //        }
        //        else{
        //             [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        //        }
        
        [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        
        if(i+1 != proNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}


- (NSDictionary *)getPropertys
{
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    
    Class entity = NSClassFromString(self.className.text);
    
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(entity, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [proNames addObject:propertyName];
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         各种符号对应类型，部分类型在新版SDK中有所变化，如long 和long long
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是@“NSString”
         
         
         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         因为在项目中用的类型不多，故只考虑了少数类型
         */
        if ([propertyType hasPrefix:@"T@"]) {
            [proTypes addObject:SQLTEXT];
        } else if ([propertyType hasPrefix:@"Ti"]||[propertyType hasPrefix:@"TI"]||[propertyType hasPrefix:@"Ts"]||[propertyType hasPrefix:@"TS"]||[propertyType hasPrefix:@"TB"]||[propertyType hasPrefix:@"Tq"]||[propertyType hasPrefix:@"TQ"]) {
            [proTypes addObject:SQLINTEGER];
        } else {
            [proTypes addObject:SQLREAL];
            
        }
        
    }
    free(properties);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}

/** 获取所有属性，包含主键primaryKeyRowIndex */
- (NSDictionary *)getAllProperties
{
    NSDictionary *dict = [self getPropertys];
    
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    [proNames addObjectsFromArray:[dict objectForKey:@"name"]];
    [proTypes addObjectsFromArray:[dict objectForKey:@"type"]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}



@end
