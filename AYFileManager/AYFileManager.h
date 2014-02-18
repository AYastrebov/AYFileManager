//
//  AYFileManager.h
//  AYFileManager
//
//  Created by Andrey Yastrebov on 18.02.14.
//  Copyright (c) 2014 Andrey Yastrebov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYFileManager : NSObject

/*
 Use this directory to store critical user documents and app data files.
 Critical data is any data that cannot be recreated by your app, such as user-generated content.
 The contents of this directory can be made available to the user through file sharing.
 The contents of this directory are backed up by iTunes.
 */
+ (NSString *)documentsDirectory;

/*
 This directory is the top-level directory for files that are not user data files.
 You typically put files in one of several standard subdirectories but you can also create custom subdirectories for files you want backed up but not exposed to the user.
 You should not use this directory for user data files.
 */
+ (NSString *)libraryDirectory;

/*
 Use this directory to write temporary files that do not need to persist between launches of your app.
 Your app should remove files from this directory when it determines they are no longer needed.
 (The system may also purge lingering files from this directory when your app is not running.)
 */
+ (NSString *)tmpDirectory;

/*
 Caches directory. Not backed up with iTunes.
 */
+ (NSString *)cachesDirectory;

/*
 Checks if directory exists at given path.
 */
+ (BOOL)isPathExists:(NSString *)path;

/*
 Creates directory at given path if it is not exists.
 */
+ (void)createDirectoryAtParth:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block;

/*
 Checks if file exists at given path.
 */
+ (BOOL)isFileExists:(NSString *)filePath;

/*
 List files at given path.
 */
+ (NSArray *)listFilesAtPath:(NSString *)filePath handler:(void (^)(BOOL success, NSError *error))block;

/*
 Saving NSData at given path
 */
+ (void)saveData:(NSData *)data atPath:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block;

/*
 Saving NSDictionary at given path as a .json file
 */
+ (void)saveDictionary:(NSDictionary *)dictionary asJsonFileAtPath:(NSString *)path  handler:(void (^)(BOOL success, NSError *error))block;

/*
 Saving NSDictionary at given path as a .plist file
 */
+ (void)saveDictionary:(NSDictionary *)dictionary asPlistFileAtPath:(NSString *)path  handler:(void (^)(BOOL success, NSError *error))block;

/*
 Loading NSData from file path
 */
+ (NSData *)loadDataFromFile:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block;

/*
 Loading NSDictionary from file path
 */
+ (NSDictionary *)loadDictionaryFromFile:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block;

/*
 Delete file at path
 */
+ (void)deleteFileAtPath:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block;

/*
 Saving <NSCoding> object with key at given path
 */
+ (void)saveObject:(id<NSCoding>)object atPath:(NSString *)path withDataKey:(NSString *)key  handler:(void (^)(BOOL success, NSError *error))block;

/*
 Loading <NSCoding> object with key at given path
 */
+ (id<NSCoding>)objectAtPath:(NSString *)path andDataKey:(NSString *)key  handler:(void (^)(BOOL success, NSError *error))block;

@end
