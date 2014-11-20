//
//  Engine.m
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Modified by Michelle Pieler 9/11/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "Engine.h"

@implementation Engine

+(instancetype)newEngine: (int) numPlayers{
    Engine* newEngine = [[Engine alloc] init];
    newEngine.players = [NSMutableArray arrayWithObjects: nil];
    newEngine.currentPlayers = [NSMutableArray arrayWithObjects: nil];
    newEngine.initNumPlayers = numPlayers;
    return newEngine;
}

-(void)initEverything{
    //initialize all the players and objects needed
    Deck *deck = [Deck newDeck];
    for (int i = 0; i<[self initNumPlayers]; i++) {
        Player *newPlayer = [Player newPlayer:deck:[NSString stringWithFormat: @"Player %i", i+1 ]:[NSString stringWithFormat: @"P%i", i+1 ]];
        [self addPlayer:newPlayer];
    }
    
    //Set activePlayer
    //TODO: randomize who goes first
    self.indexOfActivePlayer = 0;
    [self setActivePlayer:[self.currentPlayers objectAtIndex:self.indexOfActivePlayer]];
    
    for (Player *p in self.currentPlayers) {
        [p fillHand:deck];
    }
}

-(void)addPlayer:(Player*)newPlayer{
    //add player to players and currentPlayers
    [self.players addObject:(newPlayer)];
    [self.currentPlayers addObject:(newPlayer)];
}

-(void)startTurn{
    
    if([self discardedAndDrew]){
        //if the player discards to one or fewer cards, he or she cannot be said to have multiple weapons.
        if([[[self activePlayer] hand] count] < 2){
            [[self activePlayer] setHasPlayedMultipleWeapons:NO];
        }
        //pass turn to nextPlayer
        [self nextPlayer];
        
        //reset discard check
        self.discardedAndDrew = NO;
    }
    else{
        Card* playedCard = [self.activePlayer hand][_indexOfTouchedCard];
        
        
        //Play card on next player
        [self play: self.activePlayer : playedCard : self.currentPlayers[(_indexOfActivePlayer+1) % [self.currentPlayers count]]];
        
        //check for winner
        if([self.currentPlayers count] == 2 && [self.currentPlayers[0] life] <= 0 && [self.currentPlayers[1] life] <= 0){
            _winner = [NSString stringWithFormat: @"%@",[self endGame]];
            return;
        }
        
        //Remove players once their life is below zero
        for (int i = 0; i < [self.currentPlayers count]; i++) {
            if([self.currentPlayers[i] life] <= 0){
                [self removePlayer:self.currentPlayers[i]];
                i--;
            }
        }
        
        //End game
        if ([self.currentPlayers count] <= 1) {
            //GAME OVER
            _winner = [NSString stringWithFormat: @"%@",[self endGame]];
        }
        
        //End turn if:
        //Player uses attack or weapon or EMP or Shield. Or if player has no cards left.
        if(   [[playedCard cardType] isEqualToString: @"Attack"]
           || [[playedCard cardType] isEqualToString: @"Weapon"]
           || [[playedCard cardType] isEqualToString: @"EMP"]
           || [[playedCard cardType] isEqualToString: @"Shield"]
           || [self.activePlayer.playerHand count] == 0){
            //pass turn to nextPlayer
            [self nextPlayer];
        }
    }
}

