#version 3.7;

global_settings {
  assumed_gamma 1.0
}

#include "colors.inc"
#include "textures.inc"

#declare PI = 3.14159265358979;
/*
 * controls the sense of the camera orbit.
 */
#declare Sense = -1.0;
/*
 * Radius of an archimedian spiral. A function of theta(Theta_)
 * and constants a(A_) and b(B_). r = a + bt
 */
#macro ArchSpiralR(Theta_)
  #local A_ = -100.0;
  #local B_ = 600.0/PI;
  Sense*(A_ + B_*Theta_)
#end
/*
 * Radius of a circle that matches up with the above
 * Archimedian spiral at Theta of 7*pi/2.
 */
#macro CircleR(Theta_)
  Sense*2000.0
#end

/*
 * Shperical to Cartesian coordinate conversion. Theta_ is the
 * inclination (rotation about y axis in x-z plane).
 */
#macro CartXYZ(R_, Theta_, Phi_)
 <R_*sin(Theta_)*cos(Phi_), R_*sin(Theta_)*sin(Phi_), R_*cos(Theta_)>
#end
/*
 * same but this negates z coords so the orbit stays always
 * on the day side
 */
#macro CartXYmZ(R_, Theta_, Phi_)
 <R_*sin(Theta_)*cos(Phi_), R_*sin(Theta_)*sin(Phi_), -R_*cos(Theta_)>
#end

#declare DaysideCamera = true;
#declare HiQ = true;
#declare Atmosph = false;
#declare Stars = true;
#declare Earth = true;
#declare Iso = false;
#declare IsoOpaque = false;
#declare Moon = true;
#declare SunPos = <0,0,-2000>;
/* dresden */
#declare DataRoot = "/home/users/bloring/data/dipole3-den-isos-all/pov-mesh3/";

/* edison
#declare DataRoot = "/scratch3/scratchdirs/loring/dipole3-den-isos-all/0001-pov3-nn";
*/

/*
 * set the camera angle and data time based on
 * the clock variable to move through the
 * phases of animation
 */
#if (clock <= 100.0)
  // the first 100 steps show the Earth spinning
  #declare CamClock = 0;
  #macro CamRadius(Theta_)
    ArchSpiralR(Theta_)
  #end
  #macro CamPosition(R_, Theta_, Phi_)
    CartXYZ(R_, Theta_, Phi_)
  #end
  // no data
  #declare DataTime = -1;
#end

#if ((clock > 100) & (clock <= 500))
  // archimedian orbit
  #declare CamClock = clock - 100;
  #macro CamRadius(Theta_)
    ArchSpiralR(Theta_)
  #end
  #macro CamPosition(R_, Theta_, Phi_)
    CartXYZ(R_, Theta_, Phi_)
  #end
  // data advances 1:3
  #declare DataTime = int((clock-400)/3);
#end

#if ((clock > 500) & (clock <= 700))
  // archimedian orbit
  #declare CamClock = clock - 100;
  #macro CamRadius(Theta_)
    ArchSpiralR(Theta_)
  #end
  #if (DaysideCamera)
    #macro CamPosition(R_, Theta_, Phi_)
      CartXYmZ(R_, Theta_, Phi_)
    #end
  #else
    #macro CamPosition(R_, Theta_, Phi_)
      CartXYZ(R_, Theta_, Phi_)
    #end
  #end
  // data advances 1:3
  #declare DataTime = int((clock-400)/3);
#end

#if ((clock > 700) & (clock <= 760))
  // camera stopped
  #declare CamClock = 600;
  #macro CamRadius(Theta_)
    ArchSpiralR(Theta_)
  #end
  #macro CamPosition(R_, Theta_, Phi_)
    CartXYZ(R_, Theta_, Phi_)
  #end
  // data advance 1:3
  #declare DataTime = int((clock-400)/3);
#end

#if ((clock > 760) & (clock <= 960))
  // circular orbit
  #declare CamClock = clock - 160;
  #macro CamRadius(Theta_)
    CircleR(Theta_)
  #end
  #macro CamPosition(R_, Theta_, Phi_)
    CartXYZ(R_, Theta_, Phi_)
  #end
  // data stopped
  #declare DataTime = 120;
