//
//  DSODoSomethingAPIClient.h
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSOUser.h"

@interface DSODoSomethingAPIClient : NSObject

@property (strong, nonatomic) NSString *token;

+ (void) getActiveCampaignsWithCompletionHandler:(void (^)(NSArray *campaigns))completionHandler;

+ (void) loginUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler :(NSDictionary *)auth;

@end
