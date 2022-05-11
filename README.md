# monologue
an app that takes what is spoken &amp; turns it into text for future reference 

The goal of Monologue is to take the words spoken by its users and turn into a simplified text version hands-free. With fun and interesting categories already preselected for the user, they are able to choose what best fits the theme of the message they are creating. After the voice to text feature is used, the user is then able to edit, reposition the new note under a different category via a drop down scroll menu as well as export to a PDF and print, send or save to their device locally. 

Design wise, Monologue is user friendly with the large cards that a user can swipe through due its formatted behavior in a carosel collection view. The functionality of Monologue also allows for the user to imput notes via the main view as well as from within a category after tapping on a single card.

Here is a screen record demonstration of the application.

https://user-images.githubusercontent.com/63068679/167920123-44aa16e6-d6b2-4ba1-b5eb-2a938837b2ad.mp4

Here is a code snippet of how the recording works. After a user authorizes Monologue to access their mic, they are able to record a message using the microphone on their device. Once they begin speaking, this function `recordAndTranscribe` gets called and begins transcribing so it will be output on the screen as text.

<img width="814" alt="Screen Shot 2022-05-11 at 12 27 16 PM" src="https://user-images.githubusercontent.com/63068679/167930111-c209f482-d0d1-4d8d-b114-cc626b49f951.png">
