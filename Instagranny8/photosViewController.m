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
#import "ProfileViewController.h"
#import "InfiniteScrollActivityView.h"

@interface photosViewController ()<UITableViewDataSource, UITableViewDelegate, PostCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray * posts;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(assign, nonatomic)int count;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property(nonatomic, strong) InfiniteScrollActivityView* loadingMoreView;
@end

@implementation photosViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    self.count = 20;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getPosts];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    
    // Do any additional setup after loading the view.
}

-(void)postCell:(PostCell *)postCell didTap:(PFUser *)user{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
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
    NSLog(@"%d", self.count);
    query.limit = self.count;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
           // self.isMoreDataLoading = NO;
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
    
    else if ([[segue identifier] isEqualToString:@"profileSegue"]){
        NSLog(@"hello");
        //UITableViewCell *tappedCell = sender;
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //Post *post = self.posts[indexPath.row];
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.currUser = sender;
        //NSLog(@"%@",post.author.username);
    }
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    cell.delegate = self;
    cell.post = post;
    cell.captionLabel.text = post.caption;
    PFFile *image = post.image;
    [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        UIImage *postImage = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
        
        cell.posterView.image = postImageView.image;
    }];
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
    cell.locationLabel.text = [NSString stringWithFormat:@"%f, %f",post.longitude, post.lattitude];
    PFUser *user = post.author;
    PFFile *profImage = [user valueForKey:@"profilePic"];
    int likeCountInt = [post.likeCount intValue];
    [profImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        UIImage *postImage = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
        
        cell.profilePic.image = postImageView.image;
        cell.profilePic.layer.masksToBounds = YES;
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
    }];
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%d", likeCountInt];
    if(likeCountInt == 0){
        UIImage *image = [UIImage imageNamed:@"favor-icon-1"];
        [cell.likeButton setImage:image forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [UIImage imageNamed:@"favor-icon"];
        [cell.likeButton setImage:image forState:UIControlStateNormal];
    }
    //cell.posterView.image = post.image;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging && self.count <= self.posts.count) {
            self.count += 3;
            self.isMoreDataLoading = YES;
            
            NSLog(@"LOAD ME");
            
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            [self getPosts];
        }
    }
}

@end
