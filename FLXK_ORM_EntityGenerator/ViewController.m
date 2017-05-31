//
//  ViewController.m
//  FLXK_ORM_EntityGenerator
//
//  Created by 肖科 on 17/5/24.
//  Copyright © 2017年 com.flxk. All rights reserved.
//

#import "ViewController.h"

//utilities
#import "EntityGeneratorViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    btn.backgroundColor=[UIColor yellowColor];
    [btn addTarget:self action:@selector(showEntityGenerator) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self objCTypeTest];
    
    [self encodeTest];
}

-(void)showEntityGenerator{
    EntityGeneratorViewController* entityGeneratorViewController=[[EntityGeneratorViewController alloc]initWithNibName:@"EntityGeneratorViewController" bundle:nil];
    [self presentViewController:entityGeneratorViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)objCTypeTest{
    
    CGRect a=CGRectMake(50, 50, 50, 50);
    NSValue * av=[NSValue valueWithCGRect:a];
    const char * pObjCType = [((NSValue*)av) objCType];
    NSLog(@"pObjCType %s",pObjCType);//{CGRect={CGPoint=dd}{CGSize=dd}}
    NSLog(@"%@",NSStringFromCGRect(a));
}

-(void)encodeTest{
    NSLog(@"int        : %s", @encode(int));
    NSLog(@"float      : %s", @encode(float));
    NSLog(@"float *    : %s", @encode(float*));
    NSLog(@"char       : %s", @encode(char));
    NSLog(@"char *     : %s", @encode(char *));
    NSLog(@"BOOL       : %s", @encode(BOOL));
    NSLog(@"void       : %s", @encode(void));
    NSLog(@"void *     : %s", @encode(void *));
    
    NSLog(@"NSObject * : %s", @encode(NSObject *));
    NSLog(@"NSObject   : %s", @encode(NSObject));
    NSLog(@"[NSObject] : %s", @encode(typeof([NSObject class])));
    NSLog(@"NSError ** : %s", @encode(typeof(NSError **)));
    
    int intArray[5] = {1, 2, 3, 4, 5};
    NSLog(@"int[]      : %s", @encode(typeof(intArray)));
    
    float floatArray[3] = {0.1f, 0.2f, 0.3f};
    NSLog(@"float[]    : %s", @encode(typeof(floatArray)));
    
    typedef struct _struct {
        short a;
        long long b;
        unsigned long long c;
    } Struct;
    NSLog(@"struct     : %s", @encode(typeof(Struct)));
    
//    2017-05-31 14:26:32.802134 FLXK_ORM_EntityGenerator[366:106681] {{50, 50}, {50, 50}}
//    2017-05-31 14:26:32.802247 FLXK_ORM_EntityGenerator[366:106681] int        : i
//    2017-05-31 14:26:32.802295 FLXK_ORM_EntityGenerator[366:106681] float      : f
//    2017-05-31 14:26:32.802335 FLXK_ORM_EntityGenerator[366:106681] float *    : ^f
//    2017-05-31 14:26:32.802375 FLXK_ORM_EntityGenerator[366:106681] char       : c
//    2017-05-31 14:26:32.802647 FLXK_ORM_EntityGenerator[366:106681] char *     : *
//    2017-05-31 14:26:32.802693 FLXK_ORM_EntityGenerator[366:106681] BOOL       : B
//    2017-05-31 14:26:32.802733 FLXK_ORM_EntityGenerator[366:106681] void       : v
//    2017-05-31 14:26:32.802773 FLXK_ORM_EntityGenerator[366:106681] void *     : ^v
//    2017-05-31 14:26:32.802813 FLXK_ORM_EntityGenerator[366:106681] NSObject * : @
//    2017-05-31 14:26:32.802989 FLXK_ORM_EntityGenerator[366:106681] NSObject   : {NSObject=#}
//    2017-05-31 14:26:32.803065 FLXK_ORM_EntityGenerator[366:106681] [NSObject] : #
//    2017-05-31 14:26:32.803107 FLXK_ORM_EntityGenerator[366:106681] NSError ** : ^@
//    2017-05-31 14:26:32.803171 FLXK_ORM_EntityGenerator[366:106681] int[]      : [5i]
//    2017-05-31 14:26:32.803271 FLXK_ORM_EntityGenerator[366:106681] float[]    : [3f]
//    2017-05-31 14:26:32.803338 FLXK_ORM_EntityGenerator[366:106681] struct     : {_struct=sqQ}
}

@end
