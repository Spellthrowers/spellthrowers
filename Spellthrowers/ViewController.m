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
@property (atomic) BOOL isAiGame;
@end

@implementation ViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[sender currentTitle] isEqualToString:@"Play Vs AI!"]
        && [[segue destinationViewController] class] == [GameViewController class]) {
        [[segue destinationViewController] setIsAiGame:YES];
        [[segue destinationViewController] setNumPlayers: 2];
    }
    else if ([[sender currentTitle] containsString:@"Player!"]
              && [[segue destinationViewController] class] != [HelpViewController class]){
        [[segue destinationViewController] setNumPlayers: [[[sender currentTitle] substringToIndex: 1] intValue]];
    }
    else if ([[segue destinationViewController] class] == [HelpViewController class]) {
        [[segue destinationViewController] setIsMainMenu:YES];
    }
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
