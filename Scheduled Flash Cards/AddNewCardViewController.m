//
//  AddNewCardViewController.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "AddNewCardViewController.h"
#import "Card+Management.h"
#import "UIView+GreyBorder.h"

@interface AddNewCardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;
- (IBAction)addCardButtonAction:(id)sender;

// constraints to change when the keyboard shows
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerBottomConstraint;

// text views
@property (weak, nonatomic) IBOutlet UITextView *frontTextView;
@property (weak, nonatomic) IBOutlet UITextView *backTextView;
@end

@implementation AddNewCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // add grey outline to add card button
    [_addCardButton addThinGreyBorder];
    [_frontTextView addThinGreyBorder];
    [_backTextView addThinGreyBorder];
}

- (void)dealloc {
    _deck = nil;
}

- (IBAction)addCardButtonAction:(id)sender {
    [Card insertCardWithFront:_frontTextView.text Back:_backTextView.text intoDeck:_deck];
    _frontTextView.text = @"";
    _backTextView.text = @"";
    
    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Card added successfully" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [successAlert show];
}
@end
