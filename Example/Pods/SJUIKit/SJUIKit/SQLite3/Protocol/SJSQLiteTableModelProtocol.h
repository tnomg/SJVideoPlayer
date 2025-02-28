//
//  SJSQLiteTableModelProtocol.h
//  Pods-SJSQLite3_Example
//
//  Created by 畅三江 on 2019/7/26.
//  Copyright © 2019 changsanjiang. All rights reserved.
//

#ifndef SJSQLiteTableModelProtocol_h
#define SJSQLiteTableModelProtocol_h

NS_ASSUME_NONNULL_BEGIN
@protocol SJSQLiteTableModelProtocol<NSObject>
@required
/// 主键
///
/// e.g. return @"id";
///
+ (nullable NSString *)sql_primaryKey;

@optional
/// 自增键
///
/// e.g. return @[ @"id", @"idx" ];
///
+ (nullable NSArray<NSString *> *)sql_autoincrementlist;

/// 数组容器泛型
///
/// e.g. return @{ @"items":Item.class };
///
+ (nullable NSDictionary<NSString *, Class<SJSQLiteTableModelProtocol>> *)sql_containerPropertyGenericClass;

/// 自定义映射字段
///
/// e.g. return @{ @"id":@"itemId" };
///
+ (nullable NSDictionary<NSString *, NSString *> *)sql_customKeyMapper;

/// 白名单
///
/// e.g. return @[ @"white" ];
///
+ (nullable NSArray<NSString *> *)sql_whitelist;

/// 黑名单
///
/// e.g. return @[ @"black" ];
///
+ (nullable NSArray<NSString *> *)sql_blacklist;

/// 不可为空的字段
///
/// e.g. return @[ @"age" ];
///
+ (nullable NSArray<NSString *> *)sql_notnulllist;

/// 自定义表名
///
+ (nullable NSString *)sql_tableName;
@end
NS_ASSUME_NONNULL_END
#endif /* SJSQLiteTableModelProtocol_h */
