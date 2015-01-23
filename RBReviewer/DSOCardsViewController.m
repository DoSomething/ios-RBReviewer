//
//  DSOCardsViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 1/22/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "DSOCardsViewController.h"
#import "DSODetailViewController.h"
#import "DSOImageCard.h"
#import <MDCSwipeToChoose.h>

@interface DSOCardsViewController ()

@end

@implementation DSOCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.likedText = @"Keep";
    options.likedColor = [UIColor blueColor];
    options.nopeText = @"Delete";
    options.onPan = ^(MDCPanState *state){
        if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
            NSLog(@"Let go now to delete the photo!");
        }
    };
    
    DSOImageCard *card = [[DSOImageCard alloc] initWithFrame:self.view.bounds
                                                                     options:options];
    [self.view addSubview:card];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [card addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tapped {
    NSLog(@"I was tapped");
    DSODetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    [self presentViewController:detailVC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        return YES;
    } else {
        // Snap the view back and cancel the choice.
        [UIView animateWithDuration:0.16 animations:^{
            view.transform = CGAffineTransformIdentity;
            view.center = self.view.center;
        }];
        return NO;
    }
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo deleted!");
    } else {
        NSLog(@"Photo saved!");
    }
}
@end
