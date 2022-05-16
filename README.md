# ForeFlight Take Home Project

## Requirements

- Fetch JSON from server endpoint
- Implemented primarily or exclusively with UIKit. SwiftUI can also be
demonstrated as a bonus item, but is not required.
- List of previously loaded locations (initially populated with KPWM & KAUS)
- Text Input box for airport identifier (ex: kaus) to add to list of locations and
automatically pushes to the details view.
- Selecting a location will push to a “Details View” that initially displays the weather
report for the “conditions” section of the JSON output
- Details view has the ability to switch to the “forecast” object in the JSON and the
elements in the view update to represent

## Features

- Store list of requested airports between app launches
- Cache last retrieved report for each airport
- Have a setting that automatically fetches updates at a regular interval

## Information

- Time Spent: ~10-12 hours over the course of the weekend
- Since we do not have an array of AirportModels to iteratre through for our Details table view, I created DetailViewModel and ForecastViewModel to provide a way to show the data in the table view
- I would have liked to have a custom table view cell with a MapView inside centered on the coordinates from the json response
- I believe there is room for improvement with the ViewModels as some code is repeated. Given more time and documentation on the json response there could be a cleaner approach for these
- To make the AirportModel I wanted to try a [new tool](https://app.quicktype.io/) I found. I don't think I will use it again as it had trouble creating the structs properly. It might work better for a more simple json response
- Given more time I would like to add tests for bad input, bad json response, etc.
- There are no pods, please run the xcode project like normal



