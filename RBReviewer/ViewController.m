//
//  ViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/11/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "ViewController.h"
#import "DSODoSomethingAPIClient.h"
#import "DSOUser.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)loginTapped:(id)sender;
- (IBAction)logoutTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.greetingLabel.hidden = TRUE;
    self.logoutButton.hidden = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutTapped:(id)sender {
    [DSODoSomethingAPIClient logoutUserWithCompletionHandler:^(NSDictionary *response){
        
        self.greetingLabel.hidden = TRUE;
        self.usernameTextField.hidden = FALSE;
        self.passwordTextField.hidden = FALSE;
        self.loginButton.hidden = FALSE;
        self.logoutButton.hidden = TRUE;
    }];
}

- (IBAction)loginTapped:(id)sender {

    NSDictionary *auth = [[NSDictionary alloc] init];

    auth = @{@"username":self.usernameTextField.text,
              @"password":self.passwordTextField.text};
    
    [DSODoSomethingAPIClient loginUserWithCompletionHandler:^(NSDictionary *response){
        NSString *email = [DSODoSomethingAPIClient sharedClient].user[@"mail"];
        NSString *token = [DSODoSomethingAPIClient sharedClient].authHeaders[@"X-CSRF-Token"];
        self.greetingLabel.hidden = FALSE;
        self.greetingLabel.numberOfLines = 0;
        self.greetingLabel.text = [NSString stringWithFormat:@"Hi, %@!\n\nYour token is:\n%@", email, token];
        self.usernameTextField.hidden = TRUE;
        self.passwordTextField.hidden = TRUE;
        self.loginButton.hidden = TRUE;
        self.logoutButton.hidden = FALSE;
    } :auth];
}
@end
