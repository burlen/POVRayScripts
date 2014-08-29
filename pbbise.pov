#version 3.7;
#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "metals.inc"
#include "math.inc"
#include "transforms.inc"
#include "finish.inc"

global_settings {
    ambient_light color rgb <1.0, 1.0, 1.0>
    assumed_gamma 2
}

#declare run = 0;
#declare SingleBondColor = true;
#declare RenderCrystalSingle = true;
#declare RenderCrystalWide = true;
#declare RenderCoordPolySingle = true;

#declare RenderCrystalDeep = false;
#declare RenderCoordPolyDeep = false;

#declare R1 = 41;
#declare HViewAngle = 40;

// set clock by +KX on command line
// or clock=X
/*#declare run = 0;
#if (clock < 5)
    #declare run = clock;
    #declare R1 = 62;
    #declare HViewAngle = 50;
#else
    #declare run = clock - 4;
    #declare R1 = 62;
    #declare HViewAngle = 40;
#end
#switch (run)
    #case (1.0)
        #declare RenderCrystalSingle = true;
        #declare RenderCrystalDeep = false;
        #declare RenderCoordPolySingle = false;
        #declare RenderCoordPolyDeep = false;
    #break
    #case (2.0)
        #declare RenderCrystalSingle = true;
        #declare RenderCrystalDeep = false;
        #declare RenderCoordPolySingle = true;
        #declare RenderCoordPolyDeep = false;
    #break
    #case (3.0)
        #declare RenderCrystalSingle = true;
        #declare RenderCrystalDeep = true;
        #declare RenderCoordPolySingle = false;
        #declare RenderCoordPolyDeep = false;
    #break
    #case (4.0)
        #declare RenderCrystalSingle = true;
        #declare RenderCrystalDeep = true;
        #declare RenderCoordPolySingle = true;
        #declare RenderCoordPolyDeep = false;
    #break
//    #case (5.0)
//        #declare RenderCrystalSingle = true;
//        #declare RenderCrystalDeep = true;
//        #declare RenderCoordPolySingle = true;
//        #declare RenderCoordPolyDeep = true;
//    #break
#end*/

// --------------------------------------------------------------------------
// parameters
#declare AtomTheta = 0;
#declare AtomPhi = 0;

//#declare Theta = radians(clock*360.0);
#declare Theta = radians(90);
#declare Phi = radians(270);
#declare CamPos = <R1*sin(Theta)*cos(Phi), R1*sin(Theta)*sin(Phi), R1*cos(Theta)>;
#declare CamRight = <-sin(Phi), cos(Phi), 0>;
#declare CamUp = <-cos(Theta)*cos(Phi), -cos(Theta)*sin(Phi), sin(Theta)>;
#declare CamAt = <0,0,0>;
#declare Aspect = image_width/image_height;
#declare VViewAngle = HViewAngle*Aspect;

#declare CamDir = CamPos/vlength(CamPos);
#declare DomeRot = <degrees(acos(CamDir.y)), degrees(acos(CamDir.z))>;

// --------------------------------------------------------------------------
// background
#declare MakeMask = false;
#if (MakeMask)
    background { color White }
#else
    #declare BG1 = rgb <255 245 245>/255.0;
    #declare BG2 = rgb <30 30 30>/255.0;
    sky_sphere {
    pigment {
        gradient y
        color_map {
           [0.0 color BG1]
           [0.06 color BG2]
           //[0 rgb <1,1,1>]
           //[0.00001 rgb <1,1,0>]
           //[0.006 rgb <1,0,0>]
           //[0.1 rgb 0]
            }
        scale 2
        translate -1
        }
      rotate -90*x
      rotate mod(degrees(Theta) + 180,360)*y
      rotate mod(degrees(Phi),360)*z
    }
#end

// --------------------------------------------------------------------------
// axes
#declare AxesFinish = finish { ambient 0.5 diffuse 1 }
#declare XVector = union {
cylinder { <0,0,0> x*5 0.25 }
cone { x*5,2 x*5+x*3,0 }
}
#declare Axes = union {
cylinder { <0,0,0> x*10 0.5 finish {AxesFinish } pigment { color Red } }
cylinder { <0,0,0> y*10 0.5 finish {AxesFinish } pigment { color Green } }
cylinder { <0,0,0> z*10 0.5 finish {AxesFinish } pigment { color Blue } }
cone { x*10,1 x*10+x*3,0  finish {AxesFinish } pigment { color Red } }
cone { y*10,1 y*10+y*3,0 finish {AxesFinish } pigment { color Green } }
cone { z*10,1 z*10+z*3,0 finish {AxesFinish } pigment { color Blue } }
};
//object { Axes }


