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
    
    numCardTypes = [config[@"cardNames"] count];
    Card *newCard = [[Card alloc] init];
    
    //get random card TODO: use weights
    int cardIndex;
    #ifdef DEBUG
        int random = arc4random_uniform(4);
        if (random == 1) {
            cardIndex = 5; //Fireball
        }
        else if (random == 2){
            cardIndex = 3; //weapon
        }
        else if (random == 3){
            cardIndex = 1; //heal
        }
        else{
            cardIndex = 2; //EMP
        }
    #else
        cardIndex = arc4random_uniform((int)numCardTypes);
    #endif
    
    //set card name
    [newCard setName: config[@"cardNames"][cardIndex]];
    //set card type
    [newCard setCardType: config[@"cardTypes"][cardIndex]];
    //set card value. Requires integer; we only have NSNumbers in plists.
    NSNumber* value = config[@"cardValues"][cardIndex];
    int value2 = [value intValue];
    [newCard setValue: value2];
    //set if card is Face Down Type
    [newCard setIsFaceDownType: (BOOL)config[@"isFaceDownType"][cardIndex]];
    return newCard;
}

@end
