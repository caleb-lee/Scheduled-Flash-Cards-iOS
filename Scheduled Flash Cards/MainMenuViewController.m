//
//  MainMenuViewController.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/12.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()
- (IBAction)addNewDeckButtonAction:(id)sender;

@end

@implementation MainMenuViewController

static NSString *addNewDeckSegueIdentifier = @"ShowAddNewDeckVC";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// show UI at add a new deck
- (IBAction)addNewDeckButtonAction:(id)sender {
    [self performSegueWithIdentifier:addNewDeckSegueIdentifier sender:self];
}
@end