// --------------------------------------------------------------------------
// lights
#declare CamLight=light_source {
    CamPos
	color <1.000000, 1.000000, 1.000000>*1.0000000
    area_light <100, 0, 0>, <0, 0, 100>, 10, 10
	parallel
	point_at -CamPos
}

#declare CamLight2=light_source {
    -CamPos
    color <1.000000, 1.000000, 1.000000>*2.0000000
    area_light <100, 0, 0>, <0, 0, 100>, 10, 10
    parallel
    point_at CamPos
}


#declare DownLightAmp=1.5;
#declare DownLight0=light_source {
    <0.0, 100.0, 100.0>
	color <1.000000, 1.000000, 1.000000>*DownLightAmp
	parallel
	point_at <0.0, 0.0, 0.0>
}

#declare DownLight1=light_source {
    <0.0, -100.0, 100.0>
	color <1.000000, 1.000000, 1.000000>*DownLightAmp
	parallel
	point_at <0.0, 0.0, 0.0>
}

#declare DownLight2=light_source {
    <0.0, 100.0, 100.0>
	color <1.000000, 1.000000, 1.000000>*DownLightAmp
	parallel
	point_at <0.0, 0.0, 0.0>
}




// --------------------------------------------------------------------------
//#declare SingleCrystalBondColor=rgbft <1, 1, 1, 0, 0>;
#declare SingleCrystalBondColor = P_Chrome4;
//#declare SingleCrystalAtomColor83=rgbft <14, 255, 235, 0, 0>/255.0; // Bi
#declare SingleCrystalAtomColor83=rgbft <0.0392157, 0.776471, 1, 0, 0>; // Bi
#declare SingleCrystalAtomColor34=rgbft <0.85098, 0, 0, 0, 0>; // Se
#declare SingleCrystalAtomColor82=rgbft <26, 97, 241, 0, 0>/255.0; // Pb
//#declare SingleCrystalAtomColor82=rgbft <0, 0.529412, 0.894118, 0, 0>; // Pb

#declare SingleCrystalAtom83Scaling=1.05;
#declare SingleCrystalAtom34Scaling=0.95;
#declare SingleCrystalAtom82Scaling=1.1;
#declare SingleCrystalCylinderScaling=0.85;

#declare SingleCrystalAtomFinish=finish { F_MetalB }
/*#declare SingleCrystalAtomFinish=finish {
    ambient 0.1
    diffuse 0.55
    specular 0.6
    roughness 0.001
    // reflection { 0.45 metallic }
}*/

#declare SingleCrystalBondFinish=finish { F_MetalD }
/*#declare SingleCrystalBondFinish=finish {
    ambient 0.15
    diffuse 0.6
    specular 0.7
    roughness 0.0001
    // reflection { 0.95 metallic }
}*/

#if (RenderCoordPolySingle)
    #if (SingleBondColor)
        #include "./data/mol++.pov"
    #else
        #include "./data/mol-abonds.pov"
    #end
#else
    #if (SingleBondColor)
        #include "./data/just-mol++.pov"
    #else
        #include "./data/just-mol-abonds.pov"
    #end
#end

#declare Mn = min_extent(SingleCrystal);
#declare Mx = max_extent(SingleCrystal);

#if (RenderCrystalSingle)
    light_group {
        light_source { DownLight0 }
        light_source { DownLight1 }
        light_source { CamLight }
        light_source { CamLight2 }
        object {
            SingleCrystal
            Center_Trans(SingleCrystal, x+y+z)
            no_shadow
        }
    }
#end

