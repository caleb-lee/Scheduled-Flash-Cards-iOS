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
    
    // register keyboard notifications
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_frontTextView becomeFirstResponder];
}

- (void)dealloc {
    _deck = nil;
}

- (IBAction)addCardButtonAction:(id)sender {
    [Card insertCardWithFront:_frontTextView.text Back:_backTextView.text intoDeck:_deck];
    _frontTextView.text = @"";
    _backTextView.text = @"";
    [_frontTextView becomeFirstResponder];
    
    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Card added successfully" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [successAlert show];
}

// notifies when the keyboard is being shown or hidden
// from https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

// the method called when the keyboard gets shown
//  it changes containerViewBottomSpaceConstraint to the correct constant and lays out the vc's views
//  from https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
- (void)keyboardWillBeShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    _containerBottomConstraint.constant = kbSize.height;
    [self.view layoutSubviews];
}

@end
