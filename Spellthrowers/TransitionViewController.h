//
//  TransitionViewController.h
//  Spellthrowers
//
//  Created by Wesley Olson on 9/14/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Engine.h"

@interface TransitionViewController : UIViewController{
    SystemSoundID sound;
}

@property (nonatomic, strong) Engine* engine;
@property (nonatomic) NSArray* playerLives;

@end
