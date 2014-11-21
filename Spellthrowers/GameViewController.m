//
//  GameViewController.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/13/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIView *cardView0;
@property (weak, nonatomic) IBOutlet UIView *cardView1;
@property (weak, nonatomic) IBOutlet UIView *cardView2;
@property (weak, nonatomic) IBOutlet UIView *cardView3;
@property (weak, nonatomic) IBOutlet UIView *cardView4;

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
@property (weak, nonatomic) IBOutlet UILabel *player3Life;
@property (weak, nonatomic) IBOutlet UILabel *player4Life;
@property (weak, nonatomic) IBOutlet UIButton *discardAndDraw;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *drawNewCards;
@property (weak, nonatomic) IBOutlet UIImageView *faceDownActivated;
@property (weak, nonatomic) IBOutlet UIImageView *faceDownActivated2;
@property (weak, nonatomic) IBOutlet UIImageView *faceDownActivated3;
@property (weak, nonatomic) IBOutlet UIImageView *faceDownActivated4;


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


@end

@implementation GameViewController
- (void)displayHand {
    //NSArray *playCards = @[self.playCard0,  self.playCard1,  self.playCard2,  self.playCard3,  self.playCard4];
    //NSArray *discards =  @[self.discard0,   self.discard1,   self.discard2,   self.discard3,   self.discard4];
    
    [[self header] setText: [NSString stringWithFormat:@"%@, pick a card!", self.engine.activePlayer.name]];
    
    //draw screen and hide cards that don't exist
    for (int i=0; i<[self.engine.activePlayer.hand count]; i++) {
        Card *drawn = self.engine.activePlayer.hand[i];
        [self.cardNames[i] setText: [drawn name]];
        [self.cardValues[i] setText: [NSString stringWithFormat:@"%d", drawn.value]];
        [self.cardViews[i] setHidden:NO];
        [self setImageForCard:drawn atIndex:i];
    }
    for (int i = (int)[self.engine.activePlayer.hand count]; i<DRAW_CAP; i++) {
        [self.cardViews[i] setHidden:YES];
    }
}

