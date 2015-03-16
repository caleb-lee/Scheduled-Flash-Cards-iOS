//
//  Card+Management.h
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import "Card.h"
#import "Deck.h"

@interface Card (Management)

// creates and inserts a new card with the given front and back into the given deck
+ (Card*)insertCardWithFront:(NSString*)front Back:(NSString*)back intoDeck:(Deck*)deck;

@end
