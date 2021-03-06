include <gearLib.scad>

caseLength=94;
caseWidth=53;
caseHeight = 42; //36
wallThickness = 1.5;

//**********************************Lid***************************************************
module drawLidBase(x,y,z)
{
	translate([x, y-wallThickness, z]) cube([caseLength + wallThickness,caseWidth + (wallThickness*2),4]);

	//pads to help prevent pealing
	translate([x, y, z]) cylinder(h = 0.2,r = 8);
	translate([x, y+caseWidth, z]) cylinder(h = 0.2,r = 8);
	translate([x+caseLength, y, z]) cylinder(h = 0.2,r = 8);
	translate([x+caseLength, y+caseWidth, z]) cylinder(h = 0.2,r = 8);

	//lip
	translate([x+2, y+2, z+4]) cube ([1.5,caseWidth-4.5,caseHeight-11]);
	translate([x, y+3.75, z+4]) cube ([2,caseWidth-7.5,caseHeight-11]);


	//Catches
	difference()
	{
		translate([x+caseLength-16,y-1,z+4]) cube([8,5.5,6]);
		translate([x+caseLength-16,y-1,z+4]) cube([8,2,3.9]);
		translate([x+caseLength-16,y-1.7,z+5.8]) rotate([45,0,0]) cube([8,3,3]);
	}

	difference()
	{
		translate([x+caseLength-16,y + caseWidth - 4,z+4]) cube([8,5.5,6]);
		translate([x+caseLength-16,y + caseWidth - 0.5,z+4]) cube([8,2,3.5]);
		translate([x+caseLength-16,y + caseWidth + 1.7, z+5.4]) rotate([45,0,0]) cube([8,3,3]);
	}

	//draw the curved top
	difference()
	{
		translate([x+caseLength/2,y+caseWidth+13.7,z]) cylinder(h = 4,r = caseLength*0.8);
		translate([x-caseLength/2,y-caseLength+100,z]) cube([caseLength*2,caseLength*2+10,4]);
	}

	translate([x+(caseLength+23.5)/2,  y+ caseWidth+wallThickness , z]) cube([8,3,8]);
	translate([x+(caseLength-23.5)/2-8,  y+ caseWidth+wallThickness , z]) cube([8,3,8]);
}

module drawLidCutouts(x,y,z)
{
	//Gear hole
	translate([x+(caseLength/2), y+(caseWidth/2), z+0.5]) cylinder(h = 3.5,r = 18);

	//Top Rail
	translate([x, y+(caseWidth/2 - 21), z+0.5]) cube([caseLength-wallThickness,11,3]);
	translate([x+(caseLength-30)/2, y+(caseWidth/2 - 21), z+3]) cube([30,11,1]);

	//Bottom Rail
	translate([x+5, y+(caseWidth/2 + 10), z+0.5]) cube([caseLength-wallThickness,11,3]);
	translate([x+(caseLength-30)/2, y+(caseWidth/2 + 10), z+3]) cube([30,11,1]);

	//Cutout for lip
	translate([x+(caseLength-23.5)/2, y+ caseWidth - 3, z]) cube([23.5,4.5,4]);
}

module drawLid(x,y,z)
{
	difference()
	{
		drawLidBase(x,y,z);
		drawLidCutouts(x,y,z);
	}
	translate([x+(caseLength/2),y+(caseWidth/2),z+0.5]) cylinder(h = 3.5,r = 4);
}



//*****************************Rack and Pinion*******************************************

module drawGear(x,y,z)
{
	difference() 
	{
		translate([x,y,z]) cylinder(h = 0.5,r = 17);
		translate([x,y,z]) cylinder(h = 0.5,r = 5);
	}
	//12.23 radius  -   circular_pitch * number_of_teeth / 360
	translate([x, y, z+0.5]) gear(number_of_teeth=12, circular_pitch=367, hub_thickness=0, bore_diameter=9,rim_thickness=2, gear_thickness=2);
}

module drawLeftRack(x,y,z)
{
	//mm_per_tooth = 2 * Pi * r / gear_teeth
	difference()
	{
		translate([x+caseLength-106,y,z+(1.5/2)]) rack(height=9, mm_per_tooth=6.4, number_of_teeth=9, thickness=wallThickness);
		translate([x+caseLength-106-7.5,y-7,z+1.5-4.5]) rotate([0,30,0])  cube ([5,5,5]); //Angle tip
		//translate([x,y,z+(1.5/2)]) rack(height=9, mm_per_tooth=6.4, number_of_teeth=9, thickness=wallThickness);
		//translate([x-7.5,y-7,z+1.5-4.5]) rotate([0,30,0])  cube ([5,5,5]); //Angle tip
	}

