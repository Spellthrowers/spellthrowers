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
        Player *player1 = [Player newPlayer];
        Deck *deck = [Deck newDeck];
        for (int i=0; i<5; i++) {
            Card *card = [deck draw];
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
