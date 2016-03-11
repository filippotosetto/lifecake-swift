# lifecake-swift

Clone project. Create separate branch, where all fixes will be committed. Commit your code after each fix.

•	using google is allowed
•	you should be able to explain any code changes
•	using Xcode instruments highly recommended

Feel free to ask if you have any questions, something is unclear or you are stuck on some task.

Artjom:
Skype: artjom.popov 
Email: artjom@lifecake.com

Mark:
Skype: thelegothief
Email: marks@lifecake.com

Fixes:
1) app crashes on startup.
2) app loading time is too long, try to reduce it. There are several issues here. Try to scroll images - make sure app does not crash and there is no image flickering (one image is replaced by another one)
3) Try to tap some image to open it. Image layout is broken (part of the image is out of screen).
4) In image view we display when image was opened last time. It shows “no date”, if image was not opened before. Some why date is not refreshed, when you open image again and again.
5) If you close image view, ImageMeta is not released (ping us, if this task takes too long, we will point you in the right direction)

Features:
6) Start storing ViewController data source after first app launch. Use CoreData or sqlite for that.
7) Current collection view layout is too boring. Lets change it to have similar pattern from TestLayout.xib file. Custom collection view layout should be used. Make sure that full width is used for iPhone screen sizes.