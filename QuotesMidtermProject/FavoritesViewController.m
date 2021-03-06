//
//  FavoritesViewController.m
//  QuotesMidtermProject
//
//  Created by Jeffrey Ip on 2016-04-06.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "FavoritesViewController.h"
#import "AppDelegate.h"
#import "SavedQuote.h"
#import "FavoritesCell.h"
#import "Category.h"

@interface FavoritesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *favTableView;
@property (strong, nonatomic) NSArray<Category*>* allCategories;
@property (strong, nonatomic) NSDictionary *quotesDictionary;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic) CGFloat cellHeight;
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedOC = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
}

-(void)viewWillAppear:(BOOL)animated {
    [self fetchData];
    [self.favTableView reloadData];
}

-(void)fetchData {
    NSFetchRequest *fetchCategories = [[NSFetchRequest alloc] init];
    NSEntityDescription *catEntity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.managedOC];
    fetchCategories.entity = catEntity;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchCategories setSortDescriptors:sortDescriptors];
    
    NSError *error;
    self.allCategories = [self.managedOC executeFetchRequest:fetchCategories error:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        abort();
    }
    NSLog(@"self.allCategories == %@", @(self.allCategories.count));
    [self setupDictionary];
}

- (void)setupDictionary {
    NSMutableDictionary *quotes = [[NSMutableDictionary alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES];
    for (Category *cat in self.allCategories) {
        NSSet *q = cat.savedQuotes;
        NSArray *qArray = [q sortedArrayUsingDescriptors:@[sortDescriptor]];
        [quotes setObject:qArray forKey:cat.name];
    }
    self.quotesDictionary = quotes;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCategories[section].savedQuotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"favoritesCell";
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Category *cat = self.allCategories[indexPath.section];
    SavedQuote *quote = self.quotesDictionary[cat.name][indexPath.row];
    
    cell.favQuoteText.text = [NSString stringWithFormat:@"%@\n\n-%@",quote.text, quote.author];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.allCategories[section].name;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Category *cat = self.allCategories[indexPath.section];
        NSInteger count = cat.savedQuotes.count;
        SavedQuote *quote = self.quotesDictionary[cat.name][indexPath.row];
        [self.managedOC deleteObject:quote];
        if (count <= 1) {
            [self.managedOC deleteObject:cat];
        }
        NSError *error = nil;
        [self.managedOC save:&error];
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            abort();
        }
        [self viewWillAppear:NO];
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPath == indexPath) {
        self.selectedIndexPath = nil;
        [self.favTableView reloadData];
        return;
    }
    self.selectedIndexPath = indexPath;
    FavoritesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cellHeight = cell.favQuoteText.intrinsicContentSize.height;
    [self.favTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath %@", indexPath);
    NSLog(@"selectedIndexPath %@", self.selectedIndexPath);
    if ([indexPath compare:self.selectedIndexPath]== NSOrderedSame) {
        return self.cellHeight + 40;
    }
    return (CGFloat)44.0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
}

@end