//
//  JCViewController.h
//  JCWindowShade
//
//  Created by John Cadengo on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kRevealShadeViewSegueIdentifier;
extern NSString * const kSwipeableAreaLabel;
extern NSString * const kDragableAreaLabel;

@interface JCViewController : UIViewController

@property (nonatomic, strong) UIView *swipeableAreaView;
@property (nonatomic, strong) UIView *dragableAreaView;

@end
