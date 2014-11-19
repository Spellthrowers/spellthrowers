//
//  DBViewController.m
//  Spellthrowers
//
//  Created by Michelle on 18.11.14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "DBViewController.h"

@implementation DBViewController
@synthesize name, wins, losses, status;

- (void) saveData
{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO CONTACTS (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")", name.text, wins.text, losses.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            status.text = @"Contact added";
            name.text = @"";
            wins.text = @"";
            losses.text = @"";
        } else {
            status.text = @"Failed to add contact";
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}

- (void) findContact
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT address, phone FROM contacts WHERE name=\"%@\"", name.text];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                wins.text = addressField;
                
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                losses.text = phoneField;
                
                status.text = @"Match found";
                
                //[addressField release];
                //[phoneField release];
            } else {
                status.text = @"Match not found";
                wins.text = @"";
                losses.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

- (void)viewDidLoad {
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contacts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status.text = @"Failed to create table";
            }
            
            sqlite3_close(contactDB);
            
        } else {
            status.text = @"Failed to open/create database";
        }
    }
    [super viewDidLoad];
}
@end