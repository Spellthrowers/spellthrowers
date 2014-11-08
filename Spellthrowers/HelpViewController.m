//
//  HelpViewController.m
//  Spellthrowers
//
//  Created by Michelle on 18.10.14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "HelpViewController.h"
#import "GameViewController.h"


@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backToGame1;
@property (weak, nonatomic) IBOutlet UIButton *backToGame2;
@property (weak, nonatomic) IBOutlet UIButton *backToGame3;

@end

@implementation HelpViewController

//use this to store info before leaving the view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (self.engine.winner == NULL && [[segue destinationViewController] class] == [GameViewController class]) {
        [[segue destinationViewController] setEngine:self.engine];
    }
    [segue destinationViewController];
    AudioServicesDisposeSystemSoundID(sound);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self isMainMenu]) {
        [[self backToGame1] setHidden:YES];
        [[self backToGame2] setHidden:YES];
        [[self backToGame3] setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end