//
//  photosViewController.m
//  Instagranny8
//
//  Created by Hannah Hsu on 7/9/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import "photosViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"

@interface photosViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray * posts;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation photosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getPosts];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // Create NSURL and NSURLRequest
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    

                                                
    // ... Use the new data to update the data source ...
    [self getPosts];
                                                
    // Reload the tableView now that there is new data
    [self.tableView reloadData];
                                                
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];

}
- (IBAction)tappedLogout:(id)sender {
    NSLog(@"hello");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
}

-(void)getPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[DetailsViewController class] ]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    cell.captionLabel.text = post.caption;
    PFFile *image = post.image;
    [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        UIImage *postImage = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
        
        cell.posterView.image = postImageView.image;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        cell.dateLabel.text = [formatter stringFromDate:post.createdAt];
        // Do any additional setup after loading the view.
        //NSLog(@"%@", self.post.username);
        
        if(post.username == nil){
            cell.authorLabel.text = @"Anonymous";
        }
        else{
            cell.authorLabel.text = post.username;
        }
    }];
    //cell.posterView.image = post.image;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
