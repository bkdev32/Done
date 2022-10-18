# 📋 Done

I developed this To Do List app to practice using Realm and CocoaPods.

I have used <a href="https://realm.io" target="_blank">Realm</a> to allow users to create multiple lists/categories and save them locally.

Each item can be marked as done or simply deleted by swiping to left. To be able to replicate the swipe to delete behaviour, I have installed <a href="https://cocoapods.org/pods/SwipeCellKit" target="_blank">SwipeCellKit</a>.

I have also used <a href="https://cocoapods.org/pods/ChameleonFramework" target="_blank">ChameleonFramework</a> to assign random colours to each category that is persisted and creates a nice UI.



I have created the same app without any pods and only using Core Data for local data storage which can be accessed [here](https://github.com/bkdev32/ToDoList).

![ezgif com-gif-maker-3](https://user-images.githubusercontent.com/11230240/138702362-b2da7c6e-2a09-438d-b824-db9b24e0b0bb.gif)

## Project Setup

Clone the repository and run:

``` pod init ```

Add the following to your project Podfile

``` 
pod 'RealmSwift'
pod 'SwipeCellKit'
pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5' 
```

Then run:

``` pod install ```


=====================

<a target="_blank" href="https://icons8.com/icon/111399/list">List</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>