-(void)play:(Player *)fromPlayer :(Card *)card :(Player *)onPlayer{
    //perform the correct action based on what was played
    if(   [[card cardType] isEqualToString: @"Attack"]){
        //if attacking a player with an active shield
        if( [onPlayer hasFaceDown] && [[card name] isEqualToString: @"Zap"]){
            //unset shield when zapped
            [onPlayer setHasFaceDown:NO];
            [onPlayer setLife: [onPlayer life] - 1];
        }
        else if([onPlayer hasFaceDown]){
            if([[onPlayer.faceDownCard cardType] isEqualToString: @"EMP"]){
                [self empOthers:onPlayer];
                [onPlayer setLife: [onPlayer life] - card.value];
            }
            else if([[onPlayer.faceDownCard cardType] isEqualToString: @"Shield"]){
                //reflect damage on the attacker
                [_activePlayer setLife: [_activePlayer life] - card.value];
            }
        }
        else{
            [onPlayer setLife: [onPlayer life] - card.value];
        }
        //unset facedowns after hit
        [onPlayer setHasFaceDown:NO];
    }
    else if ([[card cardType] isEqualToString: @"Weapon"]){
        if( [onPlayer hasFaceDown] && [[onPlayer.faceDownCard cardType] isEqualToString: @"EMP"]){
            [self empOthers:onPlayer];
        }
        else{
            int numWeapons = 0;
            for (Card* card in self.activePlayer.hand) {
                if([card.cardType isEqualToString:@"Weapon"]){
                    numWeapons++;
                    [onPlayer setLife: [onPlayer life] - card.value];
                }
            }
            if(numWeapons > 1){
                [fromPlayer setHasPlayedMultipleWeapons:YES];
            }
        }
        //unset facedowns after hit
        [onPlayer setHasFaceDown:NO];
    }
    else if([[card cardType] isEqualToString: @"Heal"]){
        for (Card* card in self.activePlayer.hand) {
            if([card.cardType isEqualToString:@"Heal"]){
                [_activePlayer setLife: [_activePlayer life] + card.value];
            }
        }
    }
    else if([card isFaceDownType]){
        [_activePlayer setHasFaceDown:YES];
        //replaces current if a new facedown gets played
        self.activePlayer.faceDownCard = self.activePlayer.hand[_indexOfTouchedCard];
    }
    
    
    //Remove nonweapon played cards
    if(   ![[card cardType] isEqualToString: @"Weapon"]
       && ![[card cardType] isEqualToString: @"Heal"]){
        [self.activePlayer removeCard:_indexOfTouchedCard];
    }
    else if([[card cardType] isEqualToString: @"Heal"]){
        NSUInteger k = [self.activePlayer.hand count];
        for (int i = 0; i < k; i++) {
            Card* card = self.activePlayer.playerHand[i];
            if([card.cardType isEqualToString:@"Heal"]){
                [self.activePlayer.hand removeObject:card];
                i--;
                k--;
            }
            
        }
    }
    
    
}

-(void)removePlayer:(Player*)playerToRemove{
    //remove a player from currentPlayers
    [self.currentPlayers removeObject:(playerToRemove)];
}

//set activePlayer to the next player
-(void)nextPlayer{
    self.indexOfActivePlayer = (self.indexOfActivePlayer + 1) % [self.currentPlayers count];
    self.activePlayer = self.currentPlayers[self.indexOfActivePlayer];
    //Fill hand of active player for turn start
    [self.activePlayer fillHand: self.activePlayer.deck];
}

-(void) empOthers: (Player*) EMPer{
    for (Player *p in self.currentPlayers) {
        if(p != EMPer){
            //remove AI flag checker for weapons
            [p setHasPlayedMultipleWeapons:NO];
            NSMutableArray* toRemove = NSMutableArray.array;
            for (Card* card in [p hand]) {
                if ([[card cardType] isEqualToString:@"Weapon"]) {
                    [toRemove addObject:card];
                    [p takeDamage:2];
                }
            }
            [[p hand] removeObjectsInArray:toRemove];
        }
    }
}

-(NSString*)endGame{
    NSString *winner = [NSString stringWithFormat:@"%@", [self.currentPlayers[0] name]];
    
    if([winner  isEqual: @"Player 1"] && _isAiGame){
        //updates currentWins {UPDATE AFTER GAME ENDS}
        NSUserDefaults *defaults;
        defaults = [NSUserDefaults standardUserDefaults];
        NSInteger currentWins = [defaults integerForKey:@"Wins"];
        
        currentWins+=1;
        
        [defaults setInteger:currentWins forKey:@"Wins"];
        [defaults synchronize];
        return winner;
    }
    else if(![winner isEqual: @"Player 1"] && _isAiGame){
        //updates currentLoses {UPDATE AFTER GAME ENDS}
        NSUserDefaults *defaults;
        defaults = [NSUserDefaults standardUserDefaults];
        NSInteger currentLosses = [defaults integerForKey:@"Losses"];
        
        currentLosses+=1;
        
        [defaults setInteger:currentLosses forKey:@"Losses"];
        [defaults synchronize];
    }
    return winner;
}

//AI methods