// --------------------------------------------------------------------------
#if (RenderCrystalWide)

    #declare CamLight333=light_source {
        CamPos
    	color White*1.0
        area_light <100, 0, 0>, <0, 0, 100>, 10, 10
    	parallel
    	point_at -CamPos
    }

    #declare DownLightAmp3=1.75;
    #declare DownLight000=light_source {
        <0.0, 100.0, 100.0>
    	color <1.000000, 1.000000, 1.000000>*DownLightAmp3
    	parallel
    	point_at <0.0, 0.0, 0.0>
    }

    #declare DownLight111=light_source {
        <0.0, -100.0, 100.0>
    	color <1.000000, 1.000000, 1.000000>*DownLightAmp3
    	parallel
    	point_at <0.0, 0.0, 0.0>
    }

    #declare WideCrystalPos = clock;
    #declare WideCrystalBondColor = P_Chrome4;
    #declare WideCrystalAtomColor83=rgbft <0.0392157, 0.776471, 1, 0, 0>; // Bi
    #declare WideCrystalAtomColor34=rgbft <0.85098, 0, 0, 0, 0>; // Se
    #declare WideCrystalAtomColor82=rgbft <26, 97, 241, 0, 0>/255.0; // Pb
    #declare WideCrystalAtom83Scaling=1.05;
    #declare WideCrystalAtom34Scaling=0.95;
    #declare WideCrystalAtom82Scaling=1.1;
    #declare WideCrystalCylinderScaling=1.1;
    #declare WideCrystalAtomFinish=finish { F_MetalB }
    #declare WideCrystalBondFinish=finish { F_MetalD }

    #include "./data/mol-wide++.pov"
    light_group {
        light_source { DownLight000 }
        light_source { DownLight111 }
        light_source { CamLight333 }
        light_source { CamLight2 }
        object {
            WideCrystal
            Center_Trans(SingleCrystal, x+y+z)
            translate y*4.2619*WideCrystalPos
            no_shadow
        }
    }
#end

// --------------------------------------------------------------------------
#if (RenderCrystalDeep)

    #declare DeepCrystalBondColor=rgbft <1.0, 1.0, 1.0, 0, 0>*0.4;
    #declare DeepCrystalAtomColor83=rgbft <0.0392157, 0.776471, 1, 0, 0>;
    #declare DeepCrystalAtomColor34=rgbft <0.85098, 0, 0, 0, 0>;
    #declare DeepCrystalAtomColor82=rgbft <0, 0.529412, 0.894118, 0, 0>;
    #declare DeepCrystalSphereScaling=0.999;
    #declare DeepCrystalCylinderScaling=0.999;
    #declare DeepCrystalAtomFinish=finish {
        ambient 0.08
        diffuse 0.25
        specular 0.6
        roughness 0.001
        // reflection { 0.45 metallic }
    }
    #declare DeepCrystalBondFinish=finish {
        ambient 0.05
        diffuse 0.15
        specular 0.7
        roughness 0.01
        // reflection { 0.95 metallic }
    }

    #include "./data/just-mol-deep.pov"
    light_group {
        light_source { DownLight0 }
        light_source { DownLight1 }
        light_source { CamLight }
        object {
            DeepCrystal
            Center_Trans(SingleCrystal, x+y+z)
            no_shadow
            //translate -1.25*z
            //rotate -30*z
            //rotate AtomTheta*y
            //rotate AtomPhi*z
        }
    }
#end

// --------------------------------------------------------------------------
#if (RenderCoordPolySingle)

    //#declare Cen = (Mn + Mx)/2.0;
    #declare Cen = <0.0, 0.0, 0.0>;

    #declare LightX =  12.0;
    #declare LightY = -50.0;
    #declare LightZ =  2;

    #declare DL3Pos = Cen +  x*LightX + y*LightY +  z*LightZ;
    #declare DL4Pos = Cen + -x*LightX + y*LightY +  z*LightZ;
    #declare DL5Pos = Cen +  x*LightX + y*LightY + -z*LightZ;
    #declare DL6Pos = Cen + -x*LightX + y*LightY + -z*LightZ;

    #declare DLTex = texture { pigment { color  Red } finish { ambient 1 } }


    #declare CamLight22=light_source {
        CamPos
    	color <1.000000, 1.000000, 1.000000>*4.0000000
        area_light <100, 0, 0>, <0, 0, 100>, 10, 10
    	parallel
        //otlight
    	point_at -CamPos
    }

    #declare DownLightAmp2=0.8;
    #declare DownLight11=light_source {
        <0.0, -100.0, 100.0>
    	color White*DownLightAmp2
    	parallel
    	point_at <0.0, 0.0, 0.0>
    }

    #declare DownLight22=light_source {
        <0.0, 100.0, 100.0>
    	color White*DownLightAmp2
    	parallel
    	point_at <0.0, 0.0, 0.0>
    }