	translate([x+(caseLength-50),y-7,z]) cube([(caseLength-63.7),5,wallThickness]);
	translate([x+(caseLength-50 + caseLength-63.7),y-8-5,z]) cube([wallThickness,46,15]);
	difference(){
		translate([x+(caseLength-50 + caseLength-63.7)-5+wallThickness,y-8-5,z+15]) cube([5,46,5]);
		translate([x+(caseLength-50 + caseLength-63.7)-wallThickness,y-8-5,z+13]) rotate([0,315,0]) cube([2.5,46,5]);
	}
}

module drawRightRackCap(x,y,z)
{
	translate([x+5,y-49.5,z]) cube([23.5,48,1.5]);
	translate([x+5,y-49.5,z+1.5]) cube([1.5,48,15]);
}

module drawRightRack(x,y,z)
{
	difference()
	{
		translate([x+(caseLength-6.3),y,z+(1.5/2)]) rotate([0,0,180]) rack(height=9, mm_per_tooth=6.4, number_of_teeth=9, thickness=wallThickness);
		translate([x+(caseLength-3.8),y,z]) rotate([0,60,0])  cube ([5,15,5]); //Angle tip
	}


	translate([x,y+2,z]) cube([caseLength-59.7,5,1.5]);

	difference()
	{
		translate([x-15,y-51+11,z]) cube([15,47,15]);
		translate([x-15,y-51+13,z+wallThickness]) cube([15,43.5,78]);
		translate([x-13,y-51+13,z]) cube([13,40,8]);
	}

}





//*****************************Case***************************************************

module drawLogo(x,y,z)
{
	union() {
		translate([x,y,z])  rotate([90,0,0]) cylinder(h = wallThickness*4,r = 3.75);

		translate([x-3.75,y-wallThickness*4,z-6])  cube([7.5,wallThickness*4,6]);
		translate([x-6,y,z-3])  rotate([90,0,0]) drawLogoExtremity();
		translate([x-1.875,y,z-6])  rotate([90,0,0]) drawLogoExtremity();
		translate([x+1.875,y,z-6])  rotate([90,0,0]) drawLogoExtremity();
		translate([x+6,y,z-3])  rotate([90,225,0]) drawLogoExtremity();
	}
}

module drawLogoExtremity()
{
	cylinder(h = wallThickness*4,r = 1.5);
	translate([-1.5,-3,0]) cube([3,3,wallThickness*4]);
	translate([0,-3,0]) cylinder(h = wallThickness*4,r = 1.5);
}

module drawCase(x,y,z)
{
	stepsH=(caseHeight-11)/6;
	stepsL=(caseLength-12)/12;

	//pads to help prevent pealing
	translate([x, y+2, z]) cylinder(h = 0.2,r = 8);
	translate([x+caseLength, y+2, z]) cylinder(h = 0.2,r = 8);
	translate([x, y+caseWidth+(wallThickness*2), z]) cylinder(h = 0.2,r = 8);
	translate([x+caseLength, y+caseWidth, z]) cylinder(h = 0.2,r = 8);

	difference()
	{
		//Bottom and screw holes
		translate([x,y+(wallThickness*2),z]) cube([caseLength,caseWidth,wallThickness]);

		translate([x+wallThickness+6,y+(wallThickness*2)+6,z]) cylinder(h = wallThickness,r = 1.5);
		translate([x+wallThickness+6,y+caseWidth+(wallThickness*2)-6,z]) cylinder(h = wallThickness,r = 1.5);
		translate([x+caseLength-6,y+(wallThickness*2)+6,z]) cylinder(h = wallThickness,r = 1.5);
		translate([x+caseLength-6,y+caseWidth+(wallThickness*2)-6,z]) cylinder(h = wallThickness,r = 1.5);

		//Hole for furnace wires
		translate([x+(wallThickness*2),y+13,z]) cube([8,31,wallThickness]);
		translate([x+(wallThickness*2)+8,y+(wallThickness*2),z]) cube([10,caseWidth,wallThickness]);
	}


