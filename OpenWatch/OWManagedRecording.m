//
//  OWManagedRecording.m
//  OpenWatch
//
//  Created by Christopher Ballinger on 12/3/12.
//  Copyright (c) 2012 OpenWatch FPC. All rights reserved.
//

#import "OWManagedRecording.h"
#import "OWUtilities.h"
#import "OWTag.h"
#import "OWUser.h"
#import "OWLocationController.h"


@interface OWManagedRecording()
@end

@implementation OWManagedRecording


- (CLLocation*) startLocation {
    return [OWLocalMediaObject locationWithLatitude:[self.startLatitude doubleValue] longitude:[self.startLongitude doubleValue]];
}



- (void) setStartLocation:(CLLocation *)startLocation {
    if (!startLocation) {
        return;
    }
    self.startLatitude = @(startLocation.coordinate.latitude);
    self.startLongitude = @(startLocation.coordinate.longitude);
}

- (void) saveMetadata {
    self.modifiedDate = [NSDate date];
    [super saveMetadata];
}



- (NSMutableDictionary*) metadataDictionary {
    NSMutableDictionary *newMetadataDictionary = [super metadataDictionary];

    NSDateFormatter *dateFormatter = [OWUtilities utcDateFormatter];
    if (self.startDate) {
        [newMetadataDictionary setObject:[dateFormatter stringFromDate:self.startDate] forKey:kRecordingStartDateKey];
    }
    if (self.endDate) {
        [newMetadataDictionary setObject:[dateFormatter stringFromDate:self.endDate] forKey:kRecordingEndDateKey];
    }
    if (self.modifiedDate) {
        [newMetadataDictionary setObject:[dateFormatter stringFromDate:self.modifiedDate] forKey:kLastEditedKey];
    }
    if (self.recordingDescription) {
        [newMetadataDictionary setObject:[self.recordingDescription copy] forKey:kDescriptionKey];
    }
    if ([OWLocationController locationIsValid:self.startLocation]) {
        [newMetadataDictionary setObject:self.startLatitude forKey:kLatitudeStartKey];
        [newMetadataDictionary setObject:self.endLongitude forKey:kLongitudeStartKey];
    }
    
    return newMetadataDictionary;
}

- (void) loadMetadataFromDictionary:(NSDictionary*)metadataDictionary {
    [super loadMetadataFromDictionary:metadataDictionary];
    NSDateFormatter *dateFormatter = [OWUtilities utcDateFormatter];
    
    NSString *newDescription = [metadataDictionary objectForKey:kDescriptionKey];
    if (newDescription) {
        self.recordingDescription = newDescription;
    }
    NSString *startDateString = [metadataDictionary objectForKey:kRecordingStartDateKey];
    if (startDateString) {
        self.startDate = [dateFormatter dateFromString:startDateString];
    }
    NSString *endDateString = [metadataDictionary objectForKey:kRecordingEndDateKey];
    if (endDateString) {
        self.endDate = [dateFormatter dateFromString:endDateString];
    }
    NSNumber *startLatitude = [metadataDictionary objectForKey:kLatitudeStartKey];
    if (startLatitude) {
        self.startLatitude = startLatitude;
    }
    NSNumber *startLongitude = [metadataDictionary objectForKey:kLongitudeStartKey];
    if (startLongitude) {
        self.startLongitude = startLongitude;
    }
}

- (NSString*) type {
    return @"video";
}


@end
