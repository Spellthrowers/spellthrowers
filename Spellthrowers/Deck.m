//
//  Deck.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "Deck.h"

@implementation Deck

+(instancetype)newDeck{
    Deck *newDeck = [[Deck alloc] init];
    return newDeck;
}

-(Card *)draw{
    //Get the bundle for this app
    NSBundle* bundle = NSBundle.mainBundle;
    //get the config path
    NSString* path = [bundle pathForResource:@"Config" ofType:@"plist"];
    //build a config dictionary
    NSDictionary* config = [NSDictionary dictionaryWithContentsOfFile:path];
    
    Card *newCard = [[Card alloc] init];
    
    //get random card TODO: use weights
    int cardIndex = arc4random_uniform(NUM_CARD_TYPES);
    
    //set card name
    [newCard setName: config[@"cardNames"][cardIndex]];
    //set card type
    [newCard setType: config[@"cardTypes"][cardIndex]];
    //set card value. This only matters for attack cards.
    [newCard setValue: cardIndex + 1];
    return newCard;
}

@end
