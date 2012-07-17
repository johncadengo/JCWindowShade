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

@interface JCViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *swipeableAreaView;
@property (nonatomic, strong) UIView *dragableAreaView;

// Gesture recognizers
@property (nonatomic, strong) UIPanGestureRecognizer *drag;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDown;

- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer;

@end
