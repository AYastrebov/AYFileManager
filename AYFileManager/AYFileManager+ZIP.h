//
//  AYFileManager+ZIP.h
//  AYFileManager
//
//  Created by Andrey Yastrebov on 18.02.14.
//  Copyright (c) 2014 Andrey Yastrebov. All rights reserved.
//

#import "AYFileManager.h"

@interface AYFileManager (ZIP)

/*
 Unzip file at given path to given destination with success handler
 */
+ (void)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination handler:(void (^)(BOOL success))block;

/*
 Create zip file at given path with given file paths with success handler
 */
+ (void)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray *)filenames handler:(void (^)(BOOL success))block;

@end
