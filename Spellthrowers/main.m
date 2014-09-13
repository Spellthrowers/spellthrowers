//
//  main.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/6/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Card.h"
#import "Player.h"
#import "Deck.h"
#import "Engine.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        //testing deck, player, and drawing cards
        Engine *engine = [Engine newEngine];
        [engine initEverything];
        Deck *deck = [Deck newDeck];
        Player *player1 = [Player newPlayer:deck];
        
        NSLog(@"Player life: %d",[player1 life]);
        [player1 fillHand:deck];
        [player1 displayHand];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
