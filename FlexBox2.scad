height = 30; width = 100; depth = 60;
thickness = 2.7; cornerRadius = 10; tabLength = 10;

slotRepeatMin=2; slotLengthMin=20; slotLengthGap = 2; slotWidth = 0.2;

PI = 3.142*1.02; //Add a fudge factor for the bend radius
function hingeLength(angle, radius) = 2*PI*radius*(angle/360);

//Use true to generate 3D models of the box parts
//Use false to generate 2D models which can be exported
if(false)
{
  //Draws a folded version of the box
  translate([-depth, width, height])
    makeBox(false);

  //Draws a flat version of the box
  translate([depth*2, width,0])
    makeBox(true);
}
else
{
  // Projection allows it to draw a 2D version of the box
  // Which can be saved as SVG
  projection()
  translate([depth*2, width,0])
    makeBox(true);
}

// Generates the box in flat or folded parts
module makeBox(flat)
{
  if(flat)
  {
    union() 
    {
      translate([-width*.75, depth*2, (height+thickness)/2])
        boxLid(height, width, depth, thickness, cornerRadius);
      
      translate([-width*.75, 0, (height+thickness)/2])
        boxLid(height, width, depth, thickness, cornerRadius);
 
      translate([0,width, 0])     
        boxSide2D(height, depth, width, thickness, cornerRadius, true);
    }
  }
  else
  {
    boxSide3D(height, width, depth, thickness, cornerRadius, true);
   
    translate([0,0,-10]) 
      boxLid(height, width, depth, thickness, cornerRadius);
   
    translate([0,0,height +10]) 
      boxLid(height, width, depth, thickness, cornerRadius);
  }
}

module boxLid(height, width, depth, thickness, cornerRadius)
{
    difference()
    {
      translate([0, 0, -(height+thickness)/2])
        roundedRectangle(width+(thickness*2), depth+(thickness*2), thickness, cornerRadius);
      
      translate([0,0,+0.05])
        boxSide3D(height, width, depth, thickness+.1, cornerRadius, true);
    }
}

module roundedRectangle(panelWidth, panelDepth, panelThickness, radius) 
{
  sub = 48;
  faceWidth = panelWidth - (2*radius + panelThickness);
  faceDepth = panelDepth - (2*radius + panelThickness);
  cornerX = panelDepth/2 - radius;
  cornerY = panelWidth/2 - radius;
    
  union() 
  {
    cube([faceDepth, panelWidth + (2*panelThickness), panelThickness], true);
    cube([panelDepth+ (2*panelThickness), faceWidth, panelThickness], true);

    translate([0,0,-panelThickness/2])
    {
      translate([cornerX,cornerY,0])
        cylinder(r=radius + panelThickness, h=panelThickness, $fn=sub);
      translate([-cornerX,cornerY,0])
        cylinder(r=radius + panelThickness, h=panelThickness, $fn=sub);
     
      translate([cornerX,-cornerY,0])
        cylinder(r=radius + panelThickness, h=panelThickness, $fn=sub);
      translate([-cornerX,-cornerY,0])
        cylinder(r=radius + panelThickness, h=panelThickness, $fn=sub);
    }
  }
}


module boxSide3D(height, width, depth, thickness, cornerRadius, tabsOut)
{
  faceWidth1 = depth-(2*cornerRadius);
  faceWidth2 = width-(2*cornerRadius);
  faceHeight = height;

  translate([(faceWidth1+thickness)/2 + cornerRadius,0,0])
  {
    translate([0,(faceWidth2+thickness)/2 + cornerRadius,0])
      livingHinge3D(90, cornerRadius, faceHeight, thickness);
      
    translate([0, -(faceWidth2+thickness)/2 - cornerRadius,0])
      rotate([0,0,-90])
        livingHinge3D(90, cornerRadius, faceHeight, thickness);
    
    rotate([0,90,0])
      tabPanel(faceHeight, faceWidth2, thickness, tabLength, tabsOut);
  }
 
  translate([-(faceWidth1+thickness)/2 - cornerRadius,0,0])
  rotate([0,0,180])
  {
    translate([0,(faceWidth2+thickness)/2 + cornerRadius,0])
      livingHinge3D(90, cornerRadius, faceHeight, thickness);
      
    translate([0, -(faceWidth2+thickness)/2 - cornerRadius,0])
      rotate([0,0,-90])
        livingHinge3D(90, cornerRadius, faceHeight, thickness);
    
    //Make 2 half panels for the final side
    translate([0,faceWidth2/4,0])
    rotate([0,90,0])
      tabPanel(faceHeight, faceWidth2/2, thickness, tabLength, tabsOut);

    translate([0,-faceWidth2/4,0])
    rotate([0,90,0])
      tabPanel(faceHeight, faceWidth2/2, thickness, tabLength, tabsOut);
  }
   
  rotate([-90,90,0])
  {
    translate([0,0,(faceWidth2+thickness)/2 + cornerRadius])
      tabPanel(faceHeight, faceWidth1, thickness, tabLength, tabsOut);
        
    translate([0,0,-(faceWidth2+thickness)/2 - cornerRadius])
      tabPanel(faceHeight, faceWidth1, thickness, tabLength, tabsOut);
  }
}

