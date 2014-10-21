//
//  HelpViewController.h
//  Spellthrowers
//
//  Created by Michelle on 18.10.14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Engine.h"


@interface HelpViewController : UIViewController{
    SystemSoundID sound;
}

@property (nonatomic, strong) Engine* engine;


@end