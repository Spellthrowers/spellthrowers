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
@property (weak, nonatomic) IBOutlet UIButton *ready;
@property (weak, nonatomic) IBOutlet UIButton *passToAi;
@property (weak, nonatomic) IBOutlet UIButton *returnHome;

@property (weak, nonatomic) IBOutlet UILabel *player1Life;
@property (weak, nonatomic) IBOutlet UILabel *player2Life;

@end

@implementation TransitionViewController

//on view load, change the active player and call their turn to be taken
- (void)viewDidLoad
{
    [self returnHome].hidden = YES;

    if(self.engine.indexOfTouchedCard > [self.engine.activePlayer.hand count]-1){
        [[self transitionMessage] setText:@"Please pick a valid card!"];
        return;
    }
    
    
    //TODO: code logic and return for cards that don't end turn here
    
    NSString *nextPlayerName =[self.engine.players[(self.engine.indexOfActivePlayer+1) % [self.engine.players count]] name];
    
    //set text based on card type
    [self setMainText];
    
    [[self transitionMessage2] setText: [NSString stringWithFormat: @"%@, it's your turn.",nextPlayerName]];
    
    //run turn and set next player
    [self.engine startTurn];
    
    
    //if the game is over
    if (self.engine.winner != NULL) {
        //send alert
        UIAlertView *playAlert = [[UIAlertView alloc] initWithTitle:@"Game Over" message: [NSString stringWithFormat:@"%@ won!", [self.engine.currentPlayers[0] name]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [playAlert show];
        
        [[self transitionMessage2] setText:@"Game Over"];
        
        //give option to return home
        [self passToAi].hidden = YES;
        [self ready].hidden = YES;
        [self returnHome].hidden = NO;
    }
    else if(self.engine.activePlayer.isAi){
        [self passToAi].hidden = NO;
        [self ready].hidden = YES;
    }
    else{
        [self passToAi].hidden = YES;
        [self ready].hidden = NO;
    }
    
    //set life text after turn is taken
    [self setLife];
    
    [super viewDidLoad];
}

-(void)setLife{
    [[self player1Life] setText: [NSString stringWithFormat: @"%@ Life: %d", [self.engine.players[0] name], [self.engine.players[0] life]]];
    [[self player2Life] setText: [NSString stringWithFormat: @"%@ Life: %d", [self.engine.players[1] name], [self.engine.players[1] life]]];
}

-(void)setMainText{
    
    //simplification vars
    NSString *nextPlayerName =[self.engine.players[(self.engine.indexOfActivePlayer+1) % [self.engine.players count]] name];
    Card *cardPlayed = self.engine.activePlayer.hand[self.engine.indexOfTouchedCard];
    int cardValue = cardPlayed.value;
    
    if([cardPlayed.cardType isEqualToString:@"Attack"]){
        [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ hit %@ for %d damage with the %@ card!", self.engine.activePlayer.name, nextPlayerName, cardValue, cardPlayed.name]];
    }
    else if ([cardPlayed.cardType isEqualToString:@"EMP"]){
        //get how many weapons enemies hold
        int numWeaponsRemoved = 0;
        for (Player *p in self.engine.currentPlayers) {
            if(p != self.engine.activePlayer){
                for (Card *card in p.hand) {
                    if([[card cardType] isEqualToString:@"Weapon"]){
                        numWeaponsRemoved++;
                    }
                }
            }
        }
        
        //set text on transition screen. Singular and plural weapon removal.
        if (numWeaponsRemoved == 1) {
            [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ used an EMP card! %i weapon was removed from enemy hands!", self.engine.activePlayer.name, numWeaponsRemoved]];
        }
        else{
            [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ used an EMP card! %i weapons were removed from enemy hands!", self.engine.activePlayer.name, numWeaponsRemoved]];
        }
    }
    else if([cardPlayed.cardType isEqualToString:@"Weapon"]){
        int damage = 0;
        int numHits = 0;
        NSString *s = [NSString stringWithFormat: @"%@ hit %@ for ", self.engine.activePlayer.name, nextPlayerName];
        for (Card* card in self.engine.activePlayer.hand) {
            if([card.cardType isEqualToString:@"Weapon"]){
                damage+= card.value;
                numHits++;
            }
        }
        s = [NSString stringWithFormat:@"%@ %d damage with the", s, damage];
        //used for string building
        int tempNumHits = numHits;
        for (Card* card in self.engine.activePlayer.hand) {
            if([card.cardType isEqualToString:@"Weapon"]){
                if(numHits == 1){
                    s = [NSString stringWithFormat:@"%@ %@ card!", s, card.name];
                }
                else if(tempNumHits == 1 && numHits == 2){
                    s = [NSString stringWithFormat:@"%@ and %@ cards!", s, card.name];
                }
                else if(tempNumHits == 2 && numHits == 2){
                    s = [NSString stringWithFormat:@"%@ %@", s, card.name];
                    tempNumHits--;
                }
                else if(tempNumHits == 1){
                    s = [NSString stringWithFormat:@"%@, and %@ cards!", s, card.name];
                }
                else if(tempNumHits == numHits){
                    s = [NSString stringWithFormat:@"%@ %@", s, card.name];
                    tempNumHits--;
                }
                else{
                    s = [NSString stringWithFormat:@"%@, %@", s, card.name];
                    tempNumHits--;
                }
            }
        }
        [[self transitionMessage] setText: s];
    }
}

//use this to store info before leaving the view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (self.engine.winner == NULL) {
        [[segue destinationViewController] setEngine:self.engine];
    }
    [segue destinationViewController];
}

- (IBAction)passToAiPressed:(id)sender {
    [self.engine setIndexOfTouchedCard: self.engine.getAiRecommendedCardIndex];
    [self viewDidLoad];
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
