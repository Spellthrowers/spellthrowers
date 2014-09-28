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

@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *player1Life;
@property (weak, nonatomic) IBOutlet UILabel *player2Life;
@property (weak, nonatomic) IBOutlet UIButton *discardAndDraw;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *drawNewCards;
@property (weak, nonatomic) IBOutlet UILabel *faceDownActivated;


@property (weak, nonatomic) IBOutlet UIButton *playCard0;
@property (weak, nonatomic) IBOutlet UIButton *playCard1;
@property (weak, nonatomic) IBOutlet UIButton *playCard2;
@property (weak, nonatomic) IBOutlet UIButton *playCard3;
@property (weak, nonatomic) IBOutlet UIButton *playCard4;

@property (weak, nonatomic) IBOutlet UIButton *discard0;
@property (weak, nonatomic) IBOutlet UIButton *discard1;
@property (weak, nonatomic) IBOutlet UIButton *discard2;
@property (weak, nonatomic) IBOutlet UIButton *discard3;
@property (weak, nonatomic) IBOutlet UIButton *discard4;

@property (nonatomic, strong) Engine* engine;

@end

@implementation GameViewController
- (void)displayHand {
    [[self header] setText: [NSString stringWithFormat:@"%@, pick a card!", self.engine.activePlayer.name]];
    
    Card *drawn0 = self.engine.activePlayer.hand[0];
    [[self cardName0] setText: [drawn0 name]];
    [[self cardValue0] setText: [NSString stringWithFormat:@"%d", drawn0.value]];
    
    Card *drawn1 = self.engine.activePlayer.hand[1];
    [[self cardName1] setText: [drawn1 name]];
    [[self cardValue1] setText: [NSString stringWithFormat:@"%d", drawn1.value]];
    
    Card *drawn2 = self.engine.activePlayer.hand[2];
    [[self cardName2] setText: [drawn2 name]];
    [[self cardValue2] setText: [NSString stringWithFormat:@"%d", drawn2.value]];
    
    Card *drawn3 = self.engine.activePlayer.hand[3];
    [[self cardName3] setText: [drawn3 name]];
    [[self cardValue3] setText: [NSString stringWithFormat:@"%d", drawn3.value]];
    
    //TODO BUG: set up all cards drawn this way.
    //If a card is removed, all cards shift down and this card becomes empty
    if([self.engine.activePlayer.hand count] > 4){
        Card *drawn4 = self.engine.activePlayer.hand[4];
        [[self cardName4] setText: [drawn4 name]];
        [[self cardValue4] setText: [NSString stringWithFormat:@"%d", drawn4.value]];
    }
    else{
        [[self cardName4] setText: @"No Card"];
        [[self cardValue4] setText: [NSString stringWithFormat:@""]];
    }
}

//The main method for initializing gameplay
- (void)viewDidLoad
{
    [self faceDownActivated].hidden = YES;
    //first time launching view: initialize game
    if (! [self engine]) {
        [super viewDidLoad];
        self.engine = [Engine newEngine];
        [self.engine initEverything];
    }
    if ([self isAiGame]) {
        [self.engine.players[[self.engine.players count]-1] setIsAi:YES];
        [self.engine.players[[self.engine.players count]-1] setName: @"Wesley Bot"];
    }
    //if the other player has a facedown card
    //unhide facedown card
    
    if([self.engine.currentPlayers[self.engine.indexOfActivePlayer+1%[self.engine.players count]] isShielded]){
        [self faceDownActivated].hidden = NO;
    }
    [[self player1Life] setText: [NSString stringWithFormat: @"%@ Life: %d", [self.engine.activePlayer name], [self.engine.activePlayer life]]];
    [[self player2Life] setText: [NSString stringWithFormat: @"%@ Life: %d", [self.engine.players[(self.engine.indexOfActivePlayer+1)%[self.engine.players count]] name], [self.engine.players[(self.engine.indexOfActivePlayer+1)%[self.engine.players count]] life]]];
    
    [self displayHand];
    
}

- (IBAction)discardAndDrawTouched:(id)sender {
    [[self playCard0] setHidden:YES];
    [[self playCard1] setHidden:YES];
    [[self playCard2] setHidden:YES];
    [[self playCard3] setHidden:YES];
    [[self playCard4] setHidden:YES];
    [[self discard0] setHidden:NO];
    [[self discard1] setHidden:NO];
    [[self discard2] setHidden:NO];
    [[self discard3] setHidden:NO];
    [[self discard4] setHidden:NO];
    
    [[self cancel] setHidden:NO];
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
    [[self discardAndDraw] setHidden:YES];
    [[self header] setText:@"Choose cards to discard!"];
}

