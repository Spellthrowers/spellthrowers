//
//  Player.h
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Engine;

@interface Player : NSObject

@property int life;
@property bool isShielded;
@property Engine* engine;

+(instancetype)newPlayer;
-(void)fillHand;
-(NSArray*)hand;
-(void)play:(int)atIndex;
-(void)removeCard;
-(void)displayHand;
-(void)hideHand;
-(void)takeDamage;
-(void)gainLife;

@end
