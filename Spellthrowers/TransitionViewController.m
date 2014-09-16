//
//  TransitionViewController.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/14/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "TransitionViewController.h"

@interface TransitionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *transitionMessage;

@end

@implementation TransitionViewController

//on view load, change the active player and call their turn to be taken
- (void)viewDidLoad
{
    [self.engine startTurn];
    [[self transitionMessage] setText: [NSString stringWithFormat: @"Index hit: %d. %@, it is your turn!", self.engine.indexOfTouchedCard, self.engine.activePlayer.name]];
    [super viewDidLoad];
}

//use this to store info before leaving the view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [[segue destinationViewController] setEngine:self.engine];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
