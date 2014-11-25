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

@property (weak, nonatomic) IBOutlet UILabel *specialSpellCardsBold;
@property (weak, nonatomic) IBOutlet UILabel *specialSpellCards2;
@property (weak, nonatomic) IBOutlet UILabel *specialSpellCards;
@property (weak, nonatomic) IBOutlet UILabel *healCardsBold;
@property (weak, nonatomic) IBOutlet UILabel *healCards;
@property (weak, nonatomic) IBOutlet UILabel *healCards2;
@property (weak, nonatomic) IBOutlet UILabel *zapCardsBold;
@property (weak, nonatomic) IBOutlet UILabel *zapCards;
@property (weak, nonatomic) IBOutlet UILabel *zapCards2;
@property (weak, nonatomic) IBOutlet UITextView *scrumCards;
@property (weak, nonatomic) IBOutlet UIButton *backToMainMenu;


@property (weak, nonatomic) IBOutlet UILabel *facedownCardsBold;
@property (weak, nonatomic) IBOutlet UILabel *facedownCards;
@property (weak, nonatomic) IBOutlet UILabel *facedownCards2;
@property (weak, nonatomic) IBOutlet UILabel *facedownCards3;
@property (weak, nonatomic) IBOutlet UILabel *facedownCards4;
@property (weak, nonatomic) IBOutlet UILabel *shieldCardsBold;
@property (weak, nonatomic) IBOutlet UILabel *shieldCards;
@property (weak, nonatomic) IBOutlet UILabel *shieldCards2;
@property (weak, nonatomic) IBOutlet UILabel *EMPCardsBold;
@property (weak, nonatomic) IBOutlet UILabel *EMPCards;
@property (weak, nonatomic) IBOutlet UILabel *EMPCards2;


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
        if(self.specialSpellCards){
            UIFont *textFont = [self.specialSpellCards.font fontWithSize:16];
            UIFont *boldFont = [self.specialSpellCardsBold.font fontWithSize:15];
            
            
            self.specialSpellCardsBold.font = boldFont;
            self.specialSpellCards.font = textFont;
            self.specialSpellCards2.font = textFont;
            self.healCardsBold.font = boldFont;
            self.healCards.font = textFont;
            self.healCards2.font = textFont;
            self.zapCardsBold.font = boldFont;
            self.zapCards.font = textFont;
            self.zapCards2.font = textFont;
            self.scrumCards.font = boldFont;
        }
        if(self.shieldCards){
            UIFont *textFont = [self.shieldCards.font fontWithSize:16];
            UIFont *boldFont = [self.shieldCardsBold.font fontWithSize:15];
            
            
            self.facedownCardsBold.font = boldFont;
            self.facedownCards.font = textFont;
            self.facedownCards2.font = textFont;
            self.facedownCards3.font = textFont;
            self.facedownCards4.font = textFont;
            self.shieldCardsBold.font = boldFont;
            self.shieldCards.font = textFont;
            self.shieldCards2.font = textFont;
            self.EMPCardsBold.font = boldFont;
            self.EMPCards.font = textFont;
            self.EMPCards2.font = textFont;
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