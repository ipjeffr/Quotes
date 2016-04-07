//
//  CategoriesViewController.m
//  QuotesMidtermProject
//
//  Created by Jeffrey Ip on 2016-04-05.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CatDetailsViewController.h"
#import "Quote.h"
#import "CategoriesCell.h"

@interface CategoriesViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *categoriesDictionary;
@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//The following URL only allows for 10 requests per hour, so I've decided to hard code the data instead
//    NSURL *url = [NSURL URLWithString:@"http://quotes.rest/qod/categories.json"];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        if (!error) {
//            
//            NSError *jsonError;
//            
//            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//            if (!jsonError) {
//                NSMutableDictionary *quoteCatDict = [NSMutableDictionary dictionary];
//                
//                for (NSString *key in jsonObject[@"contents"][@"categories"]) {
//                    Quote *quote = [[Quote alloc] init];
//                    quote.category = [jsonObject[@"contents"][@"categories"] objectForKey:key];
//                    
//                    [quoteCatDict setObject:quote.category forKey:key];
//                }
//                
//                NSLog(@"categories: %@", quoteCatDict);
//                
//                self.categoriesDictionary = quoteCatDict;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.tableView reloadData];
//                });
//            }
//        } else {
//            NSLog(@"There was an error: %@", error.localizedDescription);
//        }
//    }];
//    [dataTask resume];

    self.categoriesDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Inspiration", @"inspire",
                                 @"Management", @"management",
                                 @"Sports", @"sports",
                                 @"Life", @"life",
                                 @"Funny", @"funny",
                                 @"Love", @"love",
                                 @"Art", @"art",
                                 nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoriesDictionary.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"categoriesCell";
    CategoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSArray *keys = [self.categoriesDictionary allKeys];
    
    cell.categoryLabel.text = [self.categoriesDictionary objectForKey:[keys objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CatDetailsViewController *detailsVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSArray *keys = [self.categoriesDictionary allKeys];
    NSString *valueAtKey = [self.categoriesDictionary objectForKey:[keys objectAtIndex:indexPath.row]];
    NSArray *keyToPass = [self.categoriesDictionary allKeysForObject:valueAtKey];
    NSString *categoryKey = keyToPass[0];
    detailsVC.categoryKey = categoryKey;
    NSLog(@"%@", keyToPass[0]);
    
}

@end