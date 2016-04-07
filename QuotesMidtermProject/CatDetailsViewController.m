//
//  CatDetailsViewController.m
//  QuotesMidtermProject
//
//  Created by Jeffrey Ip on 2016-04-05.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "CatDetailsViewController.h"
#import "FavoritesViewController.h"
#import "AppDelegate.h"
#import "Quote.h"
#import "SavedQuote.h"
#import "Category.h"

@interface CatDetailsViewController () <UIPickerViewDelegate, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *categoryQuoteOutput;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *randomizeButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Quote *quoteToSave;
@property (strong, nonatomic) NSArray *pickerArray;
@property (nonatomic, strong) NSString *categoryKey;
@property BOOL didGatherURLData;

@end

@implementation CatDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.randomizeButton.enabled = NO;
    self.saveButton.enabled = NO;
    self.didGatherURLData = NO;
    [self getDataFromURL];
    
    self.pickerArray = [[NSArray alloc] initWithObjects: @"art", @"funny", @"inspire", @"life", @"love", @"management", @"sports", nil];
}

- (void)getDataFromURL {
    NSString *urlString = [NSString stringWithFormat:@"http://quotes.rest/quote.json?category=%@&?api_key=_80rR8mylHhzTKCMYfxobAeF", self.categoryKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSError *jsonError;
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {
                // make this just a SavedObject
                Quote *quote = [[Quote alloc] init];
                quote.quote = jsonObject[@"contents"][@"quote"];
                quote.author = jsonObject[@"contents"][@"author"];
                quote.category = jsonObject[@"contents"][@"requested_category"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.categoryQuoteOutput.text = [NSString stringWithFormat:@"%@\n\n\n-%@\n\n%@", quote.quote, quote.author, quote.category];
                    self.quoteToSave = quote;
                    self.randomizeButton.enabled = YES;
                    self.saveButton.enabled = YES;
                    self.didGatherURLData = YES;
                });
            }
        } else {
            NSLog(@"There was an error: %@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}

#pragma mark - Button Methods
- (IBAction)saveToCoreData:(id)sender {
    
    self.managedObjectContext = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    SavedQuote *newSavedQuote = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"SavedQuote"
                                 inManagedObjectContext:self.managedObjectContext];
    newSavedQuote.text = self.quoteToSave.quote;
    newSavedQuote.author = self.quoteToSave.author;
    
    Category *newCategory;
    NSArray *a = [self fetchForDuplicateCategories];
    if (a.count == 1) {
        newCategory = a[0];
    } else {
        newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
        newCategory.name = self.quoteToSave.category;
    }
    newSavedQuote.category = newCategory;
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@", error.localizedDescription);
        abort();
    }
    self.saveButton.enabled = NO;
}

- (IBAction)didPressRandomize:(id)sender {
    self.didGatherURLData = NO;
    [self getDataFromURL];
    if (self.didGatherURLData == YES) {
        NSArray *a = [self fetchForDuplicateQuotes];
        
        if (a.count >= 1) {
            self.saveButton.enabled = NO;
        } else {
            self.saveButton.enabled = YES;
        }
    }
}

#pragma mark - CoreData Duplicates Checks
- (NSArray *)fetchForDuplicateQuotes {
    NSFetchRequest *fetchSavedQuote = [[NSFetchRequest alloc] init];
    NSEntityDescription *quoteEntity = [NSEntityDescription entityForName:@"SavedQuote" inManagedObjectContext:self.managedObjectContext];
    fetchSavedQuote.entity = quoteEntity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text == %@",
                              self.quoteToSave.quote];
    [fetchSavedQuote setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchSavedQuote error:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        abort();
    }
    return results;
}

- (NSArray *)fetchForDuplicateCategories {
    NSFetchRequest *fetchCategory = [[NSFetchRequest alloc] init];
    NSEntityDescription *catEntity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
    fetchCategory.entity = catEntity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",
                              self.categoryKey];
    [fetchCategory setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchCategory error:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        abort();
    }
    return results;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FavoritesViewController *favoritesVC = [segue destinationViewController];
    favoritesVC.managedOC = self.managedObjectContext;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickerArray!=nil) {
        return [self.pickerArray count];
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        return [self.pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch(row)
    {
        case 0:
            self.categoryKey = @"art";
            break;
        case 1:
            self.categoryKey = @"funny";
            break;
        case 2:
            self.categoryKey = @"inspire";
            break;
        case 3:
            self.categoryKey = @"life";
            break;
        case 4:
            self.categoryKey = @"love";
            break;
        case 5:
            self.categoryKey = @"management";
            break;
        case 6:
            self.categoryKey = @"sports";
            break;
        default:
            break;
    }
}
@end