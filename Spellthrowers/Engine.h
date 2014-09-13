//
//  Engine.h
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Modified by Michelle Pieler 9/11/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Deck.h"

@interface Engine : NSObject

@property Player* activePlayer;//current player
@property Deck* deck;

+(instancetype)newEngine;
-(void)initEverything;
+(void)initDeck;
+(void)initPlayers;
-(NSArray*)players;
-(NSArray*)activePlayers;
-(void)startTurn:(Player*)activePlayer;
-(void)removePlayer;
-(void)nextPlayer;
-(void)endGame;

@end
