//
//  GameViewController.h
//  Spellthrowers
//
//  Created by Wesley Olson on 9/13/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface GameViewController : UIViewController

@property (nonatomic, strong) NSString *restorationIdentifier;
@property (nonatomic) bool isAiGame;
@property (nonatomic) NSArray* cardViews;
@property (nonatomic) NSArray* cardNames;
@property (nonatomic) NSArray* cardValues;

-(BOOL)atLeastOneCardSetToDiscard;
-(void)setImageForCard: (Card*)forCard atIndex: (int)atIndex;

@end