	//Side walls
	difference() {
		union(){
			translate([x,y+wallThickness,z]) cube([caseLength,wallThickness,caseHeight]);
			translate([x,y+caseWidth+(wallThickness*2),z]) cube([caseLength,wallThickness,caseHeight]);

			//draw the curved top
			difference()
			{
				translate([x+caseLength/2,y-10.7,z]) cylinder(h = caseHeight,r = caseLength*0.8);
				translate([x-caseLength/2,y-caseLength-(caseLength/2),z]) cube([caseLength*2,caseLength*2+10,caseHeight]);
			}
		}

		//Cut away the inside of the curved top
		difference()
		{
//			translate([x+caseLength/2,y-32-wallThickness,z+wallThickness]) cylinder(h = caseHeight-wallThickness,r = caseLength);
			translate([x+caseLength/2,y-32-wallThickness,z+wallThickness+4]) cylinder(h = caseHeight-wallThickness,r = caseLength);
			translate([x-caseLength/2,y-caseLength-(caseLength/2)-wallThickness,z]) cube([caseLength*2,caseLength*2+10,caseHeight]);
		}


		drawLogo(x+(caseLength/2)+1.5,y+4,z+(wallThickness*2)+18);
		rotate([0,0,180]) drawLogo(-x-(caseLength/2)-0.5,-y-caseWidth-wallThickness*2-3,z+(wallThickness*2)+18);

		//Lid catches		
		 translate([x+caseLength-16,y,z+caseHeight-9]) cube([9,3,6]);
		 translate([x+caseLength-16,y+caseWidth+(wallThickness*2),z+caseHeight-9]) cube([9,3,6]);
	}

	//board catch	
//	translate([x,y+caseWidth+(wallThickness*2),z]) cube([caseLength,wallThickness,8]);

	//back wall
	difference()
	{
		translate([x+caseLength,y+wallThickness,z]) cube([wallThickness,caseWidth+(wallThickness*2),caseHeight]);
		translate([x+caseLength,y+(caseWidth-10)/2, caseHeight-5]) cube([wallThickness,10,5]);
//		translate([x+caseLength-wallThickness,y+caseWidth/2,caseHeight-4]) rotate([0,90,0]) cylinder(h = wallThickness*2,r = 4);
	}


	//Lip
	difference()
	{
		translate([x+(caseLength-18.5)/2,y+wallThickness,z+caseHeight-wallThickness]) cube([20,wallThickness*2,17+wallThickness]);
		translate([x+(caseLength-18.5)/2,y+wallThickness*2+1,z+caseHeight-wallThickness-1]) rotate([45,0,0]) cube([20,wallThickness*2,wallThickness]);
	}

	translate([x+(caseLength-18.5)/2,y+wallThickness,z+caseHeight+17]) cube([20,3*2,2]);

	//Grooves
	difference()
	{
		translate([x,y+(wallThickness*2),z]) cube([5,3,caseHeight]);
		translate([x+wallThickness,y+(wallThickness*2),z]) cube([2,3,caseHeight]);
	}
	difference()
	{
		translate([x,y+caseWidth,z]) cube([5,3,caseHeight]);
		translate([x+wallThickness,y+caseWidth,z]) cube([2,3,caseHeight]);
	}

	translate([x,y+(wallThickness*2),z]) cube([5,caseWidth,10]);

}








//*****************************Combinations**********************************************


module drawAssembled(x,y,z)
{
	drawCase(x,y,z);
	rotate([180,0,0]) drawLidAssembled(x,y-54,-z - 40);
}

module drawLidAssembled(x,y,z)
{
	drawLid(x,y,z);
	drawGear(x + caseLength/2, y+caseWidth/2, z+wallThickness);
	rotate([0,180,0]) drawLeftRack(-x-(caseLength-20), y+14, -z-3.5);
	rotate([0,180,0]) drawRightRack(-x-(caseLength+5), y+37, -z-3.5);
	rotate([0,270,0]) drawRightRackCap(z-18, y+46, -x-(caseLength+20));
}

module drawExploded(x,y,z)
{
	% translate([x-20,y-10,z-1]) cube([210,135,1]);
	drawLid(x,y,z);
	drawExplodedRackAndPinion(x,y+73,z);
	rotate([0,0,90]) drawCase(y,-x-180,z);
}

module drawExplodedRackAndPinion(x,y,z)
{
	drawLeftRack(x+111-caseLength, y, z);
	drawGear(x + 70, y+20, z);
	drawRightRack(x-(98-caseLength), y+41, z);
	rotate([0,0,90]) drawRightRackCap(y+7, -x, z);
}

//drawAssembled(0, 0, 0);
drawExploded(0, 0, 0);
//drawExplodedRackAndPinion(0,0,0);
//drawLid(0,0,0);
//drawCase(0,0,0);





