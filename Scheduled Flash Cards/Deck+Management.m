//
//  Deck+Management.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "Deck+Management.h"
#import "DatabaseManager.h"

@implementation Deck (Management)
static NSString *entityName = @"Deck";

// creates/inserts a new deck with the given name and returns it
//  returns nil if there's already a deck with that name
+ (Deck*)insertDeckWithName:(NSString*)name {
    // check for duplicate
    Deck *oldDeck = [Deck deckWithName:name];
    
    Deck *newDeck = nil;
    
    // if no duplicate, insert new deck
    if (oldDeck == nil) {
        newDeck = (Deck*)[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:defaultManagedObjectContext()];
        newDeck.name = name;
    }
    
    // return what we have
    return newDeck;
}

// grabs the deck with the given name out of the database and returns it
//  returns nil if deck with no such name exists
+ (Deck*)deckWithName:(NSString*)name {
    // set up predicate and sort descriptors
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    // fetch the deck with name
    Deck *deck = (Deck*)fetchObject(entityName, predicate, sortDescriptors);
    
    return deck;
}

// returns an NSFetchedResultsController that contains all decks
+ (NSFetchedResultsController*)deckFetchedResultsController {
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSFetchRequest *request = fetchRequest(entityName, nil, sortDescriptors);
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:defaultManagedObjectContext() sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedResultsController;
}

@end
