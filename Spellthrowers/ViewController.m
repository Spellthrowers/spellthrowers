//
//  ViewController.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/6/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "HelpViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versus;

@end

@implementation ViewController
- (IBAction)changeMode:(id)sender {
    NSString *contents = [[self versus] text];
    if ([contents caseInsensitiveCompare:@"Vs AI"] == NSOrderedSame) {
        [[self versus] setText: @"Vs Human"];
    } else {
        [[self versus] setText: @"Vs AI"];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[[self versus] text] isEqualToString:@"Vs AI"] && [[segue destinationViewController] class] != [HelpViewController class]) {
        [[segue destinationViewController] setIsAiGame:YES];
    }
    [[segue destinationViewController] setIsMainMenu:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
