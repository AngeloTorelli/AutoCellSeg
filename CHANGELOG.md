
# Changelog of AutoCellSeg
Here you can see all the changes made after each commit.

## 1.0.3 (2017-07-19)

Features:

  - Newly added points can be deleted by right clicking without updating.
  - Only one image can be opened at once to avoid internal collisions.
  - Adapt title length for the thumbnails.
  - Raised errors give a full report for users to start new issues in the repository and resets the gui.
  - Main window is locked during a priori selection.
  - The size of the image is displayed in the figure title.
  - The internal function of matlab: impixelinfo is activated when looking at pictures.


Bugfixes:

  - Optimized working flow of zoom functionality.
  - File name containing underscore are displayed correctly.
  - Error rising when zoom is activated were resolved.
  - Calculated features are updated and saved correctly after correction.
  - Cells on image borders are segmented correctly now.


## 1.0.2 (2017-07-10)

Features:

  - Added zoom functionality in form of a button during selection and correction.
  - Catching of errors and displaying them in a message dialog.
  - Saving the parameters as a text file in the result folder.
  - Possibility to load parameters saved from a previous experiment.
  - Tooltips for buttons added.
  - Tooltips for long titles added.
  - Interactions with AutoCellSeg are blocked when processing to avoid errors.
  - Manual selection of color. If a comparison between experiments is possible, the other color becomes the opposite to the selected one.
  - Thumbnails are updated to the overlay image after processing and after every correction.
  - Create plots is only available when images of two experiment are loaded properly.
  - The name of the image is displayed when viewing single images.
  - The name of the image is display as a window title.


Bugfixes:

  - Parameters can also be changed if no pictures are loaded.
  - Wrong titles in thumbnails are now displayed correctly.
  - Errors when process is aborted in partially automated was fixed.

## 1.0.1 (2017-06-13)

Features:

  - Changed name to AutoCellSeg to avoid conflict with existing project.
  - Images with light background can also be processed.
  - Works also for images that do not contain a tag for control or test images.
  - Folder dialog added when saving the results.


Bugfixes:

  - Unabled buttons while processing to avoid crashes.
  - Unabled buttons while loading images to avoid crashes.
  - Loading of more than 20 picture without viewing them was corrected.
  - Corrected instructions in different situations.
  - Shortened instructions to fit the screen better.
  - Unable creation of plots when the images are not separated in a control and test group.
