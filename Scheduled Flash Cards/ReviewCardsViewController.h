//
//  ReviewCardsViewController.h
//  Scheduled Flash Cards
//
//  Created by Caleb Lee on 2015/03/16.
//  Copyright (c) 2015年 Caleb Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface ReviewCardsViewController : UIViewController

@property (strong, nonatomic) Deck *deck;

@end