- (IBAction)cancelTouched:(id)sender {
    [[self playCard0] setHidden:NO];
    [[self playCard1] setHidden:NO];
    [[self playCard2] setHidden:NO];
    [[self playCard3] setHidden:NO];
    [[self playCard4] setHidden:NO];
    [[self discard0] setHidden:YES];
    [[self discard1] setHidden:YES];
    [[self discard2] setHidden:YES];
    [[self discard3] setHidden:YES];
    [[self discard4] setHidden:YES];
    
    [[self cancel] setHidden:YES];
    [[self drawNewCards] setHidden:YES];
    [[self discardAndDraw] setHidden:NO];
    [[self header] setText:@"Pick a card!"];
    
    //undo background changes from selecting discards
    [[self discard0] setBackgroundColor:  [UIColor clearColor]];
    [[self discard1] setBackgroundColor:  [UIColor clearColor]];
    [[self discard2] setBackgroundColor:  [UIColor clearColor]];
    [[self discard3] setBackgroundColor:  [UIColor clearColor]];
    [[self discard4] setBackgroundColor:  [UIColor clearColor]];
}

- (IBAction)drawNewCardsTouched:(id)sender {
    //start at end of hand because NSArrays condense.
    self.engine.numCardsDiscarded = 0;
    if ([[self discard4] backgroundColor] == [UIColor orangeColor]
        && self.engine.activePlayer.hand[4]) {
        [self.engine.activePlayer removeCard:4];
        self.engine.numCardsDiscarded++;
    }
    if ([[self discard3] backgroundColor] == [UIColor orangeColor]
        && self.engine.activePlayer.hand[3]) {
        [self.engine.activePlayer removeCard:3];
        self.engine.numCardsDiscarded++;
    }
    if ([[self discard2] backgroundColor] == [UIColor orangeColor]
        && self.engine.activePlayer.hand[2]) {
        [self.engine.activePlayer removeCard:2];
        self.engine.numCardsDiscarded++;
    }
    if ([[self discard1] backgroundColor] == [UIColor orangeColor]
        && self.engine.activePlayer.hand[1]) {
        [self.engine.activePlayer removeCard:1];
        self.engine.numCardsDiscarded++;
    }
    if ([[self discard0] backgroundColor] == [UIColor orangeColor]
        && self.engine.activePlayer.hand[0]) {
        [self.engine.activePlayer removeCard:0];
        self.engine.numCardsDiscarded++;
    }
    [[self engine] setDiscardedAndDrew:YES];
}


//use this to store info before leaving the view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [[segue destinationViewController] setEngine:self.engine];
}

- (IBAction)card0Touched:(id)sender {
    [self.engine setIndexOfTouchedCard:0];
}
- (IBAction)card1Touched:(id)sender {
    [self.engine setIndexOfTouchedCard:1];
}
- (IBAction)card2Touched:(id)sender {
    [self.engine setIndexOfTouchedCard:2];
}
- (IBAction)card3Touched:(id)sender {
    [self.engine setIndexOfTouchedCard:3];
}
- (IBAction)card4Touched:(id)sender {
    [self.engine setIndexOfTouchedCard:4];
}

- (IBAction)discard0Touched:(id)sender {
    if([[self discard0] backgroundColor] == [UIColor orangeColor]){
        [[self discard0] setBackgroundColor:  [UIColor clearColor]];
    }
    else{
        [[self discard0] setBackgroundColor:  [UIColor orangeColor]];
    }
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
}
- (IBAction)discard1Touched:(id)sender {
    if([[self discard1] backgroundColor] == [UIColor orangeColor]){
        [[self discard1] setBackgroundColor:  [UIColor clearColor]];
    }
    else{
        [[self discard1] setBackgroundColor:  [UIColor orangeColor]];
    }
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
}
- (IBAction)discard2Touched:(id)sender {
    if([[self discard2] backgroundColor] == [UIColor orangeColor]){
        [[self discard2] setBackgroundColor:  [UIColor clearColor]];
    }
    else{
        [[self discard2] setBackgroundColor:  [UIColor orangeColor]];
    }
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
}
- (IBAction)discard3Touched:(id)sender {
    if([[self discard3] backgroundColor] == [UIColor orangeColor]){
        [[self discard3] setBackgroundColor:  [UIColor clearColor]];
    }
    else{
        [[self discard3] setBackgroundColor:  [UIColor orangeColor]];
    }
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
}
- (IBAction)discard4Touched:(id)sender {
    if([[self discard4] backgroundColor] == [UIColor orangeColor]){
        [[self discard4] setBackgroundColor:  [UIColor clearColor]];
    }
    else{
        [[self discard4] setBackgroundColor:  [UIColor orangeColor]];
    }
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
}

- (BOOL)atLeastOneCardSetToDiscard{
    return [[self discard0] backgroundColor] == [UIColor orangeColor]
        || [[self discard1] backgroundColor] == [UIColor orangeColor]
        || [[self discard2] backgroundColor] == [UIColor orangeColor]
        || [[self discard3] backgroundColor] == [UIColor orangeColor]
        || [[self discard4] backgroundColor] == [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
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
