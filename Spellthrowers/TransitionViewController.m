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
@property (weak, nonatomic) IBOutlet UILabel *transitionMessage2;

@property (weak, nonatomic) IBOutlet UILabel *player1Life;
@property (weak, nonatomic) IBOutlet UILabel *player2Life;

@end

@implementation TransitionViewController

//on view load, change the active player and call their turn to be taken
- (void)viewDidLoad
{

    if(self.engine.indexOfTouchedCard > [self.engine.activePlayer.hand count]-1){
        [[self transitionMessage] setText:@"Please pick a valid card!"];
        return;
    }
    //TODO: code logic and return for cards that don't end turn here
    
    NSString *nextPlayerName =[self.engine.players[(self.engine.indexOfActivePlayer+1) % [self.engine.players count]] name];
    
    //set text on screen
    Card *cardPlayed = self.engine.activePlayer.hand[self.engine.indexOfTouchedCard];
    int cardValue = cardPlayed.value;
    [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ hit %@ for %d damage with the %@ card!", self.engine.activePlayer.name, nextPlayerName, cardValue, cardPlayed.name]];
    [[self transitionMessage2] setText: [NSString stringWithFormat: @"%@, it's your turn.",nextPlayerName]];
    
    //run turn and set next player
    [self.engine startTurn];
    
    //set life text after turn is taken
    [self setLife];
    
    [super viewDidLoad];
}

-(void)setLife{
    [[self player1Life] setText: [NSString stringWithFormat: @"%@ Life: %d", [self.engine.activePlayer name], [self.engine.activePlayer life]]];
    [[self player2Life] setText: [NSString stringWithFormat: @"%@ Life: %d", [self.engine.players[(self.engine.indexOfActivePlayer+1)%[self.engine.players count]] name], [self.engine.players[(self.engine.indexOfActivePlayer+1)%[self.engine.players count]] life]]];
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
