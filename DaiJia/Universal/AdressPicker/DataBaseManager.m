//
//  DataBaseManager.m
//  数据库
//
//  Created by  wyzc02 on 16/11/17.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import "DataBaseManager.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface DataBaseManager ()


@property (nonatomic, strong)NSMutableArray * provinceArray1;
@property (nonatomic,strong)NSMutableArray * cityArray1;
@property (nonatomic,strong)NSMutableArray * townArray1;
@property (nonatomic, strong)NSMutableArray * provinceIdArray1;
@property (nonatomic,strong)NSMutableArray * cityIdArray1;
@property (nonatomic,strong)NSMutableArray * townIdArray1;


@property (nonatomic,strong)FMDatabase * database;


@end
@implementation DataBaseManager
- (NSArray *)provinceArray{
    return _provinceArray1;
}
- (NSArray *)cityArray{
    return _cityArray1;
}
- (NSArray *)townArray{
    return _townArray1;
}
- (NSArray *)provinceIdArray{
    return _provinceIdArray1;
}
- (NSArray *)cityIdArray{
    return _cityIdArray1;
}
- (NSArray *)townIdArray{
    return _townIdArray1;
}
-(instancetype)init{
    if (self = [super init]) {
        _provinceArray1 = [NSMutableArray array];
        _cityArray1 = [NSMutableArray array];
        _townArray1 = [NSMutableArray array];
        _provinceIdArray1 = [NSMutableArray array];
        _cityIdArray1 = [NSMutableArray array];
        _townIdArray1 = [NSMutableArray array];
    }
    return self;
}
//获取数据库地址
- (NSString *)dataBasePath{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Community" ofType:@"sqlite"];
    NSLog(@"%@",path);
    return path;
    
}
//打开数据库
- (void)openDataBase{
    NSString * path = [self dataBasePath];
    _database = [FMDatabase databaseWithPath:path];
    BOOL open = [_database open];
    if (open) {
        NSLog(@"数据库打开成功");
    }
}
//关闭数据库
- (void)closeDataBase{
    BOOL close = [_database close];
    if (close) {
        NSLog(@"数据库关闭成功");
    }
}
- (void)queryProvinceFromTable:(NSString *)provinceTable{
        [self openDataBase];
        NSString * sql = [NSString stringWithFormat:@"select name , id from %@",provinceTable];
        FMResultSet * result = [_database executeQuery:sql];
        while (result.next) {
            NSString * name = [result stringForColumn:@"name"];
            [_provinceArray1 addObject:name];
            int ID = [result intForColumn:@"id"];
            [_provinceIdArray1 addObject:[NSString stringWithFormat:@"%d",ID]];
        }
        [self closeDataBase];
}
- (void)queryCityFromTable:(NSString *)cityTable withID:(NSString *)provinceID{
    [self openDataBase];
    NSString * sql = [NSString stringWithFormat:@"select name , id from %@ where provinceId = '%@'",cityTable,provinceID];
    FMResultSet * result = [_database executeQuery:sql];
    while (result.next) {
        NSString * name = [result stringForColumn:@"name"];
        [_cityArray1 addObject:name];
        int ID = [result intForColumn:@"id"];
        [_cityIdArray1 addObject:[NSString stringWithFormat:@"%d",ID]];
    }
    [self closeDataBase];
}
- (void)queryTownFromTable:(NSString *)townTable withID:(NSString *)cityID{
    [self openDataBase];
    NSString * sql = [NSString stringWithFormat:@"select name , id from %@ where cityId = '%@'",townTable,cityID];
    FMResultSet * result = [_database executeQuery:sql];
    while (result.next) {
        NSString * name = [result stringForColumn:@"name"];
        [_townArray1 addObject:name];
        int ID = [result intForColumn:@"id"];
        [_townIdArray1 addObject:[NSString stringWithFormat:@"%d",ID]];
    }
    [self closeDataBase];
}
////创建表
//- (void)createTableViewName:(NSString *)name{
//    [self openDataBase];
//    NSString * createTabelSql = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoincrement not null, name text,password text,save text)",name];
//    BOOL c1 = [_database executeUpdate:createTabelSql];
//    if (c1) {
//        NSLog(@"创建表成功");
//    }
//    [self closeDataBase];
//}
////注册
//- (void)insertDataToTableName:(NSString *)table WithName:(NSString *)name password:(NSString *)password{
//    [self openDataBase];
//    NSString * sql = [NSString stringWithFormat:@"insert into %@(name,password,save)values('%@','%@','否')",table,name,password];
//    BOOL inflag1 = [_database executeUpdate:sql];
//    if (inflag1) {
//        NSLog(@"注册成功");
//    }else{
//        NSLog(@"error = %@", [_database lastErrorMessage]);
//    }
//    [self closeDataBase];
//}
////更新是否记住密码
//- (void)updateDataWithTableName:(NSString *)table name:(NSString *)name{
//    [self openDataBase];
//    NSString * sql = [NSString stringWithFormat:@"update %@ set save = '是' where name = '%@'",table,name];
//    BOOL i = [_database executeUpdate:sql];
//    if (i) {
//        NSLog(@"记住密码保存成功");
//    }else{
//        NSLog(@"error = %@", [_database lastErrorMessage]);
//    }
//    [self closeDataBase];
//    
//}
//
////根据用户名查询密码
//- (void)selectDataFromTableName:(NSString *)table WithName:(NSString *)name{
//    [self openDataBase];
//    NSString * sql = [NSString stringWithFormat:@"select * from %@ where name = '%@'",table,name];
//    FMResultSet * result = [_database executeQuery:sql];
//    while (result.next) {
//        
//        
//        NSString * password = [result stringForColumn:@"password"];
//        
//        //NSLog(@"%@",password);
//        
//        [_passArray addObject:password];
//        //NSLog(@"%@",_passArray);
//        
//    }
//    [self closeDataBase];
//
//}
////根据用户名查询是否记住密码
//- (void)selectSaveFromTable:(NSString *)table name:(NSString *)name{
//    [self openDataBase];
//    NSString * sql = [NSString stringWithFormat:@"select save from %@ where name = '%@'",table,name];
//    FMResultSet * result = [_database executeQuery:sql];
//    while (result.next) {
//        
//        
//        NSString * save = [result stringForColumn:@"save"];
//        
//        
//        [_saveArray1 addObject:save];
//        //NSLog(@"%@",_saveArray1);
//        
//    }
//    [self closeDataBase];
//    
//
//}
////查询所有的用户名
//- (void)selectAllNameFromTable:(NSString *)table{
//    [self openDataBase];
//    NSString * sql = [NSString stringWithFormat:@"select name from %@",table];
//    FMResultSet * result = [_database executeQuery:sql];
//    while (result.next) {
//                
//        NSString * name = [result stringForColumn:@"name"];
//        
//        //NSLog(@"%@",name);
//        
//        [_nameArray addObject:name];
//        
//    }
//    [self closeDataBase];
//}
////修改用户名
//- (void)updateDataWithTableName:(NSString *)table oldName:(NSString *)oldName newName:(NSString *)newName{
//    [self openDataBase];
//    NSString * sql = [NSString stringWithFormat:@"update %@ set name = '%@' where name = '%@'",table,newName,oldName];
//    BOOL i = [_database executeUpdate:sql];
//    if (i) {
//        NSLog(@"用户名修改成功");
//    }else{
//        NSLog(@"error = %@", [_database lastErrorMessage]);
//    }
//    [self closeDataBase];
//}
////修改密码
//- (void)updateDataWithTableName:(NSString *)table oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword{
//    [self openDataBase];
//    NSString * sql = [NSString stringWithFormat:@"update %@ set password = '%@' where password = '%@'",table,newPassword,oldPassword];
//    BOOL i = [_database executeUpdate:sql];
//    if (i) {
//        NSLog(@"密码修改成功");
//    }else{
//        NSLog(@"error = %@", [_database lastErrorMessage]);
//    }
//    [self closeDataBase];
//}
////注销账户
//- (void)deleteFromTableName:(NSString *)table name:(NSString *)name password:(NSString *)password{
//    [self openDataBase];
//    NSString * sql = [NSString stringWithFormat:@"delete from %@ where name = '%@' and password = '%@' and save = '否'",table,name,password];
//    BOOL i = [_database executeUpdate:sql];
//    if (i) {
//        NSLog(@"账户注销成功");
//    }else{
//        NSLog(@"error = %@", [_database lastErrorMessage]);
//    }
//    [self closeDataBase];
//}
//
//
//- (NSArray *)allNameArray{
//    return _nameArray;
//}
//- (NSArray *)passwordArray{
//    return _passArray;
//}
//- (NSArray *)allDataArray{
//    return _dataArray;
//}
//- (NSArray *)saveArray{
//    return _saveArray1;
//}
@end








