//
//  GameViewController.h
//  Spellthrowers
//
//  Created by Wesley Olson on 9/13/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "Engine.h"
#import "Deck.h"

#define isIpad [[[UIDevice currentDevice] model] containsString:@"iPad"]

@interface GameViewController : UIViewController

@property (nonatomic, strong) Engine* engine;
@property (nonatomic, strong) NSString *restorationIdentifier;
@property (nonatomic) int numPlayers;
@property (nonatomic) bool isAiGame;
@property (nonatomic) bool isMainMenu;
@property (nonatomic) NSArray* cardViews;
@property (nonatomic) NSArray* cardNames;
@property (nonatomic) NSArray* cardValues;
@property (nonatomic) NSArray* playerLives;
@property (nonatomic) NSArray* faceDownActivateds;

-(BOOL)atLeastOneCardSetToDiscard;
-(void)setImageForCard: (Card*)forCard atIndex: (int)atIndex;

@end
