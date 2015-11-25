//
//  ViewController.m
//  mmw
//
//  Created by 董博 on 15/11/25.
//  Copyright © 2015年 lord. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#else
#define debugLog(...)
#endif


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //路径
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *mmwPath = [paths stringByAppendingPathComponent:@"mmw.sql"];
    
    //创建资料库
    FMDatabase *db = [FMDatabase databaseWithPath:mmwPath];
    
    if (![db open]) {
        NSLog(@"fail");
        return;
    }
    //建立table
    BOOL isSql = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS mmwSql (id integer PRIMARY KEY, Name text NOT NULL, Age integer NOT NULL, Sex integer NOT NULL, Phone text NOT NULL, Address text NOT NULL)"];
    debugLog(@"isSql = %d", isSql);
    
    //插入资料
    BOOL isSave = [db executeUpdate:@"INSERT INTO mmwSql (Name, Age, Sex, Phone, Address) VALUES(?,?,?,?,?)", @"mwb", [NSNumber numberWithInt:26], [NSNumber numberWithInt:0], @"13693624243", @"hebei China"];
    debugLog(@"isSave = %d", isSave);
    //改资料
    BOOL isChange = [db executeUpdate:@"UPDATE mmwSql SET Age = ? WHERE Name = ?", [NSNumber numberWithInt:22], @"mwb"];
    debugLog(@"isChange = %d", isChange);
    //查询
    FMResultSet *rs = [db executeQuery:@"SELECT Name, Phone, Age FROM mmwSql"];
    //遍历
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"Name"];
        NSString *phone = [rs stringForColumn:@"Phone"];
        int age = [rs intForColumn:@"Age"];
        debugLog(@"name = %@ phone = %@, age = %d", name, phone, age);
    }
    [rs close];
    //快速取得资料
    NSString *address = [db stringForQuery:@"SELECT Address FROM mmwSql WHERE Name = ?", @"mwb"];
    debugLog(@"address = %@", address);
    int age = [db intForQuery:@"SELECT Age FROM mmwSql WHERE Name = ?", @"mwb"];
    debugLog(@"age = %d", age);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
