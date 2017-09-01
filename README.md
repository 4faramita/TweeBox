# TweeBox - A iOS Twitter Reader.

![banner](https://user-images.githubusercontent.com/14917258/29926139-1f0fb956-8e95-11e7-9180-f581482b91b1.png)

> WARNING: TweeBox is still in a quite early phase of developing (after all, it's only one-month old now). So the bad news is, it still has many bugs and unfinished features; on the bright side, you will be there to witness its growth :)

There are a lot of Twitter "clients", but this is not one of those -- TweeBox is a Twitter "reader", designed for those who would like to browse on twitter rather than speak loadly to the Twitter street.

As a result, TweeBox is friendly to many tweet reading features, including but not limited to "favorite", "block" and "report spam". What's more, you can also easily delete your tweets by just a swipe.

![like](https://user-images.githubusercontent.com/14917258/29928805-65dfed2c-8e9c-11e7-838e-4ed73b6d70e9.png)

![delete](https://user-images.githubusercontent.com/14917258/29928804-65de5fde-8e9c-11e7-83cb-459827a3de08.png)

Also, I'm currently living in a country where I have to use Twitter via proxy, which can be slow. So TweeBox also contains features like "do not show the image until it's fully loaded", so you can continue browsing your timeline while loading.

![loading](https://user-images.githubusercontent.com/14917258/29928806-65e3a7aa-8e9c-11e7-98aa-5eccf0fa7275.png)

TweeBox also comes with a ton of other features and a decent UI design. More pictures:

![timeline](https://user-images.githubusercontent.com/14917258/29928816-6c180db4-8e9c-11e7-9147-de9fa9933f7a.png)


## Getting Started
TweeBox is currently absent from Apple App Store （just for now). So if you want to try it,please do as follow:

check out the source in a way you feel suits, for example:

```
git clone "https://github.com/4faramita/TweeBox.git"
```

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


