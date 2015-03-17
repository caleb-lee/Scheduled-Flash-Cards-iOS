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
@property (weak, nonatomic) IBOutlet UIButton *showAnswerButton;
- (IBAction)showAnswerButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *cardDisplayWebView;
@end

@implementation ReviewCardsViewController

static NSString *htmlHeader = @"<html><body>";
static NSString *htmlFooter = @"</body></html>";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set defaults
    _currentCardIndex = 0;
    _scheduleController = [[ScheduleController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view bringSubviewToFront:_showAnswerButton];
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
        [self showCardQuestion];
}

- (void)dealloc {
    _deck = nil;
    _dueCardsArray = nil;
    _scheduleController = nil;
    _currentlyShowingCard = nil;
}

- (void)showNoCardsDue {
    [_cardDisplayWebView loadHTMLString:@"" baseURL:nil];
    
    UIAlertView *noCardsAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"There are currently no cards due in deck \"%@\"", _deck.name] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [noCardsAlert show];
}

- (void)showCardQuestion {
    _currentlyShowingCard = [_dueCardsArray objectAtIndex:_currentCardIndex];
    
    [_cardDisplayWebView loadHTMLString:[self questionHtmlString] baseURL:nil];
}

- (void)showCardAnswer {
    [_cardDisplayWebView loadHTMLString:[self answerHtmlString] baseURL:nil];
}

- (NSString*)questionHtmlString {
    return [NSString stringWithFormat:@"%@%@%@", htmlHeader, [self frontHtmlString:_currentlyShowingCard.front], htmlFooter];
}

- (NSString*)answerHtmlString {
    return [NSString stringWithFormat:@"%@%@<hr>%@%@", htmlHeader, [self frontHtmlString:_currentlyShowingCard.front], [self backHtmlString:_currentlyShowingCard.back], htmlFooter];
}

- (NSString*)frontHtmlString:(NSString*)front {
    return [NSString stringWithFormat:@"<div id=\"front\">%@</div>", front];
}

- (NSString*)backHtmlString:(NSString*)back {
    return [NSString stringWithFormat:@"<div id=\"back\">%@</div>", back];
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
    [_scheduleController scheduleCard:_currentlyShowingCard withDifficulty:difficulty];
    _currentCardIndex++;
    _showAnswerButton.hidden = NO;
    [self showCardIfNeeded];
}

#pragma Mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showAnswerButtonAction:(id)sender {
    [self showCardAnswer];
    _showAnswerButton.hidden = YES;
}
@end
