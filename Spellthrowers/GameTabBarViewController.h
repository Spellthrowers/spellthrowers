//
//  GameTabBarViewController.h
//  Spellthrowers
//
//  Created by Wesley Olson on 10/30/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Engine.h"

@interface GameTabBarViewController : UITabBarController
@property Engine *engine;
@property (nonatomic) bool isAiGame;
@end
