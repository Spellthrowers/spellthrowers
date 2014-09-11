//
//  Player.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "Player.h"

@implementation Player

+(instancetype)newPlayer{
    Player *newPlayer = [[Player alloc] init];
    [newPlayer setLife: 20];
    [newPlayer fillHand];
    return newPlayer;
}

-(void)fillHand{
    
}

-(NSArray*)hand{
    return [[NSArray alloc] init];
}

-(void)play:(int)atIndex{
    
}

-(void)removeCard{
    
}

-(void)displayHand{
    
}

-(void)hideHand{
    
}

-(void)takeDamage{
    
}

-(void)gainLife{
    
}

@end