//The main method for initializing gameplay
- (void)viewDidLoad
{
    //arrays for buttons
    self.cardViews =  @[self.cardView0,  self.cardView1,  self.cardView2,  self.cardView3,  self.cardView4];
    self.cardNames =  @[self.cardName0,  self.cardName1,  self.cardName2,  self.cardName3,  self.cardName4];
    self.cardValues = @[self.cardValue0, self.cardValue1, self.cardValue2, self.cardValue3, self.cardValue4];
    self.playerLives = @[self.player1Life, self.player2Life, self.player3Life, self.player4Life];
    self.faceDownActivateds = @[self.faceDownActivated, self.faceDownActivated2, self.faceDownActivated3, self.faceDownActivated4];
    
    for (int i=0; i < self.cardViews.count; i++){
        CGFloat degrees = 0 + 15 * (2 - i);
        CGFloat radians = degrees / 57.2958;
        UIView *cardView = self.cardViews[i];
        cardView.transform = CGAffineTransformMakeRotation(-1 * radians);
    }
    
    
    for (UIImageView* faceDown in [self faceDownActivateds]) {
        faceDown.hidden = YES;
    }
    self.player3Life.hidden = YES;
    self.player4Life.hidden = YES;
    //first time launching view: initialize game
    if (! [self engine]) {
        [super viewDidLoad];
        self.engine = [Engine newEngine: self.numPlayers];
        [self.engine initEverything];
        if ([self isAiGame]) {
            [self.engine setIsAiGame:YES];
            [self.engine.players[[self.engine.players count]-1] setIsAi:YES];
            [self.engine.players[[self.engine.players count]-1] setNickName:@"AI"];
            int random = arc4random_uniform(5);
            if (random == 0) {
                [self.engine.players[[self.engine.players count]-1] setName: @"Wesley Bot"];
            }
            else if (random == 1){
                [self.engine.players[[self.engine.players count]-1] setName: @"Michelle Bot"];
            }
            else if (random == 2){
                [self.engine.players[[self.engine.players count]-1] setName: @"Andrea Bot"];
            }
            else if (random == 3){
                [self.engine.players[[self.engine.players count]-1] setName: @"Ray Bot"];
            }
            else if (random == 4){
                [self.engine.players[[self.engine.players count]-1] setName: @"Warner Bot"];
            }
            else {
                [self.engine.players[[self.engine.players count]-1] setName: @"Alex Bot"];
            }
        }
    }
    //set UI elements for each player
    for (int i = 0; i < self.playerLives.count ; i++) {
        [[self faceDownActivateds][i] setHidden: YES];
        [[self playerLives][i] setHidden: YES];
    }
    for (int i = 0; i < self.engine.currentPlayers.count ; i++) {
        //set hasFaceDown for each player
        if([self.engine.currentPlayers[(self.engine.indexOfActivePlayer+i)%[self.engine.currentPlayers count]] hasFaceDown]){
            [[self faceDownActivateds][i] setHidden: NO];
        }
        //set life for each player
        [[self playerLives][i] setText: [NSString stringWithFormat: @"%@: %d", [self.engine.currentPlayers[(self.engine.indexOfActivePlayer+i)%[self.engine.currentPlayers count]] nickName], [self.engine.currentPlayers[(self.engine.indexOfActivePlayer+i)%[self.engine.currentPlayers count]] life]]];
        //set life to not be hidden
        [(UIImageView*)self.playerLives[i] setHidden:NO];
    }
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
    for(int i=0; i<[self.engine.activePlayer.hand count]; i++){
        [self setImageForCard:self.engine.activePlayer.hand[i] atIndex:i];
    }
    
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

//TODO: set image to orange.png
- (IBAction)discard0Touched:(id)sender {
    if([[self discard0] backgroundColor] == [UIColor orangeColor]){
        [[self discard0] setBackgroundColor:  [UIColor clearColor]];
        [self setImageForCard:self.engine.activePlayer.hand[0] atIndex:0];
    }
    else{
        [[self discard0] setBackgroundColor:  [UIColor orangeColor]];
        UIImage* image = [UIImage imageNamed: isIpad? @"discardedCardBig.png" : @"discardedCard.png" ];
        UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
        [self.cardViews[0] addSubview:uiv];
    }
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
}
- (IBAction)discard1Touched:(id)sender {
    if([[self discard1] backgroundColor] == [UIColor orangeColor]){
        [[self discard1] setBackgroundColor:  [UIColor clearColor]];
        [self setImageForCard:self.engine.activePlayer.hand[1] atIndex:1];
    }
    else{
        [[self discard1] setBackgroundColor:  [UIColor orangeColor]];
        UIImage* image = [UIImage imageNamed: isIpad? @"discardedCardBig.png" : @"discardedCard.png" ];
        UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
        [self.cardViews[1] addSubview:uiv];
        
    }
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
}
- (IBAction)discard2Touched:(id)sender {
    if([[self discard2] backgroundColor] == [UIColor orangeColor]){
        [[self discard2] setBackgroundColor:  [UIColor clearColor]];
        [self setImageForCard:self.engine.activePlayer.hand[2] atIndex:2];
    }
    else{
        [[self discard2] setBackgroundColor:  [UIColor orangeColor]];
        UIImage* image = [UIImage imageNamed: isIpad? @"discardedCardBig.png" : @"discardedCard.png" ];
        UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
        [self.cardViews[2] addSubview:uiv];
    }
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
}
- (IBAction)discard3Touched:(id)sender {
    if([[self discard3] backgroundColor] == [UIColor orangeColor]){
        [[self discard3] setBackgroundColor:  [UIColor clearColor]];
        [self setImageForCard:self.engine.activePlayer.hand[3] atIndex:3];
    }
    else{
        [[self discard3] setBackgroundColor:  [UIColor orangeColor]];
        UIImage* image = [UIImage imageNamed: isIpad? @"discardedCardBig.png" : @"discardedCard.png" ];
        UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
        [self.cardViews[3] addSubview:uiv];
    }
    [[self drawNewCards] setHidden: !self.atLeastOneCardSetToDiscard];
}
- (IBAction)discard4Touched:(id)sender {
    if([[self discard4] backgroundColor] == [UIColor orangeColor]){
        [[self discard4] setBackgroundColor:  [UIColor clearColor]];
        [self setImageForCard:self.engine.activePlayer.hand[4] atIndex:4];
    }
    else{
        [[self discard4] setBackgroundColor:  [UIColor orangeColor]];
        UIImage* image = [UIImage imageNamed: isIpad? @"discardedCardBig.png" : @"discardedCard.png" ];
        UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
        [self.cardViews[4] addSubview:uiv];
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

- (void) setImageForCard: (Card*)forCard atIndex:(int) atIndex {
    //Get the bundle for this app
    NSBundle* bundle = NSBundle.mainBundle;
    //get the config path
    NSString* path = [bundle pathForResource:@"Config" ofType:@"plist"];
    //build a config dictionary
    NSDictionary* config = [NSDictionary dictionaryWithContentsOfFile:path];
    
    for (int j=0; j<[config[@"cardNames"] count]; j++) {
        UIImage* image = [UIImage imageNamed: [NSString stringWithFormat: @"%@%@.png", config[@"cardFileNames"][j], isIpad? @"Big" : @""]];
        if ([forCard.name isEqualToString:config[@"cardNames"][j]] && image != nil) {
            UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
            [self.cardViews[atIndex] addSubview:uiv];
        }
    }
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

@end