-(int)getAiRecommendedCardIndex{
#ifdef DEBUG
    [self.activePlayer printHand];
#endif
    //get target player. In this case, always next player.
    Player *targetPlayer = self.currentPlayers[(self.indexOfActivePlayer+1) % [self.currentPlayers count]];
    int indexOfHeal = [self indexOfCardType:@"Heal"];
    //play all heals first.
    if (indexOfHeal >= 0 && indexOfHeal < [self.activePlayer.hand count]) {
        return indexOfHeal;
    }
    //if can kill, do it
    if ([self indexOfCardType:@"Attack"] >= 0
        && [self indexOfCardType:@"Attack"] <= self.activePlayer.hand.count
        && [self maxAttackValue] >= targetPlayer.life && [self indexOfBiggestSpellOrWeapon] >= 0) {
        return [self indexOfBiggestSpellOrWeapon];
    }
    //if AI has no facedown card and an enemy has played multiple weapons, play EMP.
    if (!self.activePlayer.hasFaceDown) {
        for (Player *p in self.currentPlayers) {
            if(![p isEqual:self.activePlayer]
               && p.hasPlayedMultipleWeapons
               && [self indexOfCardType:@"EMP"] >= 0
               && [self indexOfCardType:@"EMP"] <= self.activePlayer.hand.count){
                return [self indexOfCardType:@"EMP"];
            }
        }
    }
    //if enemy has facedown card, zap.
    if(targetPlayer.hasFaceDown
       && [self indexOfCardName:@"Zap"] >= 0
       && [self indexOfCardName:@"Zap"] <= self.activePlayer.hand.count){
        return [self indexOfCardName:@"Zap"];
    }
    //if AI has multiple weapons, play them.
    if([self weaponCount] > 1){
        return [self indexOfCardType:@"Weapon"];
    }
    //play big spells
    if ([self indexOfCardType:@"Attack"] >= 0
        && [self maxAttackValue] > 2
        && [self indexOfBiggestSpellOrWeapon] >= 0
        && [self indexOfBiggestSpellOrWeapon] <= self.activePlayer.hand.count) {
        return [self indexOfBiggestSpellOrWeapon];
    }
    //play random facedown
    if(!self.activePlayer.hasFaceDown){
        if ([self indexOfCardType:@"Shield"] >= 0
            && [self indexOfCardType:@"EMP"] >= 0
            && [self indexOfCardType:@"Shield"] <= self.activePlayer.hand.count
            && [self indexOfCardType:@"EMP"] <= self.activePlayer.hand.count) {
            if (arc4random_uniform(2) == 1) {
                return [self indexOfCardType:@"EMP"];
            }
            return [self indexOfCardType:@"Shield"];
        }
    }
    //play shields
    if(!self.activePlayer.hasFaceDown){
        if ([self indexOfCardType:@"Shield"] >= 0
            && [self indexOfCardType:@"Shield"] <= self.activePlayer.hand.count) {
            return [self indexOfCardType:@"Shield"];
        }
    }
    //play small spells
    if ([self indexOfCardType:@"Attack"] >= 0
        && [self maxAttackValue] > 1
        && [self indexOfBiggestSpellOrWeapon] >= 0
        && [self indexOfBiggestSpellOrWeapon] <= self.activePlayer.hand.count) {
        return [self indexOfBiggestSpellOrWeapon];
    }
    return 0;
}

-(int)indexOfCardType: (NSString*) type{
    for (Card *card in self.activePlayer.hand) {
        if ([card.cardType isEqualToString: type]) {
            return (int)[self.activePlayer.hand indexOfObject:card];
        }
    }
    return -1;
}

-(int)weaponCount{
    int count=0;
    for (Card *card in self.activePlayer.hand) {
        if ([card.cardType isEqualToString: @"Weapon"]) {
            count++;
        }
    }
    return count;
}

-(int)maxAttackValue{
    int maxValue = 0;
    for (Card *card in self.activePlayer.hand) {
        if(([card.cardType isEqualToString:@"Attack"] || [card.cardType isEqualToString:@"Weapon"]) && card.value > maxValue){
            maxValue = card.value;
        }
    }
    return maxValue;
}

-(int)indexOfBiggestSpellOrWeapon{
    int maxValue = 0;
    int index = -1;
    for (Card *card in self.activePlayer.hand) {
        if(([card.cardType isEqualToString:@"Attack"] || [card.cardType isEqualToString:@"Weapon"]) && card.value > maxValue){
            maxValue = card.value;
            index = (int)[self.activePlayer.hand indexOfObject:card];
        }
    }
    return index;
}

-(int)indexOfCardName:(NSString *)name{
    for (Card *card in self.activePlayer.hand) {
        if ([card.name isEqualToString: name]) {
            return (int)[self.activePlayer.hand indexOfObject:card];
        }
    }
    return -1;
}

@end
