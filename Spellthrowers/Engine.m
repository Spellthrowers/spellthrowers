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
}

-(void)addPlayer:(Player*)newPlayer{
    //add player to players and currentPlayers
    [self.players addObject:(newPlayer)];
    [self.currentPlayers addObject:(newPlayer)];
}

-(void)startTurn:(Player*)activePlayer :(Deck*)deck{
    //fill hand
    [self.activePlayer fillHand:deck];
    //view hand
    [self.activePlayer displayHand];
    //need rules as to what cards to play and how to discard cards
    
    //play
    [self.activePlayer play: _indexOfTouchedCard];
    
    
    
    //nextplayer
    [self nextPlayer];
    //endturn
    [self endTurn];
    
}

-(void)endTurn{
    //TODO: does anything need to be updated before the turn ends?
    //I wrote something here before, but I can't remember what it was right now
    
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