module boxSide2D(height, width, depth, thickness, cornerRadius, tabsOut)
{
  faceWidth1 = depth-(2*cornerRadius);
  faceWidth2 = width-(2*cornerRadius);
  hingeLength1 = hingeLength(90, cornerRadius);
  union()
  {
    tabPanel(height, faceWidth1, thickness, tabLength, tabsOut);
    boxPart2D(height, width, depth, thickness, cornerRadius, tabsOut);
 
    mirror([0,1,0])
      boxPart2D(height, width, depth, thickness, cornerRadius, tabsOut);
  } 
}

module boxPart2D(height, width, depth, thickness, cornerRadius, tabsOut)
{
  faceWidth1 = depth-(2*cornerRadius);
  faceWidth2 = width-(2*cornerRadius);
  hingeLength1 = hingeLength(90, cornerRadius);

  translate([0,(faceWidth1 + hingeLength1)/2,0])
  {
    livingHinge2D(hingeLength1, height, thickness);
  
    translate([0,(hingeLength1 + faceWidth2)/2,0])
    {
      tabPanel(height, faceWidth2, thickness, tabLength, tabsOut);
      
      translate([0,(hingeLength1 + faceWidth2)/2,0])
      {
        livingHinge2D(hingeLength1, height, thickness);
  
        translate([0,(hingeLength1 + faceWidth2)/2,0])
          tabPanel(height, faceWidth1/2, thickness, tabLength, tabsOut);
      }
    }
  }
}

module tabPanel(panelHeight, panelWidth, panelThickness, tabLength, tabsOut=false)
{
  noTabsX = panelWidth /tabLength;
  noTabs = floor(noTabsX/2)+floor(noTabsX)%2;
  
  if(tabsOut)  
  union()
  {
    cube([panelHeight, panelWidth , panelThickness], true);

    union()
    {
      translate([(panelHeight+panelThickness)/2,0,0])
        rotate([0,0,90])
          makeTabs(noTabs, tabLength, panelThickness);

      translate([(-panelHeight-panelThickness)/2,0,0])
        rotate([0,0,90])
          makeTabs(noTabs, tabLength, panelThickness);
    }
  }
  
  else
  difference()
  {
    cube([panelHeight, panelWidth , panelThickness], true);

    union()
    {
      translate([(panelHeight-(3*panelThickness))/2,0,0])
        rotate([0,0,90])
          makeTabs(noTabs, tabLength, panelThickness);

      translate([(-panelHeight+(3*panelThickness))/2,0,0])
        rotate([0,0,90])
          makeTabs(noTabs, tabLength, panelThickness);
    }
  }
}

module makeTabs(noTabs, tabLength, panelThickness)
{
  union()
    for (i =[-noTabs+1:2:noTabs-1])
      translate([(i*tabLength),0,0])
        cube([tabLength, panelThickness, panelThickness], true);
}

module livingHinge2D(panelLength, panelWidth, panelThickness) 
{
  widthDiv = floor(panelWidth/slotLengthMin);
  noSlots = floor(panelLength/slotRepeatMin)-1;
  slotRepeat = (panelWidth/widthDiv); 
  slotLength = panelLength / (noSlots + 1);

  difference() 
  {
    cube([panelWidth, panelLength, panelThickness], true);
    
    translate([-panelWidth/2,-panelLength/2,-panelThickness/2])
    for(y=[0:(widthDiv*2)-1]) 
    {           
      for (x =[1:noSlots])
      {
        if(x%2)
          translate([y*slotRepeat,0,0])
            translate([slotLengthGap*(y%2),(slotLength *x)-slotWidth/2,0])
              cube([slotRepeat-slotLengthGap, slotWidth, panelThickness]);
        else
          translate([y*slotRepeat,0,0])
            translate([slotLengthGap*(1-(y%2)),(slotLength *x)-slotWidth/2,0])
              cube([slotRepeat-slotLengthGap, slotWidth, panelThickness]);
      }
    }
  }
}

module livingHinge3D(angle, radius, panelWidth, panelThickness) 
{
  module pie(radius, angle, height, spin=0) 
  {
    // submodules
    module pieCube() 
    {
      translate([-radius - 1, 0, -1]) 
        cube([2*(radius + 1), radius, height + 2]);
    }
        
    ang = abs(angle % 360);
    negAng = angle < 0 ? angle : 0;
        
    rotate([0,0,negAng + spin]) 
    {
      if (angle == 0) 
        cylinder(r=radius, h=height, $fn=48);
      
      else if (abs(angle) > 0 && ang <= 180) 
      {
        difference() 
        {
          intersection() 
          {
            cylinder(r=radius, h=height, $fn=48);
            translate([0,0,0]) 
              pieCube();
          }
          
          rotate([0, 0, ang])
            pieCube();
        }
      } 
      else if (ang > 180) 
      {
        intersection() 
        {
          cylinder(r=radius, h=height, $fn=48);
          union() 
          {
            translate([0, 0, 0])
              pieCube();
            
            rotate([0, 0, ang - 180])
              pieCube();
          }
        }
      }
    }
  }
  
  translate([-(radius+(panelThickness/2)),-(radius+(panelThickness/2)),-panelWidth/2])
    rotate([0,0,0])
      difference() 
      {
        pie(radius+panelThickness, angle, panelWidth, spin = 0);
        pie(radius, angle, panelWidth, spin = 0);
      }
}
