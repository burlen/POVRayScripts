// POVRay file exported by vtkPOVExporter
//
// +W1134 +H695
#version 3.7;
#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "math.inc"
#include "transforms.inc"

#macro Compliment(Color)
   #local C255 = <255.0,255.0,255.0,1.0,1.0>;
   #local CRGB = color Color/C255;
   #local CTMP = CRGB2HSL(CRGB);
   #local A = mod(CTMP.red,360) + (CTMP.red< 0 ? 360 : 0);
   #local CTMP = <A,CTMP.green,CTMP.blue,0,0>;
   #local CTMP = <mod(A+180,360),CTMP.green,CTMP.blue,0,0>;
   #local CTMP = CHSL2RGB(CTMP);
   <CTMP.red,CTMP.green,CTMP.blue,CRGB.filter,CRGB.transmit>*C255
#end


// -----
global_settings {
	ambient_light color rgb <1.0, 1.0, 1.0>
	assumed_gamma 2
}

#declare Delta = 0.0;
#declare R1 = -45;
#declare Center= <0,0,0>; //the crystal is centered at <15.6, 0, 69.0>;
//#declare Theta = clock * 360.0 * 3.141592654 / 180.0;
#declare Theta = 90 * 3.141592654 / 180.0;
#declare Phi = 0 * 3.141592654 / 180.0;
#declare CamPos = <R1*sin(Theta)*cos(Phi), R1*sin(Theta)*sin(Phi), R1*cos(Theta)> + Center;
#declare CamUp = <sin(Phi), -cos(Phi), 0>;
#declare CamRight = <cos(Theta)*cos(Phi), cos(Theta)*sin(Phi), -sin(Theta)>;
#declare CamAt = <0,0,0>; // <0,0, 69> + Delta;
#declare Aspect = image_width/image_height;
#declare HViewAngle = 61.0;
#declare VViewAngle = HViewAngle*Aspect;


#declare FocalDistance = 50;
#declare EyeSep = FocalDistance/30.0;

/*
add the following number of pixels to the rendered width
then trim from left and right side of the respective renderings

                      desired width * eye sep
extra pixels = ---------------------------------------
                2 * focal distance tan(cam angle / 2)
*/

#if (Stereo)
  #if (RightEye)
    #declare CamPos = CamPos + CamRight*EyeSep/2.0;
  #else
    #declare CamPos = CamPos - CamRight*EyeSep/2.0;
  #end
  #warning concat("StereoCamPos=",vstr(3, CamPos, ", ", 0,4),"\n")
  #warning "---------------------------"
  /*
  */
#end

camera {
    //orthographic
	perspective
	location CamPos
	sky <0.000000, 1.000000, 0.000000>
	right <-1, 0, 0>*Aspect
	angle HViewAngle
	look_at CamAt
}

//background { color Black }
#declare BG1 = rgb <173/255 173/255 173/255>;
#declare BG2 = rgb <45/255 45/255 45/255>;
sky_sphere {
pigment {
    gradient y
    color_map {
        [0.0 color BG2]
        [0.08 color BG1]
        }
    scale 2
    translate -1
    }
  //rotate -90*x
  //rotate  90*y
  rotate -90*x
  rotate mod(degrees(Theta),360)*y
  rotate mod(degrees(Phi),360)*z
}


#declare Dimmer = 0.25;
#include "scene-lights.pov"

//---------------------------------------------------------------------------
// iso surface params
#declare SphereScaling=1.35;
#declare CylinderScaling=0.89;

#declare AtomFinish=finish {
 ambient 0.01 diffuse 0.685 specular 0.952 roughness 0.00551 reflection { 0.0125 metallic }
 metallic
}
#declare BondFinish=finish {
 ambient 0.34 diffuse 0.39 specular 0.67 roughness 0.03 //reflection { 0.775 metallic }
}

#declare TFF = <255,255,255,1,1>;

#declare AntiFlashWhite = <242,243,244,0,0>;

#declare MyGreen = <17,193,21,0,0>;
#declare MyPink = <193,17,129,0,0>;

