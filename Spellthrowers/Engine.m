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

    //take turn
        
    //TODO: Set rules as to what cards to play
    //Player can play as many cards as they want until they play an attack card
    //TODO: Discard cards
    
    
    //TODO: Remove card after played
    
    
    //TODO: Why does life decrease by the first card index on load..
    if([self.activePlayer hand][_indexOfTouchedCard]){
    //play card on next player
       [self play: self.activePlayer : [self.activePlayer hand][_indexOfTouchedCard] : self.players[(_indexOfActivePlayer+1) % [self.players count]]];
    }
    //End turn if:
    //player uses attack or weapon
    if(   [[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Attack"]
       || [[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Weapon"]){
        //pass turn to nextPlayer
        [self nextPlayer];
    }
    //player doesn't have any cards left
    else if([self.activePlayer.playerHand count] == 0){
        //pass turn to nextPlayer
        [self nextPlayer];
    }
    
    //fill hands
    for (Player *p in self.currentPlayers) {
        [p fillHand:p.deck];
    }
    
    
    //TODO: Remove players
    //TODO: End game
}

-(void)play:(Player *)fromPlayer :(Card *)card :(Player *)onPlayer{
    if(   [[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Attack"]
       || [[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Weapon"]){
        [onPlayer setLife: [onPlayer life] - card.value];
    }
    else if([[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Heal"]){
        [onPlayer setLife: [onPlayer life] + card.value];
    }
    if(![[self.activePlayer.hand[_indexOfTouchedCard] cardType] isEqualToString: @"Weapon"]){
        [self.activePlayer removeCard:_indexOfTouchedCard];
    }
    
    
}

-(void)removePlayer:(Player*)playerToRemove{
    //TODO: Test this method
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
    
}

-(void)endGame{
    //end game
    //TODO:
    
}


@end
