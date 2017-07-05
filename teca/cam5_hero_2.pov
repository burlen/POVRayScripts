#version 3.7;

global_settings {
  assumed_gamma 1.0
}

#include "colors.inc"
#include "textures.inc"

#declare PI = 3.14159265358979;
/*
 * Shperical to Cartesian coordinate conversion. Theta_ is the
 * inclination (rotation about y axis in x-z plane).
 */
#macro CartXYZ(R_, Theta_, Phi_)
 <R_*sin(Theta_)*cos(Phi_), R_*sin(Theta_)*sin(Phi_), R_*cos(Theta_)>
#end

#declare RE = 6371.0;
#declare DaysideCamera = true;
#declare HiQ = true;
#declare Atmosph = false;
#declare Stars = true;
#declare Earth = true;
#declare Iso = true;
#declare IsoOpaque = false;
#declare Moon = true;
#declare SunPos = <0,0,-1000*RE>;

#declare DataRoot = "/work2/teca/tc_1990s_cori/";
#declare ScriptRoot = "./";
#macro CamPosition(R_, Theta_, Phi_)
  CartXYZ(R_, Theta_, Phi_)
#end


#declare DataTime = clock;


#declare CamClock = 0;
#declare CamRadius = RE*4.8;
#declare CamDelta = PI/200.0;
#declare CamTheta = PI/2.0 + PI/6.0 + PI/12 + PI/18 + PI;
#declare CamPos = CamPosition(CamRadius, CamTheta, 0);
#declare CamAngle = 30;

#declare Period = 512;
#declare EarthDeltaTheta = 360.0/Period;
#declare EarthRotation = 180 - 15 + mod(clock,Period)*EarthDeltaTheta;

#declare TMQFile = concat(DataRoot,"2880_x_1620/crop/tmq_over/tmq.",str(DataTime,-4,0),".png");
#declare V850File = concat(DataRoot,"2880_x_1620/crop/v850_over/v850.",str(DataTime,-4,0),".png")
#declare LICFile = concat(DataRoot,"2880_x_1620/crop/lic_over/lic_v850.",str(DataTime,-4,0),".png")
#declare TrackFile =  concat(DataRoot,"2880_x_1620/crop/3hr_tracks_mdd_4800_line.",str(DataTime,-4,0), ".png")

#warning "---------------------------"
#warning concat("clock=",str(clock,0,4),"\n")
#warning concat("CamDelta=",str(CamDelta,0,4),"\n")
#warning concat("CamTheta=",str(CamTheta,0,4),"\n")
#warning concat("CamPos=",vstr(3, CamPos, ", ", 0,4),"\n")
#warning concat("DataTime=", str(DataTime,0,0))
#warning concat("EarthRotation=", str(EarthRotation,0,0), "\n")
#warning concat("TMQFile=",TMQFile,"\n")
#warning concat("V850File=",V850File,"\n")
#warning concat("LICFile=",LICFile,"\n")
#warning concat("TrackFile=",TrackFile,"\n")
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
  #declare EarthPos = <0,0,0>;
  #declare EarthSunAmp = 1.3;
  #declare EarthBump = 3.0;
  #declare EarthDayAmbient = 0.04;
  #declare EarthNightAmbient = 0.6;
  #declare DayWaterTex = texture {
    pigment { image_map { jpeg concat(ScriptRoot, "earthmap10k.jpg") once map_type 2 } }
    normal { bump_map { jpeg concat(ScriptRoot, "earthbump10k.jpg") once map_type 2 bump_size EarthBump } }
    finish { ambient EarthDayAmbient diffuse 0.4 specular 0.1 roughness 0.05 }
    };
  #declare DayLandTex = texture {
    pigment { image_map { jpeg concat(ScriptRoot, "earthmap10k.jpg") once map_type 2 } }
    normal { bump_map { jpeg concat(ScriptRoot, "earthbump10k.jpg") once map_type 2 bump_size EarthBump } }
    finish { ambient EarthDayAmbient diffuse 0.4 specular 0.01 roughness 0.05 }
    };
  #declare NightWaterTex = texture {
    pigment { image_map { jpeg concat(ScriptRoot, "earthlights10k.jpg") once map_type 2 } }
    normal { bump_map { jpeg concat(ScriptRoot, "earthbump10k.jpg") once map_type 2 bump_size EarthBump } }
    finish { ambient EarthNightAmbient diffuse 0.0 specular 0.0 }
    };
  #declare NightLandTex = texture {
    pigment { image_map { jpeg concat(ScriptRoot, "earthlights10k.jpg") once map_type 2 } }
    normal { bump_map { jpeg concat(ScriptRoot, "earthbump10k.jpg") once map_type 2 bump_size EarthBump } }
    finish { ambient EarthNightAmbient diffuse 0.0 specular 0.0 }
    };



  #declare TMQMap = pigment { image_map{ png TMQFile once map_type 2 } }
  #declare V850Map = pigment { image_map{ png V850File once map_type 2 } }
  #declare LICMap = pigment { image_map{ png LICFile once map_type 2 } }
  #declare TrackMap = pigment { image_map{ png TrackFile once map_type 2 } }

  /*#declare CloudsMap = pigment { image_map{ png "/home/bloring/work/teca/tc_1990s_cori/2880_x_1620/crop/lic_tmq_v850_over/lic_tmq_v850.1920.png" once map_type 2 } }*/

  #declare TMQTex = texture {
    pigment { TMQMap }
    finish { ambient 0.025 diffuse 1.0 }
  }

  #declare V850Tex = texture {
    pigment { V850Map }
    finish { ambient 0.025 diffuse 1.0 }
  }


  #declare LICTex = texture {
    pigment { LICMap }
    finish { ambient 0.025 diffuse 1.0 }
  }

  #declare TrackTex = texture {
    pigment { TrackMap }
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
                jpeg concat(ScriptRoot, "earthspec4k.jpg")
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
                jpeg concat(ScriptRoot, "earthspec4k.jpg")
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
    texture { TMQTex
      translate <0, -0.5, 0>
      scale <1,2,1>
      }
    texture { V850Tex
      translate <0, -0.5, 0>
      scale <1,2,1>
      }
    texture { LICTex
      translate <0, -0.5, 0>
      scale <1,2,1>
      }

    texture { TrackTex
      translate <0, -0.5, 0>
      scale <1,2,1>
      }

    /*texture {
      pigment_pattern{ CloudsMap }
      texture_map{
       [0.0 pigment{ rgbf<1,1,1,1> }]
       [1.0 CloudsTex  ]
    }
    translate <0, -0.5, 0>
    scale <1,2,1>
    }*/
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
          scattering{1, <0.0005,0.0005,0.001>*100.5}
          intervals 5
        }
      }
    }
  #end
  }
#end
