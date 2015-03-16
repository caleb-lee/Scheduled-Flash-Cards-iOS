//
//  ReviewCardsViewController.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "ReviewCardsViewController.h"
#import "Card+Management.h"
#import "ScheduleController.h"

@interface ReviewCardsViewController ()

@property (strong, nonatomic) NSArray *dueCardsArray;
@property (nonatomic) NSInteger currentCardIndex;
@property (strong, nonatomic) ScheduleController *scheduleController;

@end

@implementation ReviewCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set defaults
    _currentCardIndex = 0;
    _scheduleController = [[ScheduleController alloc] init];
    
    // fill dueCardsArray
    _dueCardsArray = [Card getDueCardsInDeck:_deck];
    
    // show first view
    if (_dueCardsArray == nil)
        [self showNoCardsDue];
    else
        [self showCard];
}

- (void)showNoCardsDue {
    UIAlertView *noCardsAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"There are currently no cards due in deck \"%@\"", _deck.name] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [noCardsAlert show];
}

- (void)showCard {
#warning TODO
}

#pragma Mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
