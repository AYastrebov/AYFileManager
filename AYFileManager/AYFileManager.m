//
//  AYFileManager.m
//  AYFileManager
//
//  Created by Andrey Yastrebov on 18.02.14.
//  Copyright (c) 2014 Andrey Yastrebov. All rights reserved.
//

#import "AYFileManager.h"

@implementation AYFileManager

#pragma mark - Working with dirs and files

+ (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

+ (NSString *)libraryDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    
    return libraryDirectory;
}

+ (NSString *)tmpDirectory
{
    NSString *libraryDirectory = NSTemporaryDirectory();
    
    return libraryDirectory;
}

+ (NSString *)cachesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cashesDirectory = [paths objectAtIndex:0];
    
    return cashesDirectory;
}

+ (BOOL)isPathExists:(NSString *)path
{
    BOOL isDir;
    BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                        isDirectory:&isDir];
    
    if (success && isDir)
    {
        return YES;
    }
    return NO;
}

+ (void)createDirectoryAtParth:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block
{
    if (![AYFileManager isPathExists:path])
    {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
        if (block)
        {
            block(success, error);
        }
    }
}

+ (BOOL)isFileExists:(NSString *)filePath
{
    BOOL isDir;
    BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:filePath
                                                        isDirectory:&isDir];
    
    if (success && !isDir)
    {
        return YES;
    }
    return NO;
}

+ (NSArray *)listFilesAtPath:(NSString *)filePath handler:(void (^)(BOOL success, NSError *error))block
{
    NSError *error;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath
                                                                                    error:&error];
    if (block)
    {
        block(directoryContent ? YES : NO, error);
    }
    return directoryContent;
}

+ (void)deleteFileAtPath:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block
{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    if (block)
    {
        block(success, error);
    }
}

#pragma mark - Saving and Reading Data

+ (void)saveData:(NSData *)data atPath:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block
{
    NSError *error;
    BOOL success = [data writeToFile:path options:NSDataWritingAtomic error:&error];
    
    if (block)
    {
        block(success, error);
    }
}

+ (void)saveDictionary:(NSDictionary *)dictionary asJsonFileAtPath:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block
{
    NSError* error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (!error)
    {
        [AYFileManager saveData:json atPath:path handler:^(BOOL success, NSError *error)
         {
             if (block)
             {
                 block(success, error);
             }
         }];
    }
    else
    {
        if (block)
        {
            block(json ? YES : NO, error);
        }
    }
}

+ (void)saveDictionary:(NSDictionary *)dictionary asPlistFileAtPath:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block
{
    NSError* error;
    NSData *plist = [NSPropertyListSerialization dataWithPropertyList:dictionary
                                                               format:NSPropertyListXMLFormat_v1_0
                                                              options:0
                                                                error:&error];
    
    if (!error)
    {
        [AYFileManager saveData:plist atPath:path handler:^(BOOL success, NSError *error)
         {
             if (block)
             {
                 block(success, error);
             }
         }];
    }
    else
    {
        if (block)
        {
            block(plist ? YES : NO, error);
        }
    }
}

+ (NSData *)loadDataFromFile:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block
{
    NSData *data = nil;
    if ([AYFileManager isFileExists:path])
    {
        NSError *error;
        data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
        
        if (block)
        {
            block(data ? YES : NO, error);
        }
        
    }
    return data;
}

+ (NSDictionary *)loadDictionaryFromFile:(NSString *)path handler:(void (^)(BOOL success, NSError *error))block
{
    NSDictionary *result = nil;
    NSError* error;
    NSData *fileData = [AYFileManager loadDataFromFile:path handler:nil];
    if (fileData)
    {
        if ([path.pathExtension compare:@"json" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            result = [NSJSONSerialization JSONObjectWithData:fileData
                                                     options:kNilOptions
                                                       error:&error];
            if (block)
            {
                block(result ? YES :NO, error);
            }
        }
        else if ([path.pathExtension compare:@"plist" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            NSPropertyListFormat format;
            result = [NSPropertyListSerialization propertyListWithData:fileData
                                                               options:NSPropertyListImmutable
                                                                format:&format
                                                                 error:&error];
            if (block)
            {
                block(result ? YES : NO, error);
            }
        }
    }
    
    return result;
}

#pragma mark - NSCoding

+ (void)saveObject:(id<NSCoding>)object atPath:(NSString *)path withDataKey:(NSString *)key handler:(void (^)(BOOL success, NSError *error))block
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    [AYFileManager saveData:data atPath:path handler:^(BOOL success, NSError *error)
     {
         if (block)
         {
             block(success, error);
         }
     }];
}

+ (id<NSCoding>)objectAtPath:(NSString *)path andDataKey:(NSString *)key handler:(void (^)(BOOL success, NSError *error))block
{
    id<NSCoding> data = nil;
    NSData *codedData = [AYFileManager loadDataFromFile:path handler:^(BOOL success, NSError *error)
                         {
                             if (block)
                             {
                                 block(success, error);
                             }
                         }];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    data = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    
    return data;
}

@end
