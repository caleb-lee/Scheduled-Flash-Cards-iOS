//
//  MainMenuViewController.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/12.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "MainMenuViewController.h"

#import "AddNewCardViewController.h"
#import "ReviewCardsViewController.h"
#import "DatabaseManager.h"
#import "Deck+Management.h"

@interface MainMenuViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addNewDeckButtonAction:(id)sender;

@property (strong, nonatomic) Deck *selectedDeck;
@end

@implementation MainMenuViewController

static NSString *const AddNewDeckSegueIdentifier = @"ShowAddNewDeckVC";
static NSString *const AddCardSegueIdentifier = @"AddCardSegue";
static NSString *const ReviewCardsSegueIdentifier = @"ReviewCardsSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set up the fetched results controller
    [self setUpFetchedResultsController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // save context
    saveManagedObjectContext();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// show UI at add a new deck
- (IBAction)addNewDeckButtonAction:(id)sender {
    [self performSegueWithIdentifier:AddNewDeckSegueIdentifier sender:self];
}

- (void)setUpFetchedResultsController {
    self.fetchedResultsController = [Deck deckFetchedResultsController];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    
    if (![self.fetchedResultsController performFetch:&error])
        NSLog(@"MainMenuViewControllerError: %@", [error localizedDescription]);
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Deck *deck = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = deck.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:AddCardSegueIdentifier]) {
        AddNewCardViewController *vc = (AddNewCardViewController*)segue.destinationViewController;
        vc.deck = self.selectedDeck;
    } else if ([segue.identifier isEqualToString:ReviewCardsSegueIdentifier]) {
        ReviewCardsViewController *vc = (ReviewCardsViewController*)segue.destinationViewController;
        vc.deck = self.selectedDeck;
    }
}

#pragma Mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedDeck = (Deck*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    typeof(self) __weak weakSelf = self;
    UIAlertAction *reviewAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Review cards", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             [weakSelf performSegueWithIdentifier:ReviewCardsSegueIdentifier sender:weakSelf];
                                                             [weakSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
                                                         }];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add cards", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          [weakSelf performSegueWithIdentifier:AddCardSegueIdentifier sender:weakSelf];
                                                          [weakSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
                                                         }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:reviewAction];
    [alertController addAction:addAction];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

#pragma Mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
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
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
