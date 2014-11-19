//
//  DBViewController.h
//  Spellthrowers
//
//  Created by Michelle on 18.11.14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface DBViewController : UIViewController {
    UITextField *name;
    UITextField *wins;
    UITextField *losses;
    UILabel *status;
    NSString *databasePath;
    
    sqlite3 *contactDB;
}
@property (retain, nonatomic) IBOutlet UITextField *name;
@property (retain, nonatomic) IBOutlet UITextField *wins;
@property (retain, nonatomic) IBOutlet UITextField *losses;
@property (retain, nonatomic) IBOutlet UILabel *status;
- (IBAction) saveData;
- (IBAction) findContact;
@end