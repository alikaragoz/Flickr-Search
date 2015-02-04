Flickr Search
===========

**Flickr Search** is a very simple iOS app built in a few hours which consumes the [Flickr Search API](https://www.flickr.com/services/api/flickr.photos.search.html).

Main features are:
- Infinite scroll of results based on a [`UICollectionViewController`](https://developer.apple.com/library/ios/documentation/uikit/reference/UIViewController_Class/Reference/Reference.html).
- History management of past searches.

<p align="center"><img src="github-assets/flickr-screenshot.png"></p>

## Getting started

- Update [CocoaPods](http://cocoapods.org/) dependencies, from terminal type
  ```
  pod install
  ```
  
- Open project using `Flickr Search.xcworkspace`  

- Flickr API key 
  - [Create an app](https://www.flickr.com/services/) or [Apps by you](https://www.flickr.com/services/apps/by/me)
  - Edit `AISearchClient.m`
  ``` objc
  #error Add your Flickr API Key below.
  static NSString *const AISearchClientFlickrAPIKey = @"<YOUR_FLICKR_API_KEY>";
  ```
