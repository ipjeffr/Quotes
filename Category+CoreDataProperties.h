//
//  Category+CoreDataProperties.h
//  QuotesMidtermProject
//
//  Created by Tenzin Phagdol on 2016-04-06.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<SavedQuote *> *savedQuotes;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addSavedQuotesObject:(SavedQuote *)value;
- (void)removeSavedQuotesObject:(SavedQuote *)value;
- (void)addSavedQuotes:(NSSet<SavedQuote *> *)values;
- (void)removeSavedQuotes:(NSSet<SavedQuote *> *)values;

@end

NS_ASSUME_NONNULL_END
