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

@interface Engine : NSObject

@property Player* activePlayer;//current player
@property Player* winner;
@property int indexOfActivePlayer;
@property NSMutableArray* players;
@property NSMutableArray* currentPlayers;//players that are still in the game
@property (nonatomic) int indexOfTouchedCard;
@property (nonatomic) BOOL isAiGame;
@property (nonatomic) BOOL discardedAndDrew;
@property (nonatomic) int numCardsDiscarded;

+(instancetype)newEngine;
-(void)initEverything;
-(void)addPlayer:(Player*)newPlayer;
-(void)startTurn;
-(void)removePlayer:(Player*)playerToRemove;
-(void)play: (Player*)fromPlayer :(Card*)card :(Player*)onPlayer;
-(void)nextPlayer;
-(void)empOthers:(Player*)EMPer;
-(Player*)endGame;
-(int)getAiRecommendedCardIndex;

@end
