//
//  GameViewController.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/13/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "GameViewController.h"
#import "Deck.h"
#import "Card.h"
#import "Engine.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cardName0;
@property (weak, nonatomic) IBOutlet UILabel *cardName1;
@property (weak, nonatomic) IBOutlet UILabel *cardName2;
@property (weak, nonatomic) IBOutlet UILabel *cardName3;
@property (weak, nonatomic) IBOutlet UILabel *cardName4;

@property (weak, nonatomic) IBOutlet UILabel *cardValue0;
@property (weak, nonatomic) IBOutlet UILabel *cardValue1;
@property (weak, nonatomic) IBOutlet UILabel *cardValue2;
@property (weak, nonatomic) IBOutlet UILabel *cardValue3;
@property (weak, nonatomic) IBOutlet UILabel *cardValue4;

@property Engine* engine;

@end

@implementation GameViewController
- (IBAction)drawClicked:(id)sender {
    Card *drawn0 = self.engine.activePlayer.deck.draw;
    [[self cardName0] setText: [drawn0 name]];
    [[self cardValue0] setText: [NSString stringWithFormat:@"%d", drawn0.value]];
    
    Card *drawn1 = self.engine.activePlayer.deck.draw;
    [[self cardName1] setText: [drawn1 name]];
    [[self cardValue1] setText: [NSString stringWithFormat:@"%d", drawn1.value]];
    
    Card *drawn2 = self.engine.activePlayer.deck.draw;
    [[self cardName2] setText: [drawn2 name]];
    [[self cardValue2] setText: [NSString stringWithFormat:@"%d", drawn2.value]];
    
    Card *drawn3 = self.engine.activePlayer.deck.draw;
    [[self cardName3] setText: [drawn3 name]];
    [[self cardValue3] setText: [NSString stringWithFormat:@"%d", drawn3.value]];
    
    Card *drawn4 = self.engine.activePlayer.deck.draw;
    [[self cardName4] setText: [drawn4 name]];
    [[self cardValue4] setText: [NSString stringWithFormat:@"%d", drawn4.value]];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.engine = [Engine newEngine];
    //[engine initEverything];
    Deck *deck = [Deck newDeck];
    Player *player1 = [Player newPlayer:deck];
    Player *player2 = [Player newPlayer:deck];
    
    [self.engine addPlayer:(player1)];
    [self.engine addPlayer:(player2)];
    NSLog(@"List of players: %@", [self.engine players]);
    
    //Set activePlayer
    self.engine.indexOfActivePlayer = 1;
    self.engine.activePlayer = [self.engine.currentPlayers objectAtIndex:self.engine.indexOfActivePlayer];
    NSLog(@"activePlayer: %@", [self.engine activePlayer]);
    
    NSLog(@"*TURN*");
    [self.engine nextPlayer];
    NSLog(@"activePlayer: %@", [self.engine activePlayer]);
    
    [player1 fillHand:deck];
    [player1 displayHand];
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
