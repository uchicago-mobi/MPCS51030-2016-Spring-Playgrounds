//
//  ComplicationController.swift
//  WatchThis WatchKit Extension
//
//  Created by T. Andrew Binkowski on 5/1/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
  
  /// Our timeline of events
  let timeLineText = ["Tim at Keynote","Jonny at Lunch","Angela at Snack","Craig at Dinner"]
  
  //
  // MARK: - Timeline Configuration (CLKComplicationDataSource)
  //
  
  func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
    handler([.Forward, .Backward])
  }
  
  func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
    let currentDate = NSDate()
    handler(currentDate)
  }
  
  func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
    // Four hours in the future
    let currentDate = NSDate()
    let endDate = currentDate.dateByAddingTimeInterval(NSTimeInterval(4 * 60 * 60))
    handler(endDate)
  }
  
  func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
    handler(.ShowOnLockScreen)
  }
  
  
  //
  // MARK: - Timeline Population (CLKComplicationDataSource)
  //
  
  func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
    // Call the handler with the current timeline entry
    if complication.family == .ModularLarge {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "hh:mm"
      
      let timeString = dateFormatter.stringFromDate(NSDate())
      
      let entry = createTimeLineEntry(timeString, bodyText: timeLineText[0], date: NSDate())
      
      handler(entry)
    } else {
      handler(nil)
    }
  }
  
  func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries prior to the given date
    handler(nil)
  }
  
  func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries after to the given date
    var timeLineEntryArray = [CLKComplicationTimelineEntry]()

    // For demonstration purposes, have the next one show every hour
    var nextDate = NSDate(timeIntervalSinceNow: 1 * 60 * 60)
    
    for index in 1...3 {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "hh:mm"
      let timeString = dateFormatter.stringFromDate(nextDate)
      let entry = createTimeLineEntry(timeString, bodyText: timeLineText[index], date: nextDate)
      timeLineEntryArray.append(entry)
      nextDate = nextDate.dateByAddingTimeInterval(1 * 60 * 60)
    }
    handler(timeLineEntryArray)
  }
  
  
  //
  // MARK: - Update Scheduling (CLKComplicationDataSource)
  //
  
  func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    handler(nil);
  }
  
  
  //
  // MARK: - Placeholder Templates (CLKComplicationDataSource)
  //
  
  func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    let template = CLKComplicationTemplateModularLargeStandardBody()
    let apple = UIImage(named: "Complication/Modular")
    template.headerImageProvider = CLKImageProvider(onePieceImage: apple!)
    
    template.headerTextProvider = CLKSimpleTextProvider(text: "Faces")
    template.body1TextProvider = CLKSimpleTextProvider(text: "Apple Executives")
    
    handler(template)
  }
  
  
  // 
  // MARK: Data formating
  //
  func createTimeLineEntry(headerText: String, bodyText: String, date: NSDate) -> CLKComplicationTimelineEntry {
    
    let template = CLKComplicationTemplateModularLargeStandardBody()
    let apple = UIImage(named: "Complication/Modular")
    template.headerImageProvider = CLKImageProvider(onePieceImage: apple!)
    
    
    template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
    template.body1TextProvider = CLKSimpleTextProvider(text: bodyText)
    
    let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    
    return(entry)
  }
}