/*    #declare CoordPolySingleFinish=finish {
        ambient 0.3
        diffuse 0.1
        specular 1
        roughness 0.04
        //reflection { 0.25 falloff 8 }
        irid { 0.35 }
        } */
    #declare CoordPolySingleFinish=finish { ambient 0.05 specular 0.35 roughness 0.008 irid { 0.1 } }

    #declare CoordPolySingleF=0.4;
    #declare CoordPolySingleT=0.1;
//    #declare CoordPolySingleColor1 = color rgbft <0.000000, 0.741176, 0.945098, CoordPolySingleF, CoordPolySingleT>;
//    #declare CoordPolySingleColor1 = color rgbft <170/255, 211/255, 255/255, CoordPolySingleF, CoordPolySingleT>;
//    #declare CoordPolySingleColor1 = color rgbft <45/255, 82/255, 135/255, CoordPolySingleF, CoordPolySingleT>;

    #declare VioletCoordPoly = false;
    #if (VioletCoordPoly)
        #declare CoordPolySingleColor1 = color rgbft <97/255, 130/255, 207/255, CoordPolySingleF, CoordPolySingleT>;
        #declare CoordPolySingleColor2 = color rgbft <97/255, 130/255, 207/255, CoordPolySingleF, CoordPolySingleT>;
    #else
        #declare CoordPolySingleColor1 = color rgbft <0.000000, 0.647059, 1.000000, CoordPolySingleF, CoordPolySingleT>;
        #declare CoordPolySingleColor2 = color rgbft <0.000000, 0.647059, 1.000000, CoordPolySingleF, CoordPolySingleT>;
    #end

    //#include "./data/geom.pov"
    #include "./data/geom-subdiv.pov"

    light_group {

        //sphere { Cen, 0.75 texture { DLTex } }
        //light_source { DownLight3 } // sphere { DL3Pos, 0.75 texture { DLTex } }
        //light_source { DownLight4 } // sphere { DL4Pos, 0.75 texture { DLTex } }
        //light_source { DownLight5 } // sphere { DL5Pos, 0.75 texture { DLTex } }
        //light_source { DownLight6 } // sphere { DL6Pos, 0.75 texture { DLTex } }
        //light_source { CamLight2 }
        //light_source { DownLight7 }
        //light_source { DownLight8 }

        //#declare SuplLightColor = color rgb <64,0,255>/255.0; purple
        //#declare SuplLightColor = color rgb <97/255, 130/255, 207/255>;
        #declare SuplLightColor = Blue;

        #declare id = -15;
        #while (id < 15)
            #declare Pos = Cen-id*x-0.0;
            light_source {
                Pos
            	color SuplLightColor*0.2
                //looks_like { sphere { Pos, 0.75 texture { DLTex } } }
            }
            #declare id = id+5;
        #end

        light_source { DownLight11 }
        //light_source { DownLight22 }
        light_source { CamLight }

        object {
            CoordPolySingle
            no_shadow
            Center_Trans(SingleCrystal, x+y+z)
        }
    }
#end

// --------------------------------------------------------------------------
#if (RenderCoordPolyDeep)
    #declare CoordPolyDeepR=1.0;
    #declare CoordPolyDeepG=1.0;
    #declare CoordPolyDeepB=1.0;
    #declare CoordPolyDeepF=0.0;
    #declare CoordPolyDeepT=0.5;
    #include "./data/geom-just-deep.pov"
    #declare CoordPolyDeepFinish=finish {
        ambient 0.8
        diffuse 0.3
        specular 1
        roughness 0.001
        //reflection { 0.00125 falloff 8 }
    }
    light_group {

        light_source { DownLight0 }
        light_source { DownLight1 }
        light_source { CamLight }

        object {
            CoordPolyDeep
            no_shadow
            Center_Trans(SingleCrystal, x+y+z)
            translate <0, 4.2619, 0> // shift by one structure
            texture { finish { CoordPolyDeepFinish } }
            }
    }

#end

