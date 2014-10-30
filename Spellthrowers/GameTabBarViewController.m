//
//  GameTabBarViewController.m
//  Spellthrowers
//
//  Created by Wesley Olson on 10/30/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import "GameTabBarViewController.h"
#import "HelpViewController.h"

@interface GameTabBarViewController ()

@end

@implementation GameTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (HelpViewController *child in self.childViewControllers) {
        child.engine = self.engine;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [[segue destinationViewController] setEngine:self.engine];
}

@end
