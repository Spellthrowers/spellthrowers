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

@property (weak, nonatomic) IBOutlet UITextView *weaponText;
@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet UILabel *text3;
@property (weak, nonatomic) IBOutlet UILabel *text4;
@property (weak, nonatomic) IBOutlet UILabel *text5;
@property (weak, nonatomic) IBOutlet UILabel *text6;
@property (weak, nonatomic) IBOutlet UILabel *text7;
@property (weak, nonatomic) IBOutlet UITextView *text8;
@property (weak, nonatomic) IBOutlet UILabel *text9;

@property (weak, nonatomic) IBOutlet UILabel *header1;
@property (weak, nonatomic) IBOutlet UILabel *header2;

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
    
    //fix screen for 4S users
    if (SCREEN_HEIGHT < 481) {
        if (self.weaponText) {
            UIFont *textFont = [self.weaponText.font fontWithSize:16];
            UIFont *boldFont = [self.text1.font fontWithSize:15];
            UIFont *headerFont = [self.header1.font fontWithSize:20];
            self.weaponText.font = textFont;
            self.text1.font = boldFont;
            self.text2.font = textFont;
            self.text3.font = boldFont;
            self.text4.font = boldFont;
            self.text5.font = textFont;
            self.text6.font = textFont;
            self.text7.font = textFont;
            self.text8.font = boldFont;
            self.text9.font = textFont;
            self.header1.font = headerFont;
            self.header2.font = headerFont;
            
            //special formatting
            self.weaponText.text = [((NSString*)self.weaponText.text) substringFromIndex:8];
            self.text6.text = [((NSString*)self.text6.text) substringFromIndex:1];
        }
    }
    
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