//
//  GameViewController.h
//  Spellthrowers
//
//  Created by Wesley Olson on 9/13/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (nonatomic, strong) NSString *restorationIdentifier;
@property (nonatomic) bool isAiGame;

-(BOOL)atLeastOneCardSetToDiscard;

@end
