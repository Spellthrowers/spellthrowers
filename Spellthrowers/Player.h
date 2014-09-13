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

@property (nonatomic) int life;
@property (nonatomic) bool isShielded;
@property (nonatomic, strong) NSMutableArray* playerHand;
@property (nonatomic, strong) Deck *deck;

+(instancetype)newPlayer: (Deck*) deck;

-(void)fillHand: (Deck*) deck;
-(NSMutableArray*)hand;
-(void)removeCard:(int)atIndex;

-(void)play:(int)atIndex;
-(void)displayHand;
-(void)hideHand;
-(void)takeDamage: (int)amount;
-(void)gainLife: (int)amount;

@end
