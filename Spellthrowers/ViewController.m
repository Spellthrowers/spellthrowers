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
#import "GameTabBarViewController.h"

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
              && [[segue destinationViewController] class] == [GameViewController class]){
        [[segue destinationViewController] setNumPlayers: [[[sender currentTitle] substringToIndex: 1] intValue]];
    }
    else if ([[segue destinationViewController] class] == [GameTabBarViewController class]) {
        [[segue destinationViewController] setIsMainMenu:YES];
    }
}

- (void)viewDidLoad
{
    
    
    //WINS
    defaults = [NSUserDefaults standardUserDefaults];
    NSInteger currentWins = [defaults integerForKey:@"Wins"];
    
    if (currentWins == (long)Nil){
        [defaults setInteger:0 forKey:@"Wins"];
        [defaults synchronize];
    }
    
    //gets currentWins {DISPLAY ON HOME}
    defaults = [NSUserDefaults standardUserDefaults];
    currentWins = [defaults integerForKey:@"Wins"];
    [[self winsLabel] setText: [NSString stringWithFormat: @"Wins: %ld", (long)currentWins]];
    
    //updates currentWins {UPDATE AFTER GAME ENDS//Now in Engine}
    //currentWins+=1;
    //[defaults setInteger:currentWins forKey:@"Wins"];
    //[defaults synchronize];
    
    //gets new currentWins {FOR DEBUG PURPOSES}
    //defaults = [NSUserDefaults standardUserDefaults];
    //currentWins = [defaults integerForKey:@"Wins"];
    //NSLog(@"%ld", (long)currentWins);
    
    
    //LOSSES
    defaults = [NSUserDefaults standardUserDefaults];
    NSInteger currentLosses = [defaults integerForKey:@"Losses"];
    
    if (currentLosses == (long)Nil){
        [defaults setInteger:0 forKey:@"Losses"];
        [defaults synchronize];
    }
    
    //gets currentLosses {DISPLAY ON HOME}
    defaults = [NSUserDefaults standardUserDefaults];
    currentLosses = [defaults integerForKey:@"Losses"];
    [[self lossesLabel] setText: [NSString stringWithFormat: @"Losses: %ld", (long)currentLosses]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
