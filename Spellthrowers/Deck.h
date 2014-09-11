//
//  Deck.h
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#define NUM_CARD_TYPES 4

@interface Deck : NSObject

//retuns a subclass of deck, if asked for.
+(instancetype)newDeck;
-(Card *)draw;


@end