// --------------------------------------------------------------------------
#declare RenderBoxes = false;
#if (RenderBoxes)
    #declare BoxCAmp = 0.95;
    #declare WhiteVec = <1, 1, 1, 0, 0>;
    #declare BoxFT = <0, 0, 0, 0.0, 0.55>;
    #declare PlaneColor = color rgbft <1,1,1,0,0>;
    #declare BoxColor1 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxCAmp = BoxCAmp + 0.05;
    #declare BoxColor2 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxCAmp = BoxCAmp + 0.05;
    #declare BoxColor3 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxCAmp = BoxCAmp + 0.05;
    #declare BoxColor4 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxCAmp = BoxCAmp + 0.05;
    #declare BoxColor5 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxCAmp = BoxCAmp + 0.05;
    #declare BoxColor6 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxCAmp = BoxCAmp + 0.05;
    #declare BoxColor7 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxCAmp = BoxCAmp + 0.05;
    #declare BoxColor8 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxCAmp = BoxCAmp + 0.05;
    #declare BoxColor9 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxCAmp = BoxCAmp + 0.05;
    #declare BoxColor10 = color rgbft BoxCAmp*WhiteVec+BoxFT;
    #declare BoxFinish = finish { Glossy }
    #declare BoxEdgeColor = Black; //color rgbft <231, 72, 16, 0, 0>/255.0;
    #declare BoxEdgeFinish = finish { ambient 1 diffuse 0 specular 0 };
    #declare BoxEdgeWidth = 0.0625;
    #declare RenderBoxEdges = true;
    #include "boxes-sm.pov"

    #declare BoxDownLightAmp = 0.4;
    #declare BoxCamLightAmp = 0.6;

    #declare BoxCamLight=light_source {
        CamPos
    	color <1.000000, 1.000000, 1.000000>*BoxCamLightAmp
        area_light <100, 0, 0>, <0, 0, 100>, 10, 10
    	parallel
    	point_at -CamPos
    }

    #declare BoxDownLight0=light_source {
        <-10.0, -50.0, 100.0>
    	color <1.000000, 1.000000, 1.000000>*BoxDownLightAmp
    	parallel
    	point_at <0.0, 0.0, 0.0>
    }

    #declare BoxDownLight1=light_source {
        <10.0, -50.0, 100.0>
    	color <1.000000, 1.000000, 1.000000>*BoxDownLightAmp
    	parallel
    	point_at <0.0, 0.0, 0.0>
    }


    light_group {
            light_source { BoxDownLight0 }
            light_source { BoxDownLight1 }
            //light_source { DownLight1 }
            light_source { BoxCamLight }

    /*
        object {
            Boxes
            translate 20*y
            //rotate 5*z
            //rotate 55*z
            //translate -20*x
        }
    */

    /*
        box { <-200, 20, -200> <200, 20.1, 200>
            texture { pigment { BoxColor9 } finish { BoxFinish } }
            normal { ripples 1 phase 1 frequency 1 scale 2}
        }
    */


    /*    plane {
            -y 0
            rotate 55*z
            translate -20*x
            texture {
                //pigment { PlaneColor }
                pigment { checker pigment{White}, pigment{White*0.5} scale 10}
                finish { PlaneFinish }
            }
        }
        object {
            Axes
            rotate 55*z
            translate -20*x
        }
    */
    }
#end

// --------------------------------------------------------------------------
#declare RenderLUTBg = false;
#if (RenderLUTBg)
    #declare cmdel = 1.0/6.0;
    light_group {
            light_source { DownLight0 }
            light_source { DownLight1 }
            //light_source { DownLight1 }
            light_source { CamLight }

        box { <-200, 100, -200> <200, 101, 200>
            pigment{
            crackle
            //gradient <0,0,1>
                color_map {
                    [0*cmdel color rgb <0,0,0>]
                    [1*cmdel color rgb <230.0,0,0>/255.0]
                    [2*cmdel color rgb <230.0,230.0,0>/255.0]
                    [3*cmdel color rgb <255.0,255.0,255.0>/255.0]
                    [4*cmdel color rgb <230.0,230.0,0>/255.0]
                    [5*cmdel color rgb <230.0,0,0>/255.0]
                    [6*cmdel color rgb <0,0,0>]
                }
            scale 100.0
            translate -100.0*z
            turbulence 1.0
            }
        }
    }
#end

// --------------------------------------------------------------------------
// camera
camera {
    perspective
    location CamPos
    sky CamUp
	right CamRight*Aspect
	angle HViewAngle
    look_at CamAt
    //focal_point <0,Mn.y,0>
    //aperture 0.5
    //blur_samples 100
    //variance 1/10000
}
