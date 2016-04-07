//
//  SavedQuote+CoreDataProperties.h
//  QuotesMidtermProject
//
//  Created by Tenzin Phagdol on 2016-04-06.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SavedQuote.h"

NS_ASSUME_NONNULL_BEGIN

@interface SavedQuote (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) Category *category;

@end

NS_ASSUME_NONNULL_END
