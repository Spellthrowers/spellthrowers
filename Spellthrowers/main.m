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
        //[engine initEverything];
        Deck *deck = [Deck newDeck];
        Player *player1 = [Player newPlayer:deck];
        Player *player2 = [Player newPlayer:deck];
        
        [engine addPlayer:(player1)];
        [engine addPlayer:(player2)];
        NSLog(@"List of players: %@", [engine players]);
        
        //Set activePlayer
        engine.indexOfActivePlayer = 1;
        engine.activePlayer = [engine.currentPlayers objectAtIndex:engine.indexOfActivePlayer];
        NSLog(@"activePlayer: %@", [engine activePlayer]);
        
        NSLog(@"*TURN*");
        [engine nextPlayer];
        NSLog(@"activePlayer: %@", [engine activePlayer]);
        
        [player1 fillHand:deck];
        [player1 displayHand];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
