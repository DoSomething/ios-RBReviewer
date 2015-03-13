//
//  DSOHomeViewController.m
//  RBReviewer
//
//  Created by Aaron Schachter on 12/23/14.
//  Copyright (c) 2014 DoSomething.org. All rights reserved.
//

#import "DSOInboxViewController.h"
#import "DSODetailViewController.h"
#import "DSOLoginViewController.h"

#import <SlothKit/DSOClient.h>
#import <TSMessage.h>


@interface DSOInboxViewController ()

@property (strong, nonatomic) DSOClient *client;
@property (strong, nonatomic) NSMutableArray *terms;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;


- (IBAction)logoutTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DSOInboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.screenName = @"Inbox";
    self.terms = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.client = [DSOClient sharedClient];
    // @todo Add self.client.user back into subtitle
    if (self.displayWelcomeMessage) {
        [TSMessage showNotificationInViewController:self.navigationController
                                              title:@"Welcome back!"
                                           subtitle:@"You're looking great today."
                                               type:TSMessageNotificationTypeMessage];
    }

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.client getConnectionStatusWithCompletionHandler:^(NSDictionary *response){
        NSDictionary *user = response[@"user"];
        NSDictionary *userRoles = user[@"roles"];
        NSLog(@"%@", user);
        // 1 is anon user.
        if ([userRoles objectForKey:@"1"]) {
            [self displayLoginViewController];
        }
        return;
    } errorHandler:^(NSDictionary *response){
        NSLog(@"Error %@", response);
        [self displayLoginViewController];
    }];
    
    [self.client getTermsWithCompletionHandler:^(NSMutableArray *response){
        self.terms = response;
        [self.tableView reloadData];
    }];
}

- (void) displayLoginViewController {
    DSOLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.terms count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    NSMutableDictionary *term = (NSMutableDictionary *)self.terms[indexPath.row];

    cell.textLabel.text = term[@"name"];
    NSString *total = (NSString *)term[@"inbox"];
    cell.detailTextLabel.text = total;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    if ([total intValue] == 0) {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    NSMutableDictionary *term = (NSMutableDictionary *)self.terms[path.row];
    NSString *total = (NSString *)term[@"inbox"];
    
    if ([total intValue] > 0){
        return path;
    }
    
    return nil;
}

- (IBAction)logoutTapped:(id)sender {
    [self.client logoutWithCompletionHandler:^(NSDictionary *response){
        [self displayLoginViewController];
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (sender == self.logoutButton) {
        return;
    }
    UINavigationController *initialVC = (UINavigationController *) [segue destinationViewController];
    DSODetailViewController *destVC = (DSODetailViewController *)initialVC.topViewController;
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *term = (NSMutableDictionary *)self.terms[indexPath.row];
    [destVC setInboxCount:(NSInteger)[cell.detailTextLabel.text intValue]];
    [destVC setTaxonomyTerm:term];
}
@end
