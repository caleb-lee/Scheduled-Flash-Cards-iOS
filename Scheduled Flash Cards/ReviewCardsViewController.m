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
    self.currentCardIndex = 0;
    self.scheduleController = [[ScheduleController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view bringSubviewToFront:self.showAnswerButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // show first view
    [self showCardIfNeeded];
}

- (void)showCardIfNeeded {
    // check for more due cards if we're at the limit (or if this is our first time seeing this screen)
    if (self.dueCardsArray == nil || self.currentCardIndex == [self.dueCardsArray count]) {
        self.currentCardIndex = 0; // reset current card index
        self.dueCardsArray = [Card getDueCardsInDeck:self.deck];
    }
    
    // if we still have no cards, show no cards due
    //  otherwise, show card
    if ([self.dueCardsArray count] == 0)
        [self showNoCardsDue];
    else
        [self showCardQuestion];
}

- (void)showNoCardsDue {
    [self.cardDisplayWebView loadHTMLString:@"" baseURL:nil];
    
    UIAlertController *noCardsAlert = [UIAlertController alertControllerWithTitle:nil
                                                                          message:[NSString stringWithFormat:NSLocalizedString(@"There are currently no cards due in deck \"%@\"", nil), self.deck.name]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    typeof(self) __weak weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                                     }];
    [noCardsAlert addAction:okAction];
    
    [self presentViewController:noCardsAlert
                       animated:YES
                     completion:nil];
}

- (void)showCardQuestion {
    self.currentlyShowingCard = [self.dueCardsArray objectAtIndex:self.currentCardIndex];
    
    [self.cardDisplayWebView loadHTMLString:[self questionHtmlString] baseURL:nil];
}

- (void)showCardAnswer {
    [self.cardDisplayWebView loadHTMLString:[self answerHtmlString] baseURL:nil];
}

- (NSString*)questionHtmlString {
    return [NSString stringWithFormat:@"%@%@%@", htmlHeader, [self frontHtmlString:self.currentlyShowingCard.front], htmlFooter];
}

- (NSString*)answerHtmlString {
    return [NSString stringWithFormat:@"%@%@<hr>%@%@", htmlHeader, [self frontHtmlString:self.currentlyShowingCard.front], [self backHtmlString:self.currentlyShowingCard.back], htmlFooter];
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
    [self.scheduleController scheduleCard:self.currentlyShowingCard withDifficulty:difficulty];
    self.currentCardIndex++;
    self.showAnswerButton.hidden = NO;
    [self showCardIfNeeded];
}

- (IBAction)showAnswerButtonAction:(id)sender {
    [self showCardAnswer];
    self.showAnswerButton.hidden = YES;
}
@end
