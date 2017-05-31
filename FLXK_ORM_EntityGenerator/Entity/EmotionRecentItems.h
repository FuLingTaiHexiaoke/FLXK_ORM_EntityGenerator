//
//  TestEntity.h
//  Psy-TeachersTerminal
//
//  Created by apple on 2016/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmotionRecentItems : NSObject
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString* emotionItemName;
@property(nonatomic,strong)NSString* emotionItemSmallImageUrl;
@property(nonatomic,strong)NSString* emotionItemNormalImageUrl;
@property(nonatomic,strong)NSString* emotionItemGifImageUrl;
@property(nonatomic,assign)NSInteger emotionItemImageType;//0:normal 1:gif
@property(nonatomic,assign)NSInteger groupId;


//createTable
+ (BOOL)createTable
;
//dropTable
+ (BOOL)dropTable
;
//selectAll
+ (NSArray<EmotionRecentItems*> *)selectAll
;
//selectByCriteria
+ (NSArray<EmotionRecentItems*> *)selectByCriteria:(NSString *)criteria
;
//insertWithObject:
+ (BOOL)insertWithObject:(EmotionRecentItems*)obj success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)insertWithObjects:(NSArray<EmotionRecentItems*>*)objs success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)updateObject:(EmotionRecentItems*)obj withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)updateObjects:(NSArray<EmotionRecentItems*>*)objs withWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)deleteWithWhereString:(NSString*)where success:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;
//insertWithObject:
+ (BOOL)clearTableSuccess:(void(^)())success failure:(void(^)(NSString* errorDescripe))failure
;

@end
