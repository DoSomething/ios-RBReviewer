//
//  DSOImageCard.m
//  RBReviewer
//
//  Created by Aaron Schachter on 1/22/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "DSOImageCard.h"

@implementation DSOImageCard
-(void)layoutSubviews {
    [super layoutSubviews];
}

-(instancetype)initWithFrame:(CGRect)frame options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"DSOImageCard" owner:self options:nil];
        self.view.frame = self.frame;
        [self addSubview:self.view];
    }
    return self;
}

          
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