#end

#if ((clock > 960) & (clock <= 1050))
  // camera stopped
  #declare CamClock = 800;
  #macro CamRadius(Theta_)
    CircleR(Theta_)
  #end
  #macro CamPosition(R_, Theta_, Phi_)
    CartXYZ(R_, Theta_, Phi_)
  #end
  // data advances 1:3
  #declare DataTime = int((clock-600)/3);
#end

#if ((clock > 1050) & (clock <= 1450))
  // circular orbit
  #declare CamClock = clock - 250;
  #macro CamRadius(Theta_)
    CircleR(Theta_)
  #end
  #macro CamPosition(R_, Theta_, Phi_)
    CartXYZ(R_, Theta_, Phi_)
  #end
  // data stopped
  #declare DataTime = 150;
#end

#if (clock > 1450)
  // camera stopped
  #declare CamClock = 1200;
  #macro CamRadius(Theta_)
    CircleR(Theta_)
  #end
  #macro CamPosition(R_, Theta_, Phi_)
    CartXYZ(R_, Theta_, Phi_)
  #end
  // data stopped
  #declare DataTime = 150;
#end
// total number of clock steps should be 1500

#declare CamDelta = PI/200.0;
#declare CamTheta = PI/2.0 + CamClock*CamDelta;
#declare CamPos = CamPosition(CamRadius(CamTheta), CamTheta, 0);
#declare CamAngle = 60;

#declare FileName = concat(concat(DataRoot, concat("den-iso-",str(DataTime,-4,0)), "-0001.pov"))

#warning "---------------------------"
#warning concat("clock=",str(clock,0,4),"\n")
#warning concat("CamDelta=",str(CamDelta,0,4),"\n")
#warning concat("CamTheta=",str(CamTheta,0,4),"\n")
#warning concat("CamPos=",vstr(3, CamPos, ", ", 0,4),"\n")
#warning concat("DataTime=", str(DataTime,0,0))
#warning concat("FileName=", FileName)
#warning "---------------------------"

camera {
  perspective
  location CamPos
  angle CamAngle
  look_at <0,0,0>
  up <0,1,0>
  right x*image_width/image_height
  sky <0,1,0>
}

