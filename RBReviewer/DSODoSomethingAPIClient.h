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

@property (strong, nonatomic) NSString *baseUrl;
@property (retain, nonatomic) NSDictionary *authHeaders;
@property (retain, nonatomic) NSDictionary *user;

+ (DSODoSomethingAPIClient *)sharedClient;

+ (NSString *)getEmail;

+ (NSString *)getUrl;

+ (void)getActiveCampaignsWithCompletionHandler:(void (^)(NSArray *campaigns))completionHandler;

+ (void)getSingleInboxReportbackCompletionHandler:(void(^)(NSArray *))completionHandler;

+ (void)loginUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler :(NSDictionary *)auth;

+ (void)logoutUserWithCompletionHandler:(void(^)(NSDictionary *))completionHandler;

@end
