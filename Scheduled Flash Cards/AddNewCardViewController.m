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
    [self.addCardButton addThinGreyBorder];
    [self.frontTextView addThinGreyBorder];
    [self.backTextView addThinGreyBorder];
    
    // register keyboard notifications
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.frontTextView becomeFirstResponder];
}

- (IBAction)addCardButtonAction:(id)sender {
    [Card insertCardWithFront:self.frontTextView.text
                         back:self.backTextView.text
                     intoDeck:self.deck];
    self.frontTextView.text = @"";
    self.backTextView.text = @"";
    [self.frontTextView becomeFirstResponder];
    
    UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:nil
                                                                          message:NSLocalizedString(@"Card added successfully", nil)
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [successAlert addAction:okAction];
    [self presentViewController:successAlert
                       animated:YES
                     completion:nil];
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
- (void)keyboardWillBeShown:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.containerBottomConstraint.constant = kbSize.height;
    [self.view layoutSubviews];
}

@end