#if (Earth)
  #declare RE = 64.0;
  #declare EarthPos = <0,0,0>;
  #declare EarthRotation = 60+clock/2.0;
  #declare EarthSunAmp = 1.3;
  #declare EarthBump = 3.0;
  #declare EarthDayAmbient = 0.04;
  #declare EarthNightAmbient = 0.6;
  #declare DayWaterTex = texture {
    pigment { image_map { jpeg "earthmap10k.jpg" once map_type 2 } }
    normal { bump_map { jpeg "earthbump10k.jpg" once map_type 2 bump_size EarthBump } }
    finish { ambient EarthDayAmbient diffuse 0.4 specular 0.1 roughness 0.05 }
    };
  #declare DayLandTex = texture {
    pigment { image_map { jpeg "earthmap10k.jpg" once map_type 2 } }
    normal { bump_map { jpeg "earthbump10k.jpg" once map_type 2 bump_size EarthBump } }
    finish { ambient EarthDayAmbient diffuse 0.4 specular 0.01 roughness 0.05 }
    };
  #declare NightWaterTex = texture {
    pigment { image_map { jpeg "earthlights10k.jpg" once map_type 2 } }
    normal { bump_map { jpeg "earthbump10k.jpg" once map_type 2 bump_size EarthBump } }
    finish { ambient EarthNightAmbient diffuse 0.0 specular 0.0 }
    };
  #declare NightLandTex = texture {
    pigment { image_map { jpeg "earthlights10k.jpg" once map_type 2 } }
    normal { bump_map { jpeg "earthbump10k.jpg" once map_type 2 bump_size EarthBump } }
    finish { ambient EarthNightAmbient diffuse 0.0 specular 0.0 }
    };
  #declare CloudsMap = pigment { image_map{ jpeg "earthhiresclouds4K.jpg" once map_type 2 } }
  #declare CloudsTex = texture {
    pigment{ color White }
    finish { ambient 0.025 diffuse 1.0 }
  }
  light_group {

    light_source {
        SunPos, EarthSunAmp*White
        //point_at <0,0,0>
        area_light <25, 0, 0>, <0, 0, 25>, 2, 2
        jitter
        } // sun

    merge {
      intersection {
        sphere {
          0, 1
          texture {
              material_map {
                jpeg "earthspec4k.jpg"
                once map_type 2
                texture { DayLandTex }
                texture { DayWaterTex }
                }
              translate <0, -0.5, 0>
              scale <1,2,1>
          }
          rotate -EarthRotation*y
          scale RE
          no_reflection
          no_shadow
        }
      box { 1.2*<-RE, -RE, -RE>, 1.2*<RE, RE, 0.0>+z*RE/150.0 }
      }
      intersection {
        sphere {
          0, 1
          texture {
              material_map {
                jpeg "earthspec4k.jpg"
                once map_type 2
                texture { NightLandTex }
                texture { DayWaterTex }
                }
              translate <0, -0.5, 0>
              scale <1,2,1>
          }
          rotate -EarthRotation*y
          scale RE
          no_reflection
          no_shadow
        }
      box { 1.2*<-RE, -RE, 0.0>+z*RE/150.0,  1.2*<RE, RE, RE> }
      }
    }
  // clouds
  sphere {
    0, 1
    texture {
      pigment_pattern{ CloudsMap }
      texture_map{
       [0.0 pigment{ rgbf<1,1,1,1> }]
       [1.0 CloudsTex  ]
    }
    translate <0, -0.5, 0>
    scale <1,2,1>
    }
    hollow
    rotate -EarthRotation*y
    scale RE*1.0125
    no_reflection
    no_shadow
  }
  #if (Atmosph)
    difference{
      sphere{EarthPos, RE*1.1}
      sphere{EarthPos, RE*1.001}
      hollow
      pigment {rgbf 1}
      interior {
        media {
          scattering{2, <0.0005,0.0005,0.001>*10.5}
          intervals 5
        }
      }
    }
  #end
  }
#end

#if (Moon)
  #declare MoonRotation = clock/60.0;
  #declare MoonBump = 0.5;
  #declare MoonSunAmp = 1.75;
  #declare MoonTex = texture {
    pigment { image_map { jpeg "moonmap4k.jpg" once map_type 2 } }
    normal { bump_map { jpeg "moonbump4k.jpg" once map_type 2 bump_size MoonBump } }
    finish { ambient 0.01 diffuse 1.0 specular 0.0 roughness 0.05 }
    };
    light_group {
      light_source {
          SunPos, MoonSunAmp*White
          }
      sphere {
        0, 1
        texture { MoonTex
          translate <0, -0.5, 0>
          scale <1,2,1>
        }
        rotate -MoonRotation*y
        scale RE*0.273
        translate Sense*480*x
        rotate (215 + -MoonRotation)*y
        no_reflection
        no_shadow
      }
    }
#end

#if (Stars)
  sphere {
    0, 5000
    hollow
    pigment { image_map { png "milky-way.png" once map_type 1 } }
    finish { ambient 1.0 diffuse 0 }
  }
#end

