//
//  CategoryViewController.m
//  QuotesMidtermProject
//
//  Created by Jeffrey Ip on 2016-04-04.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "CategoryViewController.h"
#import "QuoteViewController.h"
#import "PotentialCategory.h"
#import "CategoryCell.h"

@interface CategoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray<PotentialCategory*>* potentialCategories;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *selectedCategoriesList;
@property (strong, nonnull) NSMutableArray *showPotentialCategories;
@property (weak, nonatomic) IBOutlet UIButton *saveCategoriesButton;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self stylizeButtons];
    [self blurBackground];
    [self getDataFromURL];
    self.showPotentialCategories = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.backgroundColor = [UIColor blackColor];
}

- (void)stylizeButtons {
    self.saveCategoriesButton.layer.cornerRadius = 5;
    self.saveCategoriesButton.layer.borderWidth = 2;
    self.saveCategoriesButton.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)blurBackground {
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:blurEffectView atIndex:0];
}

- (void)getDataFromURL {
    NSURL *url = [NSURL URLWithString:@"http://quotes.rest/quote/categories.json?start=300&?api_key=_80rR8mylHhzTKCMYfxobAeF"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (!error) {
            
            NSError *jsonError;

            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {

                NSArray *categoriesArray = [NSArray array];
                
                categoriesArray = [[NSArray alloc] initWithArray:jsonObject[@"contents"][@"categories"]];
                self.potentialCategories = [[NSMutableArray alloc] init];
                
                for (NSString *name in categoriesArray) {
                    PotentialCategory *potentialCat = [[PotentialCategory alloc] initWithName:name];
                    [self.potentialCategories addObject:potentialCat];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        } else {
            NSLog(@"There was an error: %@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.potentialCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"catCell";
    CategoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PotentialCategory *potentialCat = self.potentialCategories[indexPath.row];
    
    cell.categoryOutput.text = potentialCat.categoryName;
    
     if (potentialCat.didSelectCategory) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
     } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
     }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PotentialCategory *cat = self.potentialCategories[indexPath.row];
    
    cat.didSelectCategory = !cat.didSelectCategory;
    [tableView reloadData];
    
    if (cat.didSelectCategory) {
        [self.showPotentialCategories addObject:cat.categoryName];
        NSLog(@"===>>>> %@", cat.categoryName);
    } else if (!cat.didSelectCategory){
        [self.showPotentialCategories removeObject:cat.categoryName];
    }
    NSString *result = [self.showPotentialCategories componentsJoinedByString:@"   "];
    self.selectedCategoriesList.text = result;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
}

- (NSArray<NSString*>*)selectedCategoryNames {
    NSMutableArray *selectedCategories = [[NSMutableArray alloc] init];
    
    for (PotentialCategory *cat in self.potentialCategories) {
        if (cat.didSelectCategory) {
            [selectedCategories addObject:cat.categoryName];
        }
    }
    return [selectedCategories copy];
}

- (IBAction)didSaveCategories:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(addCategoriesToPicker:)]) {
        [self.delegate addCategoriesToPicker:self.selectedCategoryNames];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end