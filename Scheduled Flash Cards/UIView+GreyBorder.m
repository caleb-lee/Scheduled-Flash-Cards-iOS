//
//  UIView+GreyBorder.m
//  Animoticons2
//
//  Created by Caleb Lee on 2013/10/02.
//  Copyright (c) 2013年 Caleb Lee. All rights reserved.
//

#import "UIView+GreyBorder.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (GreyBorder)

- (void)addThinGreyBorder {
    self.layer.borderWidth = [UIScreen mainScreen].scale >= 2.0 ? 0.5 : 1.0;
    self.layer.borderColor = [UIColor colorWithRed:(201.0/255.0) green:(201.0/255.0) blue:(201.0/255.0) alpha:1.0].CGColor;
}

@end
