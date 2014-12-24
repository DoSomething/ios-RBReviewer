//
//  DSOHomeViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/23/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSOHomeViewController.h"
#import "DSODoSomethingAPIClient.h"

@interface DSOHomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)logoutTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DSOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    self.emailLabel.text = client.user[@"mail"];
    [client checkStatusWithCompletionHandler:^(NSDictionary *response){
        NSLog(@"%@", response);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    cell.textLabel.text = @"All campaigns";
    
    return cell;
}


- (IBAction)logoutTapped:(id)sender {
    DSODoSomethingAPIClient *client = [DSODoSomethingAPIClient sharedClient];
    [client logoutUserWithCompletionHandler:^(NSDictionary *response){
        NSLog(@"%@", response);
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [self.navigationController presentViewController:vc animated:YES completion:NULL];
    }];
}
@end
