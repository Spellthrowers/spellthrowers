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
    Engine *newEngine = [[Engine alloc] init];
    return newEngine;
}

-(void)initEverything{
    //may not need
    
}

-(void)addPlayer{
    //add player to players and currentPlayers
    
}

-(NSArray*)players{
    //array of players
    return [[NSArray alloc] init];
}

-(NSArray*)currentPlayers{
    //array of players left in game
    return [[NSArray alloc] init];
}

-(void)startTurn:(Player *)activePlayer{
    //pass the view to activePlayer, let them perform their turn
}

-(void)removePlayer{
    //remove a player from currentPlayers
    
}

-(void)nextPlayer{
    //set activePlayer to the next player
    
}

-(void)endGame{
    //end game
    
}


@end
