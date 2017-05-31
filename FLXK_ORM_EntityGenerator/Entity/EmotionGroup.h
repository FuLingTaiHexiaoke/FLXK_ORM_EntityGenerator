//
//  TestEntity.h
//  Psy-TeachersTerminal
//
//  Created by apple on 2016/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EmotionGroup : NSObject
//@property(nonatomic,assign)NSInteger id;
//@property(nonatomic,strong)NSString* emotionGroupName;
//@property(nonatomic,assign)NSInteger emotionGroupImageType;
//@property(nonatomic,assign)NSInteger emotionGroupPerPageCount;
//@property(nonatomic,assign)NSInteger emotionGroupPerPageColunms;
//@property(nonatomic,assign)NSInteger emotionGroupPerPageLines;
//@property(nonatomic,assign)NSInteger emotionGroupPerPageItemWidth;
//@property(nonatomic,assign)NSInteger emotionGroupIsShowingDeleteButton;
//@property(nonatomic,strong)NSString* emotionGroupImageUrl;

@property(nonatomic,assign)NSDate* emotionGroupPerPageItemWidth31;
@property(nonatomic,assign)NSData* emotionGroupPerPageItemWidth32;
@property(nonatomic,assign)CGPoint emotionGroupIsShowingDeleteButton23;//T{CGRect={CGPoint=dd}{CGSize=dd}}
@property(nonatomic,assign)CGSize emotionGroupIsShowingDeleteButton22;//T{CGRect={CGPoint=dd}{CGSize=dd}}
@property(nonatomic,assign)CGFloat emotionGroupIsShowingDeleteButton21;//T{CGRect={CGPoint=dd}{CGSize=dd}}
@property(nonatomic,assign)CGRect emotionGroupIsShowingDeleteButton2;//T{CGRect={CGPoint=dd}{CGSize=dd}}
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)char emotionGroupName;//Tc
@property(nonatomic,assign)int emotionGroupImageType;//Ti
@property(nonatomic,assign)long emotionGroupPerPageCount;//Tq
@property(nonatomic,assign)short emotionGroupPerPageColunms;//Ts
@property(nonatomic,assign)double emotionGroupPerPageLines;//Td
@property(nonatomic,assign)float emotionGroupPerPageItemWidth;//Tf
@property(nonatomic,assign)long long emotionGroupPerPageColunms1;//Tq
@property(nonatomic,assign)BOOL emotionGroupPerPageLines1;//TB
@property(nonatomic,assign)NSNumber* emotionGroupPerPageItemWidth1;//T@"NSNumber"
@property(nonatomic,assign)NSValue* emotionGroupPerPageItemWidth2;//T@"NSValue"
@property(nonatomic,assign)NSValue* emotionGroupPerPageItemWidth3;
@property(nonatomic,assign)CGFloat emotionGroupIsShowingDeleteButton;//Td
@property(nonatomic,strong)NSString* emotionGroupImageUrl;//T@"NSString"

//c char         C unsigned char
//i int          I unsigned int
//l long         L unsigned long
//s short        S unsigned short
//d double       D unsigned double
//f float        F unsigned float
//q long long    Q unsigned long long
//B BOOL

//createTable
+ (BOOL)createTable
;
//dropTable
+ (BOOL)dropTable
;
//selectAll
+ (NSArray<EmotionGroup*> *)selectAll
;
//selectByCriteria
+ (NSArray<EmotionGroup*> *)selectByCriteria:(NSString *)criteria
;
//insertWithObject:
+ (BOOL)insertWithObject:(EmotionGroup*)obj success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)insertWithObjects:(NSArray<EmotionGroup*>*)objs success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)updateObject:(EmotionGroup*)obj withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)updateObjects:(NSArray<EmotionGroup*>*)objs withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)deleteWithWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)clearTableSuccess:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;


@end
