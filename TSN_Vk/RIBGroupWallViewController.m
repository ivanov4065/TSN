//
//  RIBGroupWallViewController.m
//  TSN_Vk
//
//  Created by Roman Ivaniv on 10.09.15.
//  Copyright (c) 2015 Roman Ivaniv. All rights reserved.
//

#import "RIBGroupWallViewController.h"
#import "UIImageView+AFNetworking.h"

#import "RIBServerManager.h"
#import "RIBWall.h"
#import "RIBPostCell.h"
#import "RIBUser.h"
#import "RIBImagePost.h"

@interface RIBGroupWallViewController ()

@property (strong, nonatomic) NSMutableArray* profilesArray;
@property (strong, nonatomic) NSMutableArray* wallArray;
@property (strong, nonatomic) NSMutableArray* imageArray;



@end

static  NSString* groupId = @"20035339";
static const NSInteger postsInRequest = 15;



@implementation RIBGroupWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.profilesArray   = [NSMutableArray array];
    self.wallArray       = [NSMutableArray array];
    self.imageArray      = [NSMutableArray array];

    
    [self getPostsFromServer];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void) getPostsFromServer {
    
    [[RIBServerManager sharedManager]
     getGroupWall:groupId
     withOffset:[self.wallArray count]
     count:postsInRequest
     onSuccess:^(NSArray *profiles, NSArray *wall, NSArray *image) {
         
         [self.profilesArray  addObjectsFromArray:profiles];
         [self.wallArray      addObjectsFromArray:wall];
         [self.imageArray     addObjectsFromArray:image];
         
         [self.tableView reloadData];

         NSLog(@"profilesArray   = %lu", (unsigned long)[self.profilesArray count]);
         NSLog(@"wallArray       = %lu", (unsigned long)[self.wallArray count]);
        
    }
     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"Error = %@, code = %ld", [error localizedDescription], (long)statusCode);
        
     }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.wallArray count] + 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.wallArray count]) {

    
        static NSString* identifier = @"Cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = @"Load more";
        cell.imageView.image = nil;
        
        return cell;
        
    } else {
        
        
        static NSString* identifier = @"PostCell";
        RIBPostCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        

        RIBUser* user = [self.profilesArray objectAtIndex:0];
        cell.userNameLabel.text = user.name;

        NSURLRequest* request = [NSURLRequest requestWithURL:user.imageURL];
        
        __weak RIBPostCell* weakCell = cell;
        
        cell.userImageView.image = nil;
        
        [cell.userImageView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             
             weakCell.userImageView.image = image;
             [weakCell layoutSubviews];
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             
         }];


        
        RIBWall* post = [self.wallArray objectAtIndex:indexPath.row];
        cell.postTextLable.text = post.text;

        cell.postDateLable.text = post.date;
        
        
        RIBImagePost* imagePost = [self.imageArray objectAtIndex:indexPath.row];
        
        NSURLRequest* postRequest = [NSURLRequest requestWithURL:imagePost.postImageURL];
        
        __weak RIBPostCell* postWeakCell = cell;
        
        cell.postImageView.image = nil;
        
        [cell.postImageView
         setImageWithURLRequest:postRequest
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             
             postWeakCell.postImageView.image = image;
             [postWeakCell layoutSubviews];
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             
         }];
  

        return cell;
    }
    
    return  nil;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.wallArray count]) {
        
        return 44.f;
        
    } else {
                
        return 400.f;
    }
}




- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.wallArray count]) {
        
        [self getPostsFromServer];
    }
    
}




@end
