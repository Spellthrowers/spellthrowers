//
//  DBManager.m
//  Spellthrowers
//
//  Created by Michelle on 18.11.14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DataBaseManager : NSObject{
    NSString *databasePath;
}
+(DataBaseManager*)getInstance;
-(BOOL)createDB;

@end

static DataBaseManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;


@implementation DataBaseManager

+(DataBaseManager*)getInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory path
    dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"Leaderboards.db"]];
    BOOL isSuccess = YES;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO){
        const char *dbpath = [databasePath UTF8String];
        
        //Open the database connection
        if (sqlite3_open(dbpath, &database) == SQLITE_OK){
            char *errMsg;
            const char *sql_stmt =
            
            "create table if not exists EMPLOYEE (employeeID integer primary key NOT NULL, employeeName text NOT NULL, employeeImage blob, employeePhoneNumber text NOT NULL);";
            
            //Execute the query
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK){
                isSuccess = NO;
            }
            sqlite3_close(database);
            return isSuccess;
        }
        else {
            isSuccess = NO;
        }
    }
    return isSuccess;
}

@end