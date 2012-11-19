//
//  JCViewController.h
//  JCWindowShade
//
//  Created by John Cadengo on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kRevealShadeViewSegueIdentifier;
extern NSString * const kSwipeUpLabel;
extern NSString * const kSwipeDownLabel;
extern NSString * const kDragUpLabel;
extern NSString * const kDragDownLabel;

@interface JCViewController : UIViewController <UIGestureRecognizerDelegate>

// Views
@property (nonatomic, strong) UIView *swipeableView;
@property (nonatomic, strong) UIView *dragableView;
@property (nonatomic, strong) UIView *revealableView;

// Frames
@property (nonatomic) CGRect swipeableViewFrame;
@property (nonatomic) CGRect dragableViewFrame;
@property (nonatomic) CGRect revealableViewFrame;

// State
@property (nonatomic, getter=isDragging) BOOL dragging;
@property (nonatomic, getter=isRevealableViewShowing) BOOL revealableViewShowing;

// Gesture recognizers
@property (nonatomic, strong) UIPanGestureRecognizer *drag;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDown;

// Drag and swipe logic
- (void)hideRevealableView;
- (void)showRevealableView;
- (void)offsetFrames:(CGFloat)offset;
- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer;

@end
