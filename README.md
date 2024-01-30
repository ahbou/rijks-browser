# Rijksmuseum browser using SwiftUI and Combine.

**This app demonstrates how to use SwiftUI and Combine to show a searchable feed of images from the Rijks Museum API.**
##### Notes:  
The feed is limited to art objects related to France.  
The feed is paginated and lazyloaded whenever the users reaches the end of the current page.

## Setup

Get an API key from https://data.rijksmuseum.nl/object-metadata/api/

Create an `.env` file in the Modules folder with the following 

````
export RIJKS_API_KEY=YOUR_KEY_HERE
``````

## Architecture

Besides the main RijksmuseumApp, the code is split into 3 modules using local SPM packages.

#### 1. RijksAPI
API logic with domain specific models.

#### 2. CommonUI
Common UI elements that are useful accross the app.

#### 3. Toolbox
General functions and extensions that are useful in most iOS projects.


## Tests

Each package is setup to have its own suite of tests.

Right now only the `RijksAPI` target includes an integration test.

## Known issues

Scrolling on iOS 14 can be jerky, I spent a lot of time debbuging this until I realized it's a simulator issue.  
**It's not the case on device**  
*Or maybe it's performance issue I'm missing? If so, feedback is welcome.*



## To-dos:
- [ ] Increase tests coverage
- [ ] Lazy loading:  Add a spinner
- [ ] Error handling: Show an alert

## License
[MIT](https://choosealicense.com/licenses/mit/)
