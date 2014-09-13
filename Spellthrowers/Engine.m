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

-(void)startTurn:(Player*)activePlayer{
    //pass the view to activePlayer, let them perform their turn
    //fill hand
    //view hand
    //play
    //nextplayer
    //endturn
    
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
    
}

-(void)endGame{
    //end game
    
}


@end