#if (Iso & DataTime > 0)
  #declare UseNormals = false;
  #include FileName

  #if (IsoOpaque)
    #declare IsoF = 0.0;
    #declare IsoT = 0.0;
  #else
    #declare IsoF = 0.95;
    #declare IsoT = 0.0;
  #end

  #declare HotPink = rgbft <251/255.0, 0, 201/255.0, IsoF, IsoT>;
  #declare AroraPink = rgbft <199/255.0, 47/255.0, 104/255.0, IsoF, IsoT>;
  #declare AroraPurple = rgbft <105/255.0, 48/255.0, 225/255.0, IsoF, IsoT>;
  #declare AroraPurple2 = rgbft <75/255.0, 38/255.0, 193/255.0, IsoF, IsoT>;
  #declare AroraBlue = rgbft <50/255.0, 27/255.0, 143/255.0, IsoF, IsoT>;
  #declare AroraBlue2 = rgbft <49/255.0, 15/255.0, 196/255.0, IsoF, IsoT>;
  #declare AroraGreen = rgbft <2/255.0, 189/255.0, 0, IsoF, IsoT>;
  #declare NeonBlue = rgbft <56/255.0 219/255.0 254/255.0, IsoF, IsoT>;
  #declare DarkNeonBlue = rgbft <35/255.0, 54/255.0, 255.0/255.0, IsoF, IsoT>;
  #declare NeonRed = rgbft <230/255.0, 2/255.0, 63/255.0, IsoF, IsoT>;
  #declare AroraYellow = rgb <222/255.0 198/255.0 92/255.0>;

  #declare IsoColor = AroraGreen; // NeonRed; //
  #declare BackLightColor = AroraYellow;
  #declare BackLightPos = -vnormalize(CamPos)*2000.0;
  #declare BackLightAt = CamPos;
  #declare IsoLightAmp1 = 0.25;
  #declare IsoLightAmp2 = 0.45;
  #declare IsoLightX = 1000;
  #declare IsoLightY = 1200;
  #declare IsoLightZ = 1200;

  light_group {
    //light_source { SunPos, 0.9*White } // sun

    //light_source { BackLightPos, 0.30*White spotlight parallel point_at BackLightAt } // cam
    //light_source { BackLightPos, 0.35*BackLightColor spotlight parallel point_at BackLightAt } // cam

    //light_source { <0,0,-72>, 0.25*BackLightColor }
    //light_source { <0,0, 72>, 0.25*White }

    light_source { <-IsoLightX, -IsoLightY, -IsoLightZ>, IsoLightAmp1*White }
    light_source { < IsoLightX, -IsoLightY, -IsoLightZ>, IsoLightAmp1*White }
    light_source { <-IsoLightX, -IsoLightY,  IsoLightZ>, IsoLightAmp1*White }
    light_source { < IsoLightX, -IsoLightY,  IsoLightZ>, IsoLightAmp1*White }
    light_source { <-IsoLightX, IsoLightY, -IsoLightZ>, IsoLightAmp1*White }
    light_source { < IsoLightX, IsoLightY, -IsoLightZ>, IsoLightAmp1*White }
    light_source { <-IsoLightX, IsoLightY,  IsoLightZ>, IsoLightAmp1*White }
    light_source { < IsoLightX, IsoLightY,  IsoLightZ>, IsoLightAmp1*White }
    light_source { <-IsoLightX, -IsoLightY, -IsoLightZ>, IsoLightAmp2*AroraYellow }
    light_source { < IsoLightX, -IsoLightY, -IsoLightZ>, IsoLightAmp2*AroraYellow }
    light_source { <-IsoLightX, -IsoLightY,  IsoLightZ>, IsoLightAmp2*AroraYellow }
    light_source { < IsoLightX, -IsoLightY,  IsoLightZ>, IsoLightAmp2*AroraYellow }
    light_source { <-IsoLightX, IsoLightY, -IsoLightZ>, IsoLightAmp2*AroraYellow }
    light_source { < IsoLightX, IsoLightY, -IsoLightZ>, IsoLightAmp2*AroraYellow }
    light_source { <-IsoLightX, IsoLightY,  IsoLightZ>, IsoLightAmp2*AroraYellow }
    light_source { < IsoLightX, IsoLightY,  IsoLightZ>, IsoLightAmp2*AroraYellow }

    object { Surface
      #if (HiQ)
        pigment { color IsoColor }
        //finish { ambient 0.05 diffuse 0.7 reflection .2 specular 1 roughness .1 }
        finish { ambient 0.05 diffuse 0.7 reflection .2 specular 0.8 roughness .01 metallic irid { 0.2 } }
      #else
        pigment { Red }
        finish { ambient 0.3 diffuse 0.9 }
      #end
      translate -1024*x
      translate -1024*z
      translate -2048*y
      rotate -90*y
    }
  }
#end
