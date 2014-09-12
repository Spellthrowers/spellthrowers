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
    [newEngine initEverything];
    return newEngine;
}

-(void)initEverything{
    
}

+(void)initDeck{
    
}

+(void)initPlayers{
    
}

-(NSArray*)players{
    return [[NSArray alloc] init];
}

-(NSArray*)activePlayers{
    return [[NSArray alloc] init];
}

-(void)startTurn:(Player *)activePlayer{
    
}

-(void)removePlayer{
    
}

-(void)nextPlayer{
    
}

-(void)endGame{
    
}


@end
