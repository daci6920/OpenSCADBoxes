# OpenSCADBoxes
Lasercuttable Flexboxes designed in OpenSCAD
This repository contains a number of OpenSCAD scripts for parametrically generating boxes using the living hinges. The scripts are capable of modelling the boxes as flat pieces or assembled items and then able to export them as 2 dimensional drawings suitable for laser cutting.

These boxes were designed as sample models to coincide with the launch of our new [vanillabox lasercutter](https://vanillabox.myshopify.com/)

![](https://github.com/msraynsford/OpenSCADBoxes/blob/master/images/_MG_0274%20(Custom).jpg)

The [first script](https://github.com/msraynsford/OpenSCADBoxes/blob/master/LivingHinge.scad) generates a small section of living hinge and the 3D models that go along with it. The script allows you to adjust the number of repeats in both X and Y axis, the gaps between the lines and it ensures that the lines/gaps are drawn evenly along the length of the hinge.

![](https://github.com/msraynsford/OpenSCADBoxes/blob/master/images/Screenshot%202017-04-03%2011.33.33.png)

The [second script](https://github.com/msraynsford/OpenSCADBoxes/blob/master/FlexBox1.scad) puts a literal twist on the familiar parameteric flex boxes; by rotating the second curve 90 degrees we were able to create a box using just two panels (a bit like a tennis ball). The script puts all the curves and tabs in the correct places and allows a variable corner radius too.

![](https://github.com/msraynsford/OpenSCADBoxes/blob/master/images/IMG_5071%20(Custom).JPG)

![](https://github.com/msraynsford/OpenSCADBoxes/blob/master/images/Screenshot%202017-04-03%2011.31.34.png)


The [third script](https://github.com/msraynsford/OpenSCADBoxes/blob/master/FlexBox2.scad) creates a more standard flex box with 3 panels and an oversized lid. The final wall is split in the middle and all the tabs lock into the lid which prevent it from springing open when it's not glued down.

![](https://github.com/msraynsford/OpenSCADBoxes/blob/master/images/IMG_5342%20(Custom).JPG)

![](https://github.com/msraynsford/OpenSCADBoxes/blob/master/images/Screenshot%202017-04-03%2013.49.57.png)
