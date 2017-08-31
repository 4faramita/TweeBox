# TweeBox - A iOS Twitter Reader.

![banner](https://user-images.githubusercontent.com/14917258/29926139-1f0fb956-8e95-11e7-9180-f581482b91b1.png)

> WARNING: TweeBox is still in a quite early phase of processing (after all, it's only one-month old now). So the bad news is, it still has many bugs and unfinished features; on the bright side, you will be there to witness its growth :)

There are a lot of Twitter "clients", but this is not one of them -- TweeBox is a Twitter "reader", designed for those who would like to browse on twitter rather than speak loadly to the Twitter street.

As a result, TweeBox is friendly to many tweet reading features, including but not limited to "favorite", "block" and "report spam". What's more, you can also easily delete your tweets by just a swipe.

![like](https://user-images.githubusercontent.com/14917258/29924287-1462f60e-8e8f-11e7-9049-494b96df9190.PNG)

![delete](https://user-images.githubusercontent.com/14917258/29924285-14552f56-8e8f-11e7-984b-b3bd692cde59.PNG)

![block](https://user-images.githubusercontent.com/14917258/29924282-1433d36a-8e8f-11e7-9ae6-70ad329a2ab3.PNG)

Also, I'm currently living in a country where I have to use Twitter via proxy, which can be slow. So TweeBox also contains features like "do not show the image until it's fully loaded", so you can continue browsing your timeline while loading.

![loading](https://user-images.githubusercontent.com/14917258/29924286-146140f2-8e8f-11e7-8ecd-8fcfc2ba6e8f.PNG)

TweeBox also comes with a ton of other features and a decent UI design. More pictures:

![search](https://user-images.githubusercontent.com/14917258/29924280-143061c6-8e8f-11e7-9718-b3b48a5c7faa.PNG)

![video](https://user-images.githubusercontent.com/14917258/29924281-14322b50-8e8f-11e7-8bd6-7e6f1e518445.PNG)

![timeline](https://user-images.githubusercontent.com/14917258/29924279-1422746c-8e8f-11e7-9836-03148d293a65.PNG)

![image viewer](https://user-images.githubusercontent.com/14917258/29924284-1438add6-8e8f-11e7-8c22-d2c744422d57.PNG)

## Getting Started
TweeBox is currently absent from Apple App Store （just for now). So if you want to try it,please do as follow:

check out the source in a way you feel suits, for example:

`git clone "https://github.com/4faramita/TweeBox.git"`

Then
```
cd TweeBox
pod install
```
Now you can open the `TweeBox.xcworkspace` file in Xcode.

## Change Log
2017-08-31: First release. Happy month-aversary, TweeBox!

## Roadmap
### Basic
- [x] RESTful client
- [x] Twitter API wrapper
- [ ] Error handling

### Timeline:
- [x] Basic timeline information display
- [x] Timeline text parsing
- [x] Timeline click action
- [x] Click and wait indicator
- [ ] Image viewer:
  - [x] Gestures, alerts
  - [x] Single Image viewer
  - [x] Share sheet
  - [ ] Multiple Image viewer
  - [x] GIF / video viewer

- [x] Relative time
- [ ] Content filter
- [ ] User profile page: 
  - [x] Basic infomation
  - [ ] Text parsing
  - [x] Click action (query)
- [ ] Save to database
- [x] Load upward and downward
- [x] View replies
- [x] View context

#### Special:
- [x] Tweet gesture
- [ ] Waiting bubble

### Composer:
- [x] Retweet
- [x] Reply
- [x] Compose new tweet

### Settings:

### Search:
- [x] General search
- [ ] Database search

### DM:


