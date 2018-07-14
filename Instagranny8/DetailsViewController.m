//
//  DetailsViewController.m
//  Instagranny8
//
//  Created by Hannah Hsu on 7/10/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import "DetailsViewController.h"
#import "YelpManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFFile *image = self.post.image;
    [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        UIImage *postImage = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
        
        self.posterView.image = postImageView.image;
    }];
    self.captionLabel.text = self.post.caption;
    
    //format the date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    // Convert Date to String
    self.timestampLabel.text = [formatter stringFromDate:self.post.createdAt];
    // Do any additional setup after loading the view.
    //NSLog(@"%@", self.post.username);
    
    if(self.post.username == nil){
        self.authorLabel.text = @"Anonymous";
    }
    else{
        self.authorLabel.text = self.post.username;
    }
    [self getEvents];
}

-(void)getEvents{
    YelpManager *apiManager = [YelpManager new];
    NSString *latitude = [NSString stringWithFormat:@"%f", self.post.lattitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", self.post.longitude];
    [apiManager getEvent:latitude withLongitude:longitude withCompletion:^(NSDictionary *categories, NSError *error) {
        NSArray *events = categories[@"events"];
        if(events.count != 0){
            NSDictionary *event = events[0];
            self.eventLabel.text = event[@"name"];
        }
        else{
            self.eventLabel.text = @"No events near you";
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
