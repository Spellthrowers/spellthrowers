//
//  Player.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "Player.h"

@implementation Player

+(instancetype)newPlayer: (Deck*) deck :(NSString*) name{
    Player *newPlayer = [[Player alloc] init];
    [newPlayer setDeck:deck];
    newPlayer.playerHand = NSMutableArray.array;
    [newPlayer setLife: 1];
    [newPlayer fillHand: deck];
    [newPlayer setName:name];
    [newPlayer setIsAi:NO];
    [newPlayer setHasPlayedMultipleWeapons:NO];
    return newPlayer;
}

-(void)fillHand: (Deck*) deck{
    while ([[self playerHand] count] < DRAW_CAP) {
        [[self playerHand] addObject:[deck draw]];
    }
}

-(NSMutableArray*)hand{
    return [self playerHand];
}

-(void)removeCard:(int)atIndex{
    [[self hand] removeObjectAtIndex:atIndex];
}

-(void)takeDamage:(int)amount{
    _life-= amount;
}

-(void)gainLife: (int)amount{
    _life+= amount;
}

-(void)printHand{
    NSLog(@"Hand of %@: ", [self name]);
    for (Card *card in self.hand) {
        NSLog(@"%@", [card name]);
    }
}

@end