#declare MyCyan = <17,191,193,0,0>;
#declare SpanishSkyBlue = <0,178,228,0,0>;
#declare ElectricBlue = <125,249,255,0,0>;
#declare FreshAir = <166,231,255,0,0>;
#declare Diamond = <185,242,255,0,0>;
#declare Cyan = <0,255,255,0,0>;
#declare Celeste = <178,255,255,0,0>;
#declare Blizzard = <172,229,238,0,0>;
#declare BeauBlue = <188,212,230,0,0>;
#declare AirSuperiorityBlue = <114,160,192,0,0>;
#declare WaterSpout = <164,244,249,0,0>;
#declare Turquoise = <64,224,208,0,0>;
#declare PowderBlue = <176,224,230,0,0>;

#declare PictonBlue = <69,177,233,0,0>;
#declare Rackley = <93,138,168,0,0>;
#declare Pastel = <174,198,207,0,0>;
#declare PaleAqua = <188,212,230,0,0>;

#declare SpanishCrimson = <229,26,76,0,0>;
#declare WebViolet = <238,130,238,0,0>;
#declare BakerPink = <255,145,175,0,0>;
#declare AmaranthPink = <241,156,187,0,0>;
#declare UltraRed = <252,108,133,0,0>;
#declare Cerise = <222,49,99,0,0>;
#declare FrenchRaspberry = <199,44,72,0,0>;
#declare BrilliantRose = <255,85,163,0,0>;
#declare BeanRed = < 255,143,139,0,0>;
#declare CarnationPink = <247,120,161,0,0>;
#declare LightCoral = <231,116,113,0,0>;

/*
#declare Reds = array[11] {SpanishCrimson ,WebViolet ,BakerPink ,AmaranthPink ,UltraRed ,Cerise ,FrenchRaspberry ,BrilliantRose ,BeanRed ,CarnationPink ,LightCoral}
#declare Blues = array[17] {MyCyan, SpanishSkyBlue, ElectricBlue, FreshAir, Diamond, Cyan, Celeste, Blizzard, BeauBlue, AirSuperiorityBlue, WaterSpout, Turquoise, PowderBlue PictonBlue, Rackley, Pastel, PaleAqua}
#if (clock<11)
#declare RedColor = Reds[clock];
#declare BlueColor = Compliment(RedColor);
#else
#declare BlueColor = Blues[clock-11];
#declare RedColor = Compliment(BlueColor);
#end
*/

#declare BlueColor = PictonBlue;
#declare RedColor = Compliment(BlueColor);

/*
// glass
#declare AF=0.8;
#declare BF=1.066667;
#declare BT=0.4;
*/
// metal
#declare AF=0.0;
#declare AT=0.0;
#declare AtomFT = <0,0,0,AF,AT>;
#declare AtomColor49 = RedColor/TFF + AtomFT;
#declare AtomColor7 = BlueColor/TFF + AtomFT;
#declare AtomColor1 = AntiFlashWhite/TFF + AtomFT;

#declare BF=0.36;
#declare BT=0.075;
#declare BondFT = <0,0,0,BF,BT>;
#declare BondColor49 = RedColor/TFF*0.95 + BondFT;
#declare BondColor7= BlueColor/TFF*0.95 + BondFT;
#declare BondColor1= AntiFlashWhite/TFF*0.95 + BondFT;

#declare isoF = 0.185;

#declare deltaj = 0.05;
/*#declare isoTs = array[20];
#declare j=0;
#while (j<20)
  #declare isoTs[j] = j*deltaj;
  #declare j=j+1;
#end
#declare isoT = isoTs[clock];*/
#declare isoT = 9.5*deltaj; // 0.35; //0.45;



#declare isoColor = pigment {
color rgbft <1.0, 1.0, 1.0 isoF isoT>
//color rgbft <14/255, 255/255, 20/255, isoF, isoT>
}

#declare isoFinish = finish {
ambient 0.025  diffuse 1.0  specular 0.4 roughness 0.005  brilliance 5 irid {0.40}
}


#include "crystal.pov"
light_group {
AxialLight00
AxialLight11
CamLight11
CamLight00
CamLight33
UpLight00
DownLight00
object { Molecule Center_Trans(Molecule, x+y+z) rotate clock*360.0*z }
}

#include "iso-2.pov"
#declare IsoSurf = object { Iso
texture { finish { isoFinish } pigment { isoColor } }
}
light_group {
//InteriorLight0
AxialLight0
AxialLight1
DownLight0
UpLight0
CamLight0
CamLight1
CamLight2
CamLight3
object { IsoSurf Center_Trans(Molecule, x+y+z) rotate clock*360.0*z }
}
