//
//  DSOInboxZeroView.m
//  RBReviewer
//
//  Created by Aaron Schachter on 1/27/15.
//  Copyright (c) 2015 DoSomething.org. All rights reserved.
//

#import "DSOInboxZeroView.h"

@implementation DSOInboxZeroView
-(void)layoutSubviews {
    [super layoutSubviews];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSString *name = NSStringFromClass([self class]);
        [[NSBundle mainBundle] loadNibNamed:name
                                      owner:self
                                    options:nil];
        
        [self addSubview:self.view];
        
    }
    return self;
}

@end
