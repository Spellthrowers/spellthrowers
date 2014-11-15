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
@property (weak, nonatomic) IBOutlet UITextView *transition_attackingPlayer;
@property (weak, nonatomic) IBOutlet UITextView *transition_attackingPlayer2;
@property (weak, nonatomic) IBOutlet UITextView *transition_defendingPlayer;
@property (weak, nonatomic) IBOutlet UITextView *transition_defendingPlayer2;
@property (weak, nonatomic) IBOutlet UIImageView *transition_currentCard;
@property (weak, nonatomic) IBOutlet UIImageView *transition_currentCard2;
@property (weak, nonatomic) IBOutlet UILabel *transition_multiplier;
@property (weak, nonatomic) IBOutlet UILabel *transition_multiplier2;

@end

@implementation TransitionViewController

//on view load, change the active player and call their turn to be taken
- (void)viewDidLoad
{
    //Get the bundle for this app
    NSBundle* bundle = NSBundle.mainBundle;
    //get the config path
    NSString* path = [bundle pathForResource:@"Config" ofType:@"plist"];
    //build a config dictionary
    NSDictionary* config = [NSDictionary dictionaryWithContentsOfFile:path];
    
    [self returnHome].hidden = YES;

    if (self.engine.discardedAndDrew) {
        
    }
    else if(self.engine.indexOfTouchedCard > [self.engine.activePlayer.hand count]-1){
        [[self transitionMessage] setText:@"Please pick a valid card!"];
        [self passToAi].hidden = YES;
        [self ready].hidden = NO;
        return;
    }
    
    NSString *nextPlayerName =[self.engine.players[(self.engine.indexOfActivePlayer+1) % [self.engine.players count]] name];
    
    //set text based on card type
    [self setMainText];
    
    //logic for cards that don't end turn
    if(   !self.engine.discardedAndDrew
       && [[self.engine.activePlayer.hand[self.engine.indexOfTouchedCard] cardType] isEqualToString:@"Heal"]){
        nextPlayerName = [self.engine.activePlayer  name];
        [[self transitionMessage2] setText: [NSString stringWithFormat: @"%@, it's still your turn.",nextPlayerName]];
    }
    else{
        [[self transitionMessage2] setText: [NSString stringWithFormat: @"%@, it's your turn.",nextPlayerName]];
    }
    
    //set sound to play
    if(!self.engine.discardedAndDrew){
        for (int j=0; j<[config[@"cardNames"] count]; j++) {
            if ([[self.engine.activePlayer.hand[self.engine.indexOfTouchedCard] name] isEqualToString:config[@"cardNames"][j]]) {
                NSString* URLPath = [[NSBundle mainBundle] pathForResource:config[@"cardSounds"][j] ofType:@"m4a"];
                if(URLPath != nil){
                    NSURL *soundURL = [NSURL fileURLWithPath: URLPath];
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundURL , &sound);
                    AudioServicesPlaySystemSound(sound);
                }
            }
        }
    }
    
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
    
    //first check for discard
    if([[self engine] discardedAndDrew]){
        [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ discarded %i cards!", self.engine.activePlayer.name, self.engine.numCardsDiscarded]];
        //hide new transition message elements
        [self transition_attackingPlayer].hidden = YES;
        [self transition_defendingPlayer].hidden = YES;
        [self transition_currentCard].hidden = YES;
        [self transition_multiplier].hidden = YES;
        [self transition_attackingPlayer2].hidden = YES;
        [self transition_defendingPlayer2].hidden = YES;
        [self transition_currentCard2].hidden = YES;
        [self transition_multiplier2].hidden = YES;
        //show discard text
        [self transitionMessage].hidden = NO;
        return;
    }
    //else hide discard text
    [self transitionMessage].hidden = YES;
    [self transition_attackingPlayer].hidden = NO;
    [self transition_defendingPlayer].hidden = NO;
    [self transition_currentCard].hidden = NO;
    [self transition_multiplier].hidden = YES;
    [self transition_attackingPlayer2].hidden = YES;
    [self transition_defendingPlayer2].hidden = YES;
    [self transition_currentCard2].hidden = YES;
    [self transition_multiplier2].hidden = YES;
    
    //simplification vars
    Player *nextPlayer = self.engine.players[(self.engine.indexOfActivePlayer+1) % [self.engine.players count]];
    NSString *nextPlayerName =[self.engine.players[(self.engine.indexOfActivePlayer+1) % [self.engine.players count]] name];
    Card *cardPlayed = self.engine.activePlayer.hand[self.engine.indexOfTouchedCard];
    int cardValue = cardPlayed.value;
    
    //set card image based on card played
    //Get the bundle for this app
    NSBundle* bundle = NSBundle.mainBundle;
    //get the config path
    NSString* path = [bundle pathForResource:@"Config" ofType:@"plist"];
    //build a config dictionary
    NSDictionary* config = [NSDictionary dictionaryWithContentsOfFile:path];
    
    
    
    //cases to determine which transition message to show
    
    if([cardPlayed.cardType isEqualToString:@"Attack"]){
        if([nextPlayer hasFaceDown]){
            //Handle Facedown triggers/counters
            //handle zap counter
            if([cardPlayed.name isEqualToString: @"Zap"]){
                //destroys any facedowns
                
                [[self transition_attackingPlayer] setText: [NSString stringWithFormat: @"%@ plays", self.engine.activePlayer.name]];
                [[self transition_defendingPlayer] setText: [NSString stringWithFormat: @"against %@", nextPlayer.name]];
                
                UIImage* image;
                if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
                    image = [UIImage imageNamed: @"zapCard.png"];
                }
                else{
                    image = [UIImage imageNamed: @"zapCard_transition.png"];
                }
                UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
                [self.transition_currentCard addSubview:uiv];
                
                [self transition_attackingPlayer2].hidden = NO;
                [self transition_defendingPlayer2].hidden = YES;
                [self transition_currentCard2].hidden = NO;
                
                if([nextPlayer.faceDownCard.cardType isEqualToString:@"Shield"]){
                    //show triggered shield
                    UIImage* image;
                    if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
                        image = [UIImage imageNamed: @"spellShieldCard.png"];
                    }
                    else{
                        image = [UIImage imageNamed: @"spellShieldCard_transition.png"];
                    }
                    UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
                    [self.transition_currentCard2 addSubview:uiv];
                    
                    [[self transition_attackingPlayer2] setText: [NSString stringWithFormat: @"%@ destroys", self.engine.activePlayer.name]];
                }
                else if([nextPlayer.faceDownCard.cardType isEqualToString:@"EMP"]){
                    //show triggered shield
                    UIImage* image;
                    if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
                        image = [UIImage imageNamed: @"EMPCard.png"];
                    }
                    else{
                        image = [UIImage imageNamed: @"EMPCard_transition.png"];
                    }
                    UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
                    [self.transition_currentCard2 addSubview:uiv];
                    
                    [[self transition_attackingPlayer2] setText: [NSString stringWithFormat: @"%@ destroys", self.engine.activePlayer.name]];
                }
                
            }
            //handle if shield
            else if([nextPlayer.faceDownCard.cardType isEqualToString:@"Shield"]){
                //show attacking card
                for (int j=0; j<[config[@"cardNames"] count]; j++) {
                    //if iPad, show larger image
                    UIImage* image = [UIImage imageNamed:
                                      ([[[UIDevice currentDevice] model] containsString:@"iPad"]?
                                       [NSString stringWithFormat: @"%@.png", config[@"cardFileNames"][j]]
                                       : [NSString stringWithFormat: @"%@_transition.png", config[@"cardFileNames"][j]])];
                    if ([cardPlayed.name isEqualToString:config[@"cardNames"][j]] && image != nil) {
                        UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
                        [self.transition_currentCard addSubview:uiv];
                    }
                }
                
                [[self transition_attackingPlayer] setText: [NSString stringWithFormat: @"%@ plays", self.engine.activePlayer.name]];
                [[self transition_defendingPlayer] setText: [NSString stringWithFormat: @"against %@", nextPlayer.name]];
                
                [self transition_attackingPlayer2].hidden = NO;
                [self transition_defendingPlayer2].hidden = NO;
                [self transition_currentCard2].hidden = NO;
                
                //switch attacking and defending players
                [[self transition_attackingPlayer2] setText: [NSString stringWithFormat: @"%@ activates", nextPlayer.name]];
                [[self transition_defendingPlayer2] setText: [NSString stringWithFormat: @"against %@", self.engine.activePlayer.name]];
                
                //show triggered shield
                UIImage* image;
                if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
                    image = [UIImage imageNamed: @"spellShieldCard.png"];
                }
                else{
                    image = [UIImage imageNamed: @"spellShieldCard_transition.png"];
                }
                UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
                [self.transition_currentCard2 addSubview:uiv];
            }
            //handle if EMP
            else if([nextPlayer.faceDownCard.cardType isEqualToString:@"EMP"]){
                //show attacking card
                for (int j=0; j<[config[@"cardNames"] count]; j++) {
                    UIImage* image = [UIImage imageNamed:
                                      ([[[UIDevice currentDevice] model] containsString:@"iPad"]?
                                       [NSString stringWithFormat: @"%@.png", config[@"cardFileNames"][j]]
                                       : [NSString stringWithFormat: @"%@_transition.png", config[@"cardFileNames"][j]])];
                    if ([cardPlayed.name isEqualToString:config[@"cardNames"][j]] && image != nil) {
                        UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
                        [self.transition_currentCard addSubview:uiv];
                    }
                }
                
                [[self transition_attackingPlayer] setText: [NSString stringWithFormat: @"%@ plays", self.engine.activePlayer.name]];
                [[self transition_defendingPlayer] setText: [NSString stringWithFormat: @"against %@", nextPlayer.name]];
                
                [self transition_attackingPlayer2].hidden = NO;
                [self transition_defendingPlayer2].hidden = NO;
                [self transition_currentCard2].hidden = NO;
                
                //show number of weapons removed
                int numWeapons = 0;
                for (Card* card in self.engine.activePlayer.hand) {
                    if([card.cardType isEqualToString:@"Weapon"]){
                        numWeapons++;
                    }
                }
                
                //switch attacking and defending players
                [[self transition_attackingPlayer2] setText: [NSString stringWithFormat: @"%@ activates", nextPlayer.name]];
                [[self transition_defendingPlayer2] setText: [NSString stringWithFormat: @"removing %d of %@'s weapons", numWeapons, self.engine.activePlayer.name]];

                //show triggered EMP
                UIImage* image;
                if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
                    image = [UIImage imageNamed: @"EMPCard.png"];
                }
                else{
                    image = [UIImage imageNamed: @"EMPCard_transition.png"];
                }
                UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
                [self.transition_currentCard2 addSubview:uiv];
            }
        }
        //if no facedown card, handle attack
        else{
            [[self transition_attackingPlayer] setText: [NSString stringWithFormat: @"%@ plays", self.engine.activePlayer.name]];
            [[self transition_defendingPlayer] setText: [NSString stringWithFormat: @"against %@", nextPlayer.name]];
            
            for (int j=0; j<[config[@"cardNames"] count]; j++) {
                UIImage* image = [UIImage imageNamed:
                                  ([[[UIDevice currentDevice] model] containsString:@"iPad"]?
                                   [NSString stringWithFormat: @"%@.png", config[@"cardFileNames"][j]]
                                   : [NSString stringWithFormat: @"%@_transition.png", config[@"cardFileNames"][j]])];
                if ([cardPlayed.name isEqualToString:config[@"cardNames"][j]] && image != nil) {
                    UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
                    [self.transition_currentCard addSubview:uiv];
                }
            }
        }
    }
    else if([cardPlayed.cardType isEqualToString:@"Weapon"]){
        //Handle EMP trigger, shield not triggered by weapon
        if([nextPlayer hasFaceDown] && [nextPlayer.faceDownCard.cardType isEqualToString:@"EMP"]){
            //show weapons played
            int count = 0;
            for (Card* card in self.engine.activePlayer.hand) {
                if([card.cardType isEqualToString:@"Weapon"]){
                    count++;
                }
            }
            
            //set attacking player
            [[self transition_attackingPlayer] setText: [NSString stringWithFormat: @"%@ plays %d", self.engine.activePlayer.name, count]];
            //set defending player
            [[self transition_defendingPlayer] setText: [NSString stringWithFormat: @"against %@", nextPlayer.name]];
            
            UIImage* image;
            if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
                image = [UIImage imageNamed: @"laserPistolCard.png"];
            }
            else{
                image = [UIImage imageNamed: @"laserPistolCard_transition.png"]; //set image of card played
            }
            UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
            [self.transition_currentCard addSubview:uiv];
            
            [self transition_attackingPlayer2].hidden = NO;
            [self transition_defendingPlayer2].hidden = NO;
            [self transition_currentCard2].hidden = NO;
            
            //show facedown triggered
            UIImage* image2;
            if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
                image2 = [UIImage imageNamed: @"EMPCard.png"];
            }
            else{
                image2 = [UIImage imageNamed: @"EMPCard_transition.png"];
            }
            UIImageView* uiv2 = [[UIImageView alloc] initWithImage:image2];
            [self.transition_currentCard2 addSubview:uiv2];
            
            //switch attacking and defending players
            [[self transition_attackingPlayer2] setText: [NSString stringWithFormat: @"%@ activates", nextPlayer.name]];
            [[self transition_defendingPlayer2] setText: [NSString stringWithFormat: @"removing %d of %@'s weapons", count, self.engine.activePlayer.name]];
        }
        //Handle Weapon multiplier
        else{
            int count = 0;
            for (Card* card in self.engine.activePlayer.hand) {
                if([card.cardType isEqualToString:@"Weapon"]){
                    count++;
                }
            }
            
            //set attacking player
            [[self transition_attackingPlayer] setText: [NSString stringWithFormat: @"%@ plays %d", self.engine.activePlayer.name, count]];
            
            //set defending player
            [[self transition_defendingPlayer] setText: [NSString stringWithFormat: @"against %@", nextPlayer.name]];
            
            [self transition_multiplier].hidden = NO; //show multiplier
            [[self transition_multiplier] setText:[NSString stringWithFormat: @"%d", count]]; //set multiplier
            UIImage* image;
            if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
                image = [UIImage imageNamed: @"laserPistolCard.png"];
            }
            else{
                image = [UIImage imageNamed: @"laserPistolCard_transition.png"]; //set image of card played
            }
            UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
            [self.transition_currentCard addSubview:uiv];
            
            //show if shield removed
            if([nextPlayer.faceDownCard.cardType isEqualToString:@"Shield"]){
                
                //show triggered shield
                UIImage* image;
                if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
                    image = [UIImage imageNamed: @"spellShieldCard.png"];
                }
                else{
                    image = [UIImage imageNamed: @"spellShieldCard_transition.png"];
                }
                UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
                [self.transition_currentCard2 addSubview:uiv];
                
                [[self transition_attackingPlayer2] setText: [NSString stringWithFormat: @"%@ destroys", self.engine.activePlayer.name]];
                [self transition_attackingPlayer2].hidden = NO;
                [self transition_currentCard2].hidden = NO;
            }
        }
    }
    else if([cardPlayed.cardType isEqualToString:@"Heal"]){
        //Handle Heal multiplier
        int count = 0;//get count of heals
        for (Card* card in self.engine.activePlayer.hand) {
            if([card.cardType isEqualToString:@"Heal"]){
                count++;
            }
        }
        
        //set attacking player
        [[self transition_attackingPlayer] setText: [NSString stringWithFormat: @"%@ plays %d", self.engine.activePlayer.name, count]];
        
        [self transition_defendingPlayer].hidden = YES;
        UIImage* image;
        if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
            image = [UIImage imageNamed: @"healCard.png"];
        }
        else{
            image = [UIImage imageNamed: @"healCard_transition.png"]; //set image of card played
        }
        UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
        [self.transition_currentCard addSubview:uiv];
    }
    else if(cardPlayed.isFaceDownType){
        //Handles placing facedowns
        
        //set attacking player
        [[self transition_attackingPlayer] setText: [NSString stringWithFormat: @"%@ plays a", self.engine.activePlayer.name]];
        
        //set defending player
        [[self transition_defendingPlayer] setText: @"facedown"];
        
        UIImage* image;
        if([[[UIDevice currentDevice] model] containsString:@"iPad"]){
            image = [UIImage imageNamed: @"facedownCard.png"];
        }
        else{
            image = [UIImage imageNamed: @"facedownCard_transition.png"];
        }
        UIImageView* uiv = [[UIImageView alloc] initWithImage:image];
        [self.transition_currentCard addSubview:uiv];
        
    }
    //TODO: Handle Scrum
    
    
    
    if([cardPlayed.cardType isEqualToString:@"Attack"]){
        if([nextPlayer hasFaceDown]){
            if([cardPlayed.name isEqualToString: @"Zap"]){
                [[self transitionMessage] setText: [NSString stringWithFormat: @"%@'s facedown card was destroyed by %@'s ZAP card! %@ suffered 1 damage.", nextPlayer.name, self.engine.activePlayer.name, nextPlayer.name]];
            }
            else if([nextPlayer.faceDownCard.cardType isEqualToString:@"Shield"]){
                [[self transitionMessage] setText: [NSString stringWithFormat: @"%@'s shield reflects %d damage onto %@ due to the %@ card!", nextPlayerName, cardValue, self.engine.activePlayer.name, cardPlayed.name]];
                
            }
            else if([nextPlayer.faceDownCard.cardType isEqualToString:@"EMP"]){
                //get how many weapons held
                int numWeaponsRemoved = 0;
                for (Player *p in self.engine.currentPlayers) {
                    if(p != nextPlayer){
                        for (Card *card in p.hand) {
                            if([[card cardType] isEqualToString:@"Weapon"]){
                                numWeaponsRemoved++;
                            }
                        }
                    }
                }
                
                //set text on transition screen. Singular and plural weapon removal.
                //TODO: Customize message to include the damage taken from attack card
                if (numWeaponsRemoved == 1) {
                    [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ used a face down EMP card! %i weapon was removed from your hand, dealing 2 damage as it malfunctioned!", nextPlayer.name, numWeaponsRemoved]];
                }
                else if (numWeaponsRemoved > 1){
                    [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ used a face down EMP card! %i weapons were removed from your hand, dealing 2 damage each as they malfunctioned!", nextPlayer.name, numWeaponsRemoved]];
                }
                else{
                    [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ used a face down EMP card! %i weapons were removed from your hand!", nextPlayer.name, numWeaponsRemoved]];
                }

            }
            
        }
        else{
            [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ hit %@ for %d damage with the %@ card!", self.engine.activePlayer.name, nextPlayerName, cardValue, cardPlayed.name]];
        }
    }
    else if([cardPlayed.cardType isEqualToString:@"Weapon"]){
        if([nextPlayer hasFaceDown] && [nextPlayer.faceDownCard.cardType isEqualToString:@"EMP"]){
                //get how many weapons held
                int numWeaponsRemoved = 0;
                for (Player *p in self.engine.currentPlayers) {
                    if(p != nextPlayer){
                        for (Card *card in p.hand) {
                            if([[card cardType] isEqualToString:@"Weapon"]){
                                numWeaponsRemoved++;
                            }
                        }
                    }
                }
                //set text on transition screen. Singular and plural weapon removal.
                if (numWeaponsRemoved == 1) {
                    [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ used a face down EMP card! %i weapon was removed from your hand, dealing 2 damage as it malfunctioned!", nextPlayer.name, numWeaponsRemoved]];
                }
                else if (numWeaponsRemoved > 1){
                    [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ used a face down EMP card! %i weapons were removed from your hand, dealing 2 damage each as they malfunctioned!", nextPlayer.name, numWeaponsRemoved]];
                }
                else{
                    [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ used a face down EMP card! %i weapons were removed from your hand!", nextPlayer.name, numWeaponsRemoved]];
                }
        }
        else{
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
    else if([cardPlayed.cardType isEqualToString:@"Heal"]){
        //When one heal is tapped, play all
        int tempNumHeals = 0;
        int damage = 0;
        for (Card* card in self.engine.activePlayer.hand) {
            if([card.cardType isEqualToString:@"Heal"]){
                damage+= card.value;
                tempNumHeals++;
            }
        }
        [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ played all heal cards to gain %d health!", self.engine.activePlayer.name, damage]];
    }
    //If Shield or EMP
    else if(cardPlayed.isFaceDownType){
        [[self transitionMessage] setText: [NSString stringWithFormat: @"%@ placed a card face down!", self.engine.activePlayer.name]];
    }
}

//use this to store info before leaving the view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (self.engine.winner == NULL) {
        [[segue destinationViewController] setEngine:self.engine];
    }
    [segue destinationViewController];
    AudioServicesDisposeSystemSoundID(sound);
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
