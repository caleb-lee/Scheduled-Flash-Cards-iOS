//
//  AddNewDeckViewController.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "AddNewDeckViewController.h"
#import "Deck+Management.h"

@interface AddNewDeckViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

// when clicked, adds a deck with the name in nameTextField and dismisses
//  this view controller
- (IBAction)okButtonAction:(id)sender;

// just dismisses this view controller without doing anything
- (IBAction)cancelButtonAction:(id)sender;

// changing the constant of this constraint changes the size of the
//  container view from the bottom (thus changing the position of the
//  actual UI view)
// set its value to the height of the keyboard to keep the "create deck"
//  prompt centered on screen
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomSpaceConstraint;
@end

@implementation AddNewDeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register keyboard notifications
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set name text box to first responder (selects text box & shows keyboard)
    [_nameTextField becomeFirstResponder];
}

- (IBAction)okButtonAction:(id)sender {
    self.view.userInteractionEnabled = NO;
    
    if ([self addNewDeck])
        [self leaveViewController];
    else
        self.view.userInteractionEnabled = YES;
}

- (IBAction)cancelButtonAction:(id)sender {
    [self leaveViewController];
}

// adds a new deck
// if successful (i.e., if the name is valid), returns YES
// if not, returns NO
- (BOOL)addNewDeck {
    if ([_nameTextField.text isEqualToString:@""]) {
        UIAlertView *nameAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please choose a different name for your new deck." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [nameAlert show];
        
        return NO;
    }
    
    [Deck insertDeckWithName:_nameTextField.text];
    return YES;
}

// dismisses the keyboard and dismisses the view controller
- (void)leaveViewController {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
#ifdef DEBUG
    NSLog(@"Keyboard Height: %f", kbSize.height);
#endif
    
    _containerViewBottomSpaceConstraint.constant = kbSize.height;
    [self.view layoutSubviews];
}

@end
