//
//  DataBaseManager.h
//  数据库
//
//  Created by  wyzc02 on 16/11/17.
//  Copyright © 2016年 高炳楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject

@property (nonatomic,strong)NSArray * provinceArray;//省数组
@property (nonatomic,strong)NSArray * provinceIdArray;//省id数组
@property (nonatomic,strong)NSArray * cityArray;//市数组
@property (nonatomic,strong)NSArray * cityIdArray;//市id数组
@property (nonatomic,strong)NSArray * townArray;//区数组
@property (nonatomic,strong)NSArray * townIdArray;//区id数组

/**
 *  打开数据库 1
 */
- (void)openDataBase;

/**
 *  关闭数据库 1
 */
- (void)closeDataBase;

- (void)queryProvinceFromTable:(NSString*)provinceTable;

- (void)queryCityFromTable:(NSString*)cityTable withID:(NSString*)provinceID;

- (void)queryTownFromTable:(NSString*)townTable withID:(NSString*)cityID;
/**
 *  创建数据表 1
 */
//- (void)createTableViewName:(NSString *)name;

////注册
//- (void)insertDataToTableName:(NSString *)table WithName:(NSString *)name password:(NSString *)password;
//
////根据用户名查询密码
//- (void)selectDataFromTableName:(NSString *)table WithName:(NSString *)name;
//
////查询数据库中所有的用户名
//- (void)selectAllNameFromTable:(NSString *)table;
////更新是否记住密码
//- (void)updateDataWithTableName:(NSString *)table name:(NSString *)name;
////修改用户名
//- (void)updateDataWithTableName:(NSString *)table oldName:(NSString *)oldName newName:(NSString *)newName;
//
////修改密码
//- (void)updateDataWithTableName:(NSString *)table oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;
////注销账户
//- (void)deleteFromTableName:(NSString *)table name:(NSString *)name password:(NSString *)password;
////根据用户名查询密码保存状态
//- (void)selectSaveFromTable:(NSString *)table name:(NSString *)name;

















@end
