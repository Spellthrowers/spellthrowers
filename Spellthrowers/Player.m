//
//  Player.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "Player.h"

@implementation Player

+(instancetype)newPlayer: (Deck*) deck :(NSString*) name : (NSString*) nickName{
    Player *newPlayer = [[Player alloc] init];
    [newPlayer setDeck:deck];
    newPlayer.playerHand = NSMutableArray.array;
    [newPlayer setLife: 5];
    [newPlayer fillHand: deck];
    [newPlayer setName:name];
    [newPlayer setNickName:nickName];
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
    if (atIndex >= 0 && atIndex < [[self hand] count]){
        [[self hand] removeObjectAtIndex:atIndex];
    }
    else{
        NSLog(@"WARNING! CRASH WOULD HAVE HAPPENED HERE - tried to remove %i index. Player has %lu cards. Printing hand: ", atIndex, (unsigned long)self.hand.count);
        [self printHand];
    }
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
