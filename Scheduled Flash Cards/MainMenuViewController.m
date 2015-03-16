//
//  MainMenuViewController.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/12.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AddNewCardViewController.h"

@interface MainMenuViewController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addNewDeckButtonAction:(id)sender;

@property (strong, nonatomic) Deck *selectedDeck;
@property (strong, nonatomic) NSIndexPath *selectedRow;
@end

@implementation MainMenuViewController

static NSString *addNewDeckSegueIdentifier = @"ShowAddNewDeckVC";
static NSString *addCardSegueIdentifier = @"AddCardSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set up the fetched results controller
    [self setUpFetchedResultsController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// show UI at add a new deck
- (IBAction)addNewDeckButtonAction:(id)sender {
    [self performSegueWithIdentifier:addNewDeckSegueIdentifier sender:self];
}

- (void)setUpFetchedResultsController {
    _fetchedResultsController = [Deck deckFetchedResultsController];
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    
    if (![_fetchedResultsController performFetch:&error])
        NSLog(@"MainMenuViewControllerError: %@", [error localizedDescription]);
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Deck *deck = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = deck.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)dealloc {
    _fetchedResultsController = nil;
    _selectedDeck = nil;
    _selectedRow = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:addCardSegueIdentifier]) {
        AddNewCardViewController *vc = (AddNewCardViewController*)segue.destinationViewController;
        vc.deck = _selectedDeck;
    }
}

#pragma Mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedRow = indexPath;
    _selectedDeck = (Deck*)[_fetchedResultsController objectAtIndexPath:indexPath];
    
    UIActionSheet *selectActions = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Review cards", @"Add cards", nil];
    [selectActions showInView:self.view];
}

#pragma Mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DeckCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma Mark - NSFetchedResultsControllerDelegate
// these methods taken from http://www.raywenderlich.com/999/core-data-tutorial-for-ios-how-to-use-nsfetchedresultscontroller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[_tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [_tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_tableView endUpdates];
}

#pragma Mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // review cards
            
            break;
        case 1: // add cards
            [self performSegueWithIdentifier:addCardSegueIdentifier sender:self];
            break;
        default:
            break;
    }
    
    [_tableView deselectRowAtIndexPath:_selectedRow animated:YES];
    _selectedRow = nil;
}

@end
