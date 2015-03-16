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
@property (strong, nonatomic) Card *currentlyShowingCard;
@property (strong, nonatomic) ScheduleController *scheduleController;

// buttons
- (IBAction)wrongButtonAction:(id)sender;
- (IBAction)hardButtonAction:(id)sender;
- (IBAction)goodButtonAction:(id)sender;
- (IBAction)easyButtonAction:(id)sender;

@end

@implementation ReviewCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set defaults
    _currentCardIndex = 0;
    _scheduleController = [[ScheduleController alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // show first view
    [self showCardIfNeeded];
}

- (void)showCardIfNeeded {
    // check for more due cards if we're at the limit (or if this is our first time seeing this screen)
    if (_dueCardsArray == nil || _currentCardIndex == [_dueCardsArray count]) {
        _currentCardIndex = 0; // reset current card index
        _dueCardsArray = [Card getDueCardsInDeck:_deck];
    }
    
    // if we still have no cards, show no cards due
    //  otherwise, show card
    if ([_dueCardsArray count] == 0)
        [self showNoCardsDue];
    else
        [self showCard];
}

- (void)dealloc {
    _deck = nil;
    _dueCardsArray = nil;
    _scheduleController = nil;
    _currentlyShowingCard = nil;
}

- (void)showNoCardsDue {
    UIAlertView *noCardsAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"There are currently no cards due in deck \"%@\"", _deck.name] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [noCardsAlert show];
}

- (void)showCard {
#warning TODO
    _currentlyShowingCard = [_dueCardsArray objectAtIndex:_currentCardIndex];
}

#pragma Mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)wrongButtonAction:(id)sender {
    [self gradeCardWithDifficulty:0];
}

- (IBAction)hardButtonAction:(id)sender {
    [self gradeCardWithDifficulty:1];
}

- (IBAction)goodButtonAction:(id)sender {
    [self gradeCardWithDifficulty:2];
}

- (IBAction)easyButtonAction:(id)sender {
    [self gradeCardWithDifficulty:3];
}

- (void)gradeCardWithDifficulty:(NSInteger)difficulty {
    [_scheduleController scheduleCard:_currentlyShowingCard withDifficulty:3];
    _currentCardIndex++;
    [self showCardIfNeeded];
}

@end
