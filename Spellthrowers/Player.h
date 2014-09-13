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

@interface Player : NSObject

@property int life;
@property bool isShielded;

+(instancetype)newPlayer: (Deck*) deck;

-(void)fillHand: (Deck*) deck;
-(NSArray*)hand;
-(void)addCard: (int) atIndex;

-(void)play:(int)atIndex;
-(void)removeCard;
-(void)displayHand;
-(void)hideHand;
-(void)takeDamage;
-(void)gainLife: (int)amount;

@end
