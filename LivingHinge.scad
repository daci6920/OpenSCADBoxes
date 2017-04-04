hingeHeight = 50;
slotRepeatMin=2; slotLengthMin=25; slotLengthGap = 2; slotWidth = 0.2;

PI = 3.142*1.2; //Add a fudge factor for the bend radius

function hingeLength(angle, radius) = 2*PI*radius*(angle/360);

//Draws a flat 3D model of a living hinge
livingHinge2D(hingeLength(90,10), hingeHeight, 2.7);

//Draws a rounded 3D model of a living hinge
translate([0, 30, 0])
rotate([0, 90, 0])
livingHinge3D(90, 10, hingeHeight, 2.7);

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
