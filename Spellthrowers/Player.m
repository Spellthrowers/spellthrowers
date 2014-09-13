//
//  Player.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "Player.h"

@implementation Player

+(instancetype)newPlayer: (Deck*) deck{
    Player *newPlayer = [[Player alloc] init];
    [newPlayer setLife: 20];
    [newPlayer fillHand: deck];
    return newPlayer;
}

-(void)fillHand: (Deck*) deck{
    /*while ([playerHand count] < DRAW_CAP) {
        NSLog(@"Hand size: %lu", (unsigned long)[playerHand count]);
        playerHand[[playerHand count]] = [deck draw];
        [self displayHand];
    }*/
}

-(NSMutableArray*)hand{
    return playerHand;
}

-(void)play:(int)atIndex{
    
}

-(void)removeCard:(int)atIndex{
    [[self hand] removeObjectAtIndex:atIndex];
}

-(void)displayHand{
    NSLog(@"Displaying hand:");
    for (int i=0; i<[playerHand count]; i++) {
        NSLog(@"Card %d: %@", i, [playerHand objectAtIndex:i]);
    }
}

-(void)hideHand{
    
}

-(void)takeDamage{
    
}
         
-(void)addCard:(Card*)card{
    [playerHand addObject:card];
}

-(void)gainLife: (int)amount{
    
}

@end
