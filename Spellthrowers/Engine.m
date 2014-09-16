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
    
    //start of action sequence
    [self startTurn:self.activePlayer :deck];
    
    for (Player *p in self.currentPlayers) {
        [p fillHand:deck];
    }
}

-(void)addPlayer:(Player*)newPlayer{
    //add player to players and currentPlayers
    [self.players addObject:(newPlayer)];
    [self.currentPlayers addObject:(newPlayer)];
}

-(void)startTurn:(Player*)activePlayer :(Deck*)deck{
    //fill hands
    for (Player *p in self.currentPlayers) {
        [p fillHand:deck];
    }
    //need rules as to what cards to play and how to discard cards
    
    //play card on next player
    [self play: activePlayer :[activePlayer hand][_indexOfTouchedCard] : self.players[(_indexOfActivePlayer+1) % [self.players count]]];
    
    //nextplayer
    [self nextPlayer];
    //endturn
}

-(void)play:(Player *)fromPlayer :(Card *)card :(Player *)onPlayer{
    //NSLog(@"%@ plays %@ on %@!", [[self activePlayer] name], [[[self activePlayer] hand][_indexOfTouchedCard] name], [[self players][_indexOfActivePlayer+1 % [[self players] count]] name]);
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
