//
//  Engine.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Modified by Michelle Pieler 9/11/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "Engine.h"

@implementation Engine

+(instancetype)newEngine{
    Engine* newEngine = [[Engine alloc] init];
    newEngine.players = [NSMutableArray arrayWithObjects: nil];
    newEngine.currentPlayers = [NSMutableArray arrayWithObjects: nil];
    return newEngine;
}

-(void)initEverything{
    //initialize all the players and objects needed
    Deck *deck = [Deck newDeck];
    Player *player1 = [Player newPlayer:deck:@"Player1"];
    Player *player2 = [Player newPlayer:deck:@"Player2"];
    //Player *winner = nil;
    
    [self addPlayer:player1];
    [self addPlayer:(player2)];
    
    //Set activePlayer
    //TODO: randomize who goes first
    self.indexOfActivePlayer = 0;
    [self setActivePlayer:[self.currentPlayers objectAtIndex:self.indexOfActivePlayer]];
    
    for (Player *p in self.currentPlayers) {
        [p fillHand:deck];
    }
}

-(void)addPlayer:(Player*)newPlayer{
    //add player to players and currentPlayers
    [self.players addObject:(newPlayer)];
    [self.currentPlayers addObject:(newPlayer)];
}

-(void)startTurn{
    
    if([self discardedAndDrew]){
        //pass turn to nextPlayer
        [self nextPlayer];
    }
    else{
        Card* playedCard = [self.activePlayer hand][_indexOfTouchedCard];
        
        
        if([self.activePlayer hand][_indexOfTouchedCard]){
            //Play card on next player
            [self play: self.activePlayer : playedCard : self.players[(_indexOfActivePlayer+1) % [self.players count]]];
        }
        
        //End turn and fill hands if:
        //Player uses attack or weapon or EMP or Shield. Or if player has no cards left.
        if(   [[playedCard cardType] isEqualToString: @"Attack"]
           || [[playedCard cardType] isEqualToString: @"Weapon"]
           || [[playedCard cardType] isEqualToString: @"EMP"]
           || [[playedCard cardType] isEqualToString: @"Shield"]
           || [self.activePlayer.playerHand count] == 0){
            //pass turn to nextPlayer
            [self nextPlayer];
        }
    }
    
    
    
    //Remove players once their life is below zero
    for (int i = 0; i < [self.currentPlayers count]; i++) {
        if([self.currentPlayers[i] life] <= 0){
            [self removePlayer:self.currentPlayers[i]];
        }
    }
    
    //End game
    if ([self.currentPlayers count] <= 1) {
        //GAME OVER
        _winner = [self endGame];
    }
    
    //reset discard check
    self.discardedAndDrew = NO;
}

-(void)play:(Player *)fromPlayer :(Card *)card :(Player *)onPlayer{
    //perform the correct action based on what was played
    if(   [[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Attack"]){
        //if attacking a player with an active shield
        //TODO: ZAP COUNTER
        if( [onPlayer hasFaceDown]){
            if([[onPlayer.faceDownCard cardType] isEqualToString: @"EMP"]){
                for (Player *p in self.currentPlayers) {
                    if(p != onPlayer){
                        for (int i=0; i<[[p hand] count]; i++) {
                            Card* card = p.playerHand[i];
                            if ([[card cardType] isEqualToString:@"Weapon"]) {
                                [p removeCard:i];
                                [p takeDamage:2];
                                i--;
                            }
                        }
                    }
                }
            }
            else if([[onPlayer.faceDownCard cardType] isEqualToString: @"Shield"]){
                //reflect damage on the attacker
                //edit
                [_activePlayer setLife: [_activePlayer life] - card.value];
            }
            //unset shield after use
            [onPlayer setHasFaceDown:NO];
        }
        else{
            [onPlayer setLife: [onPlayer life] - card.value];
        }
    }
    else if ([[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Weapon"]){
        if( [onPlayer hasFaceDown]){
            if([[onPlayer.faceDownCard cardType] isEqualToString: @"EMP"]){
                for (Player *p in self.currentPlayers) {
                    if(p != onPlayer){
                        for (int i=0; i<[[p hand] count]; i++) {
                            Card* card = p.playerHand[i];
                            if ([[card cardType] isEqualToString:@"Weapon"]) {
                                [p removeCard:i];
                                [p takeDamage:2];
                                i--;
                            }
                        }
                    }
                }
            }
            else if([[onPlayer.faceDownCard cardType] isEqualToString: @"Shield"]){
                //reflect damage on the attacker
                [_activePlayer setLife: [_activePlayer life] - card.value];
            }
            //unset shield after use
            [onPlayer setHasFaceDown:NO];
        }
        else{
            for (Card* card in self.activePlayer.hand) {
                if([card.cardType isEqualToString:@"Weapon"]){
                    [onPlayer setLife: [onPlayer life] - card.value];
                }
            }
        }
    }
    else if([[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Heal"]){
        for (Card* card in self.activePlayer.hand) {
            if([card.cardType isEqualToString:@"Heal"]){
                [_activePlayer setLife: [_activePlayer life] + card.value];
            }
        }
    }
    else if([self.activePlayer.hand[_indexOfTouchedCard] isFaceDownType]){
        [_activePlayer setHasFaceDown:YES];
        //replaces current if a new facedown gets played
        self.activePlayer.faceDownCard = self.activePlayer.hand[_indexOfTouchedCard];
    }
    
    
    //Remove nonweapon played cards
    if(   ![[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Weapon"]
       && ![[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Heal"]){
        [self.activePlayer removeCard:_indexOfTouchedCard];
    }
    else if([[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Heal"]){
        NSUInteger k = [self.activePlayer.hand count];
        for (int i = 0; i < k; i++) {
            Card* card = self.activePlayer.playerHand[i];
            if([card.cardType isEqualToString:@"Heal"]){
                [self.activePlayer.hand removeObject:card];
                i--;
                k--;
            }
            
        }
    }
    
    
}

-(int)getAiRecommendedCardIndex{
    return 0;
}

-(void)removePlayer:(Player*)playerToRemove{
    //remove a player from currentPlayers
    [self.currentPlayers removeObject:(playerToRemove)];
}

//set activePlayer to the next player
-(void)nextPlayer{
    int i = self.indexOfActivePlayer;
    int count = (int)[self.currentPlayers count];
    
    if (i >= count-1) {
        //use first index
        self.activePlayer = [self.currentPlayers objectAtIndex: 0];
        self.indexOfActivePlayer = 0;
    }
    else{
        //get nextPlayer at indexOFActivePlayer + 1
        //set nextPlayer to activePlayer
        self.activePlayer = self.currentPlayers[i+1];
        //advance index
        self.indexOfActivePlayer = i+1;
    }
    //Fill hand of active player for turn start
    [self.activePlayer fillHand: self.activePlayer.deck];
}

-(Player*)endGame{
    Player* winner = self.currentPlayers[0];
    return winner;
}


@end
