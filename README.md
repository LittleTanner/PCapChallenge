# PCapChallenge
A coding challenge for Personal Capital.

Create a mobile application that can be displayed in all orientations.  The application will do the following:
<ul>
  <li>
    Parse the RSS feed https://www.personalcapital.com/blog/feed/json and asynchronously load the contents of the feed.  Display a loading indicator while the feed is loading as well as for each image.</li>
  <ul>
    <li>Each article is represented in an item node.  Each article has an html encoded title represented in the title node, an image represented in the featured_image node, a quick html encoded summary represented in the summary node, a publish date represented in the date_published node, a link to the article represented in the url node, and the content of the article represented in the content_html node.</li>
  </ul>
  <li>
    The main screen should display the title of the feed represented in the feed’s html encoded title node and display each article in a scrolling list that correctly utilizes the space of the device screen.  
  </li>
  <ul>
    <li>
      The first article should take prominence at the top and display the image, title on one line with the rest ellipsed if necessary, and the first two lines of the summary with the rest ellipsed if necessary.
    </li>
    <li>
      Each article after should be displayed underneath the main article and represented by the image and title underneath (rendering at most 2 lines of the title with the rest ellipsed if necessary).
    </li>
    <li>
      For handset, the articles should be in rows of 2.
    </li>
    <li>
      For tablet, the articles should be in rows of 3.
    </li>
    <li>
      HTML encoded content should be rendered correctly.
    </li>
    <li>
      The screen should contain a “refresh” button in the upper right corner of the navigation bar which will query the RSS feed and refresh the screen.
    </li>
  </ul>
  <li>
    Selecting an article will render the content_html in an embedded webview on another screen with the title of the article displayed in the navigation bar.
  </li>
</ul>

Use this exercise to display your programming and aesthetic style.  Please include any additional details that you believe may improve the user experience.

Please try to not use third party libraries and thoroughly comment the code.  If completing for iPhone/iPad, use Objective-C without using Interface Builder or Storyboards.  If completing for Android, use Java or Kotlin without using XML layouts or drawables.
