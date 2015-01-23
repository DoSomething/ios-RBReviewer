//
//  DSOImageCard.h
//  RBReviewer
//
//  Created by Aaron Schachter on 1/22/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "MDCSwipeToChooseView.h"

@interface DSOImageCard : MDCSwipeToChooseView
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UIView *view;


@end
