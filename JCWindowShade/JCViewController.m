//
//  JCViewController.m
//  JCWindowShade
//
//  Created by John Cadengo on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JCViewController.h"

NSString * const kRevealShadeViewSegueIdentifier = @"RevealShadeView";
NSString * const kSwipeableAreaLabel = @"Swipeable Area";
NSString * const kDragableAreaLabel = @"Dragable Area";

@interface JCViewController ()

@end

@implementation JCViewController

@synthesize swipeableAreaView = _swipeableAreaView;
@synthesize dragableAreaView = _dragableAreaView;
@synthesize swipeUp = _swipeUp;
@synthesize swipeDown = _swipeDown;
@synthesize drag = _drag;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the swipeable area
    self.swipeableAreaView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 370.0f)];
    self.swipeableAreaView.backgroundColor = [UIColor brownColor];
    UILabel *swipeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 160.0f, 320.0f, 50.0f)];
    [swipeLabel setText:kSwipeableAreaLabel];
    [swipeLabel setTextAlignment:UITextAlignmentCenter];
    [swipeLabel setBackgroundColor:[UIColor clearColor]];
    [self.swipeableAreaView addSubview:swipeLabel];
    [self.view addSubview:self.swipeableAreaView];
    
    // Draggable area
    self.dragableAreaView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 370.0f, 320.0f, 90.0f)];
    self.dragableAreaView.backgroundColor = [UIColor orangeColor];
    UILabel *dragLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 50.0f)];
    [dragLabel setText:kDragableAreaLabel];
    [dragLabel setTextAlignment:UITextAlignmentCenter];
    [dragLabel setBackgroundColor:[UIColor clearColor]];
    [self.dragableAreaView addSubview:dragLabel];
    [self.view addSubview:self.dragableAreaView];
    
    // Add our gesture recognizers
    self.drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [self.dragableAreaView addGestureRecognizer:self.drag];
    [self.drag setDelegate:self];
    [self.drag setCancelsTouchesInView:NO];
    
    self.swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.swipeUp setDelegate:self];
    
    self.swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.swipeDown setDelegate:self];
    
    [self.swipeableAreaView addGestureRecognizer:self.swipeDown];
    [self.swipeableAreaView addGestureRecognizer:self.swipeUp];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kRevealShadeViewSegueIdentifier]) {
        // Do any necessary preparations for revealing the shade view
    }
}

- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"drag");
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSLog(@"swipe");
}


@end
