//
//  HelpViewController.m
//  Spellthrowers
//
//  Created by Michelle on 18.10.14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "HelpViewController.h"


@interface HelpViewController ()

@end

@implementation HelpViewController

//use this to store info before leaving the view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (self.engine.winner == NULL) {
        [[segue destinationViewController] setEngine:self.engine];
    }
    [segue destinationViewController];
    AudioServicesDisposeSystemSoundID(sound);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end