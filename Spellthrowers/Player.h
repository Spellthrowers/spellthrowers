//
//  Player.h
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

#define DRAW_CAP 5

@interface Player : NSObject{
    NSMutableArray* playerHand;
}

@property int life;
@property bool isShielded;

+(instancetype)newPlayer: (Deck*) deck;

-(void)fillHand: (Deck*) deck;
-(NSMutableArray*)hand;
-(void)addCard:(Card*)card;
-(void)removeCard:(int)atIndex;

-(void)play:(int)atIndex;
-(void)displayHand;
-(void)hideHand;
-(void)takeDamage;
-(void)gainLife: (int)amount;

@end
