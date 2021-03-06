//
//  CategoryViewController.h
//  QuotesMidtermProject
//
//  Created by Jeffrey Ip on 2016-04-04.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryVCDelegate <NSObject>

- (void)addCategoriesToPicker:(NSArray *)newCategories;

@end

@interface CategoryViewController : UIViewController

@property (weak, nonatomic) id <CategoryVCDelegate> delegate;

@end

