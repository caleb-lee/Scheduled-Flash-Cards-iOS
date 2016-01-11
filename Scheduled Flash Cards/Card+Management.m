//
//  Card+Management.m
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "Card+Management.h"
#import "DatabaseManager.h"

@implementation Card (Management)

static NSString *const EntityName = @"Card";
static NSString *const KeyForInterval = @"interval";
static NSString *const KeyForNextSeeDate = @"nextSeeDate";

+ (Card*)insertCardWithFront:(NSString *)front
                        back:(NSString *)back
                    intoDeck:(Deck *)deck {
    Card *newCard = (Card*)[NSEntityDescription insertNewObjectForEntityForName:EntityName inManagedObjectContext:defaultManagedObjectContext()];
    
    [newCard setFront:front];
    [newCard setBack:back];
    [newCard setLastSeenDate:[NSDate dateWithTimeIntervalSince1970:0]];
    [newCard setNextSeeDate:[NSDate date]];
    [newCard setInterval:[NSNumber numberWithInt:0]];
    [newCard setDeck:deck];
    
    return newCard;
}

// this method returns all due cards in the given deck
//  or returns an empty array if no cards are due
+ (NSArray*)getDueCardsInDeck:(Deck*)deck {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(deck == %@) AND (nextSeeDate <= %@)", deck, [NSDate date]];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:KeyForInterval ascending:NO],
                                 [NSSortDescriptor sortDescriptorWithKey:KeyForNextSeeDate ascending:YES]];
    
    NSArray *dueCards = fetchObjects(EntityName, predicate, sortDescriptors);
    return dueCards;
}

@end
