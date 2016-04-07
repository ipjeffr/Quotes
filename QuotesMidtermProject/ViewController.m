//
//  ViewController.m
//  QuotesMidtermProject
//
//  Created by Jeffrey Ip on 2016-04-04.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "ViewController.h"
#import "Quote.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *quoteOutput;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataFromURL];
}

- (IBAction)tapToRandomizeQuote:(id)sender {
    self.quoteOutput.text = [NSString stringWithFormat:@""];
    [self getDataFromURL];
}

-(void)getDataFromURL {
    NSURL *url = [NSURL URLWithString:@"http://quotes.rest/quote.json?api_key=_80rR8mylHhzTKCMYfxobAeF"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSError *jsonError;
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError) {
                
                Quote *quote = [[Quote alloc] init];
                quote.quote = jsonObject[@"contents"][@"quote"];
                quote.author = jsonObject[@"contents"][@"author"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.quoteOutput.text = [NSString stringWithFormat:@"%@\n\n\n-%@", quote.quote, quote.author];
                });
            }
        } else {
            NSLog(@"There was an error: %@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}

@end
