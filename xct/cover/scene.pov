// POVRay file exported by vtkPOVExporter
//
// +W1134 +H695
#version 3.7;
#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "math.inc"
#include "transforms.inc"
//#include "rad_def.inc"
// --------------------------------------------------------------------------
global_settings {
	ambient_light color rgb <1.0, 1.0, 1.0>
	assumed_gamma 2
    //#default {finish{ambient 0}}
    //radiosity { Rad_Settings(Radiosity_Normal,off,off) }
}

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
// camera
//#declare R1 = -26.244181;
#declare R1 = 260;
//#declare AtomCenter= <15.690075, 0, 68.3473>;
//#declare AtomRot = <0,90,0>;
#declare AtomTheta = 120;
#declare AtomPhi = 90;

//#declare Theta = clock * 360.0 * 3.141592654 / 180.0;
#declare Theta = radians(90);
#declare Phi = radians(0);
#declare CamPos = <R1*sin(Theta)*cos(Phi), R1*sin(Theta)*sin(Phi), R1*cos(Theta)>;
#declare CamRight = <-sin(Phi), cos(Phi), 0>;
#declare CamUp = <-cos(Theta)*cos(Phi), -cos(Theta)*sin(Phi), sin(Theta)>;
#declare CamAt = <0,0,0>;
#declare Aspect = image_width/image_height;
#declare HViewAngle = 10.5;
#declare VViewAngle = HViewAngle*Aspect;

#declare CamDir = CamPos/vlength(CamPos);
#declare DomeRot = <degrees(acos(CamDir.y)), degrees(acos(CamDir.z))>;


camera {
  //orthographic
	perspective
	location CamPos //<-26.244181, -0.687544, 69>
  //right -x*Aspect
	sky CamUp //sky <0.000000, 1.000000, 0.000000>
	right CamRight*Aspect // <-1, 0, 0>*Aspect
	//direction CamAt //look_at <112.776841, 1.600235, 69>
	angle HViewAngle
  look_at CamAt
}


// --------------------------------------------------------------------------
// background

//background { color rgb <0.780392, 0.780392, 0.780392>}
//background { color rgb <0.321569, 0.341176, 0.431373>}
//background { color Black }

// PV
/*
#declare BG1 = rgb <84/255 89/255 109/255>;
#declare BG2 = rgb <0 0 44/255>;
*/
// gray
//#declare BG1 = rgb <140/255 140/255 140/255>;
//#declare BG2 = rgb <5/255 0/255 0/255>;

#declare MakeMask = false;
#if (MakeMask)
    background { color White }
#else
    #declare BG1 = rgb <154,154,154>/255; //rgb <255 255 255>/255.0;
    #declare BG2 = rgb <154,154,154>/255; //rgb <30 30 30>/255.0;
    sky_sphere {
    pigment {
        gradient y
        color_map {
            [0.0 color BG2]
            [0.0041 color BG1]
            }
        scale 2
        translate -1
        }
      rotate -90*x
      rotate mod(degrees(Theta) + 180,360)*y
      rotate mod(degrees(Phi),360)*z
    }
#end

/*
object {
  XVector
  rotate -90*z
  rotate -90*x
  rotate mod(degrees(Theta)+180,360)*y
  rotate mod(degrees(Phi),360)*z
  finish { AxesFinish} pigment { color Yellow } 
}
*/


// --------------------------------------------------------------------------
// lights
#declare HiQ = true;
#declare FinalIso = true;
#declare MultipleDen = true;
#declare UseFog = true;
#declare TestFog = false;
#if (MakeMask)
    #declare UseFog = true;
    #declare TestFog = false;
#end
#declare NAdapt = 8;

#declare HighlightYellow = rgb <254, 223, 0>/255;
#declare WarmLightColor = rgb <251, 216, 12>/255;
#declare IsoLightColor = rgb <14, 255, 20>/255;
#declare MolLightColor = rgb <1,1,1>;

#if (UseFog)
    #if (MultipleDen)
        #if (FinalIso)
            #declare IsoLightAmp = 19.5;
        #else
            #declare IsoLightAmp = 20;
        #end
        #declare MolLightAmp = 30;
    #else
        #declare IsoLightAmp = 50;
        #declare MolLightAmp = 72;
    #end
#else
    #declare IsoLightAmp = 0.8;
    #declare MolLightAmp = 0.8;
#end

#if (FinalIso)
    #declare LightR = 30;
#else
    #declare LightR = 40;
#end

#declare Origin = <0,0,0>;
#declare ParLight = 0;
#declare PtLight = 1;



#declare LightPos = array[11]
// down lights
#declare LightPos[0] = vrotate(vrotate(-x*LightR, y*AtomTheta), z*AtomPhi);
#declare LightPos[1] = vrotate(vrotate( x*LightR, y*AtomTheta), z*AtomPhi);
#declare LightPos[2] = vrotate(vrotate(-y*LightR, y*AtomTheta), z*AtomPhi);
#declare LightPos[3] = vrotate(vrotate( y*LightR, y*AtomTheta), z*AtomPhi);
// axial lights
#declare LightPos[4] = vrotate(vrotate(-z*79, y*AtomTheta), z*AtomPhi);
#declare LightPos[5] = vrotate(vrotate( z*79, y*AtomTheta), z*AtomPhi);
// cam lights
#declare LightPos[6] = CamPos;
#declare LightPos[7] = CamPos;
#declare LightPos[8] = CamPos;
#declare LightPos[9] = CamPos;
// interior
#declare LightPos[10] = -CamPos;

#declare LightAt = array[11]
#declare LightAt[0] = Origin;
#declare LightAt[1] = Origin;
#declare LightAt[2] = Origin;
#declare LightAt[3] = Origin;
#declare LightAt[4] = Origin;
#declare LightAt[5] = Origin;
#declare LightAt[6] = Origin;
#declare LightAt[7] = Origin;
#declare LightAt[8] = Origin;
#declare LightAt[9] = Origin;
#declare LightAt[10] = Origin;

// --------------------------------------------------------------------------
// Molecule lights
#declare MolLightDim = array[11]
// down light
#declare MolLightDim[0] = 0.25;
#declare MolLightDim[1] = 0.25;
#declare MolLightDim[2] = 0.25;
#declare MolLightDim[3] = 0.25;
// axial light
#declare MolLightDim[4] = 0.2;
#declare MolLightDim[5] = 0.2;
// cam light
#declare MolLightDim[6] = 0.90;
#declare MolLightDim[7] = 0.20;
#declare MolLightDim[8] = 0.0;
#declare MolLightDim[9] = 0.125;
// interior light
#declare MolLightDim[10] = 0.5;

#declare MolLightColors = array[11]
// down light
#declare MolLightColors[0] = MolLightColor;
#declare MolLightColors[1] = MolLightColor;
#declare MolLightColors[2] = MolLightColor;
#declare MolLightColors[3] = MolLightColor;
// axial light
#declare MolLightColors[4] = MolLightColor;
#declare MolLightColors[5] = MolLightColor;
// cam light
#declare MolLightColors[6] = MolLightColor;
#declare MolLightColors[7] = MolLightColor;
#declare MolLightColors[8] = MolLightColor;
#declare MolLightColors[9] = MolLightColor;
// interior light
#declare MolLightColors[10] = MolLightColor;

#declare MolLightType = array[11]
// down light
#declare MolLightType[0] = PtLight;
#declare MolLightType[1] = PtLight;
#declare MolLightType[2] = PtLight;
#declare MolLightType[3] = PtLight;
// axial light
#declare MolLightType[4] = PtLight;
#declare MolLightType[5] = PtLight;
// cam light
#declare MolLightType[6] = PtLight;
#declare MolLightType[7] = ParLight;
#declare MolLightType[8] = ParLight;
#declare MolLightType[9] = PtLight;
// interior light
#declare MolLightType[10] = PtLight;

#declare MolLights = array[11]
#declare ii = 0;
#while(ii<11)
  #declare MolLights[ii] = light_source {
    LightPos[ii]
    color MolLightColors[ii]*MolLightDim[ii]*MolLightAmp
    #if (MolLightType[ii] = ParLight)
        parallel
        point_at LightAt[ii]
    #end
    #if (HiQ)
        area_light <0,5,0>, <0,0,5>, 3,3
        adaptive NAdapt
        jitter
    #end
    media_interaction off
  }
  //cylinder { <0,0,0>, LightPos[ii], 0.25 finish {ambient 0.6 } pigment { color Green } }
  #declare ii = ii + 1;
#end

// --------------------------------------------------------------------------
// Iso lights
#declare IsoLightDim = array[11]
// down light
#if (FinalIso)
        #declare IsoLightDim[0] = 1.65;
        #declare IsoLightDim[1] = 1.65;
        #declare IsoLightDim[2] = 0.45;
        #declare IsoLightDim[3] = 0.45;
#else
        #declare IsoLightDim[0] = 0.75;
        #declare IsoLightDim[1] = 0.75;
        #declare IsoLightDim[2] = 0.75;
        #declare IsoLightDim[3] = 0.75;
#end
    // axial light
#if (FinalIso)
    #declare IsoLightDim[4] = 1.15;
    #declare IsoLightDim[5] = 1.15;
#else
    #declare IsoLightDim[4] = 0.5;
    #declare IsoLightDim[5] = 0.5;
#end
// cam light
#declare IsoLightDim[6] = 0.75;
#declare IsoLightDim[7] = 1.0;
#declare IsoLightDim[8] = 0.5;
#declare IsoLightDim[9] = 0.35;
// interior light
#declare IsoLightDim[10] = 2.50;

#declare IsoLightColors = array[11]
// down light
#declare IsoLightColors[0] = IsoLightColor;
#declare IsoLightColors[1] = IsoLightColor;
#declare IsoLightColors[2] = IsoLightColor;
#declare IsoLightColors[3] = IsoLightColor;
// axial light
#declare IsoLightColors[4] = IsoLightColor;
#declare IsoLightColors[5] = IsoLightColor;
// cam light
#declare IsoLightColors[6] = IsoLightColor;
#declare IsoLightColors[7] = IsoLightColor;
#declare IsoLightColors[8] = IsoLightColor;
#declare IsoLightColors[9] = WarmLightColor;
// interior light
#declare IsoLightColors[10] = IsoLightColor;

#declare IsoLightType = array[11]
// down light
#if (FinalIso)
    #declare IsoLightType[0] = PtLight;
    #declare IsoLightType[1] = PtLight;
    #declare IsoLightType[2] = PtLight;
    #declare IsoLightType[3] = PtLight;
#else
    #declare IsoLightType[0] = PtLight;
    #declare IsoLightType[1] = PtLight;
    #declare IsoLightType[2] = PtLight;
    #declare IsoLightType[3] = PtLight;
#end
// axial light
#declare IsoLightType[4] = ParLight;
#declare IsoLightType[5] = ParLight;
// cam light
#declare IsoLightType[6] = PtLight;
#declare IsoLightType[7] = ParLight;
#declare IsoLightType[8] = ParLight;
#declare IsoLightType[9] = PtLight;
// interior light
#declare IsoLightType[10] = ParLight;

#declare IsoLights = array[11]
#declare ii = 0;
#while(ii<11)
  #declare IsoLights[ii] = light_source {
    LightPos[ii]
    color IsoLightColors[ii]*IsoLightDim[ii]*IsoLightAmp
    #if (IsoLightType[ii] = ParLight)
        parallel
        point_at LightAt[ii]
    #end
    #if (HiQ)
        area_light <0,5,0>, <0,0,5>, 3,3
        adaptive NAdapt
        jitter
    #end
    media_interaction off
    }
    //cylinder { <0,0,0>, LightPos[ii], 0.25 finish {ambient 0.6 } pigment { color Green } }
    #declare ii = ii + 1;
#end


//---------------------------------------------------------------------------
// iso surface params

/*
#declare AtomColor49=rgbft <17/255, 193/255, 21/255, AF, 0.0>;
#declare AtomColor7=rgbft <17/255, 191/255, 193/255, AF, 0.0>;
#declare AtomColor1=rgbft <193/255, 17/255, 129/255, AF, 0.0>;

#declare BondColor49=rgbft <17/255, 193/255, 21/255, BF, BT>*0.75;
#declare BondColor7=rgbft <17/255, 191/255, 193/255, BF, BT>*0.75;
#declare BondColor1=rgbft <193/255, 17/255, 129/255, BF, BT>*0.75;
*/

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

/*
#declare BlueColor = ElectricBlue;
*/
#declare BlueColor = PictonBlue;
#declare RedColor = Compliment(BlueColor);

/*
#declare RedColor = LightCoral;
#declare BlueColor = Compliment(RedColor);
*/
/*
// glass
#declare AF=0.8;
#declare BF=1.066667;
#declare BT=0.4;
*/
// metal


#declare RenderIso = true;
#declare RenderCrystal = true;

#declare SphereScaling=1.35;
#declare CylinderScaling=0.89;

#if (MakeMask)
    #declare AF=0;
    #declare AT=0;
    #declare BF=0;
    #declare BT=0;
    #declare AtomFinish = finish { ambient 0.0  diffuse 0.0  specular 0.0 }
    #declare BondFinish = finish { ambient 0.0  diffuse 0.0  specular 0.0 }

    #declare isoF = 0.0;
    #declare isoT = 0.0;
    #declare isoFinish = finish { ambient 0.0  diffuse 0.0  specular 0.0 }
#else
    #declare AF=0;
    #declare AT=0;

    #declare BF=0.36;
    #declare BT=0.075;

    #declare AtomFinish=finish {
        ambient 0.01 diffuse 0.685 specular 0.952 roughness 0.00551 // reflection { 0.0125 metallic }
        //  ambient 0.01 diffuse 0.4685 specular 0.43952 roughness 0.00551 reflection { 0.0125 metallic }
         metallic
        }
    #declare BondFinish=finish {
        ambient 0.34 diffuse 0.39 specular 0.67 roughness 0.03 //reflection { 0.775 metallic }
        //ambient 0.1 diffuse 0.29 specular 0.267 roughness 0.03 //reflection { 0.775 metallic }
        }

    #declare deltaj = 0.05;
    /*#declare isoTs = array[20];
    #declare j=0;
    #while (j<20)
      #declare isoTs[j] = j*deltaj;
      #declare j=j+1;
    #end
    #declare isoT = isoTs[clock];*/
    #declare isoT = 10*deltaj; // 0.35; //0.45;
    #declare isoF = 0.185; //0.185; // 0.05; //0.01;

    #if (FinalIso)
        #declare isoFinish = finish {
            ambient 0.3125  diffuse 1.0  specular 0.4 roughness 0.005  brilliance 3.85 irid {0.18}
            reflection { 0.01 metallic }
            }
    #else
        #declare isoFinish = finish {
            ambient 0.125  diffuse 1.0  specular 0.4 roughness 0.005  brilliance 5 irid {0.60}
            reflection { 0.1 metallic }
            }
    #end
#end
#declare AtomFT = <0,0,0,AF,AT>;
#declare AtomColor49 = RedColor/TFF + AtomFT;
#declare AtomColor7 = BlueColor/TFF + AtomFT;
#declare AtomColor1 = AntiFlashWhite/TFF + AtomFT;

#declare BondFT = <0,0,0,BF,BT>;
#declare BondColor49 = RedColor/TFF*0.95 + BondFT;
#declare BondColor7= BlueColor/TFF*0.95 + BondFT;
#declare BondColor1= AntiFlashWhite/TFF*0.95 + BondFT;

#declare isoColor = pigment {
    color rgbft <1.0, 1.0, 1.0 isoF isoT>
    //color rgbft <14/255, 255/255, 20/255, isoF, isoT>
    }

#include "crystal.pov"
#if (RenderCrystal)
    #if (!TestFog & !MakeMask)
        light_group {
            #declare jj=0;
            #while (jj<1)
                light_source { MolLights[0] }
                light_source { MolLights[1] }
                light_source { MolLights[2] }
                light_source { MolLights[3] }
                light_source { MolLights[4] }
                light_source { MolLights[5] }
                light_source { MolLights[6] }
                light_source { MolLights[7] }
                light_source { MolLights[8] }
                light_source { MolLights[9] }
                //light_source { MolLights[10] }
                #declare jj=jj+1;
            #end
        object {
            Molecule
            no_shadow
            Center_Trans(Molecule, x+y+z)
            translate -1.25*z
            //rotate (-20+clock*20)*z
            rotate -30*z
            rotate AtomTheta*y
            rotate AtomPhi*z
            }
        global_lights off
        }
    #end
#end
#if (RenderIso)
    #include "iso-2.pov"
    #if (!TestFog & !MakeMask)
        #declare IsoSurf = object { Iso
        texture { finish { isoFinish } pigment { isoColor } }
        }
        light_group {
            #declare jj=0;
            #while (jj<1)
                // down
                light_source { IsoLights[0] }
                light_source { IsoLights[1] }
                light_source { IsoLights[2] }
                light_source { IsoLights[3] }
                // axial
                light_source { IsoLights[4] }
                light_source { IsoLights[5] }
                // cam
                light_source { IsoLights[6] }
                light_source { IsoLights[7] }
                light_source { IsoLights[8] }
                light_source { IsoLights[9] }
                // interior
                light_source { IsoLights[10] }
            #declare jj=jj+1;
            #end
            object {
                IsoSurf
                #if (!FinalIso)
                    no_shadow
                #end
                Center_Trans(Molecule, x+y+z)
                translate -1.25*z
                rotate -30*z
                rotate AtomTheta*y
                rotate AtomPhi*z
                }
            global_lights off
            }
    #end
#end
#if (UseFog)
    #if (MakeMask)
        #declare FogLightAmp = 1.0;
    #else
    media{
      scattering{
        1, 0.25
        #if (FinalIso)
            #declare FogLightAmp = 1.0;
            extinction 0.63
        #else
            #if (MultipleDen)
                #declare FogLightAmp = 2.71;
                extinction 0.63
            #else
                #declare Brighter = false;
                #if (Brighter)
                    #declare FogLightAmp = 2.485;
                    extinction 0.38
                #else
                    #declare FogLightAmp = 1.0;
                    extinction 0.33
                #end
            #end
        #end
        }
        confidence 0.95
        variance 0.005
        #if (HiQ)
            intervals 40 //
            samples 80,80
        #else
            intervals 40
            samples 50,50
        #end
        method 2
        #if (MultipleDen)
            density {
                granite scale 8 rotate <45,45,45>
                color_map {
                    [0.0 rgb <1,1,1>*0.2]
                    [0.5 rgb <1,1,1>*0.4]
                    [1.0 rgb <1,1,1>*1  ]
                    }
                }
            density {
                granite scale 16 rotate <45,45,45>
                color_map {
                    [0.0 rgb <1,1,1>*0.1]
                    [0.5 rgb <1,1,1>*0.2]
                    [1.0 rgb <1,1,1>*1  ]
                    }
                }
        #else
            density {
                granite scale 8
                color_map {
                    [0.0 rgb <1,1,1>*0.1]
                    [0.5 rgb <1,1,1>*0.2]
                    [1.0 rgb <1,1,1>*1  ]
                    }
                }
        #end
    }
    #end
    #if (!FinalIso)
            light_source {
                 -CamPos*0.75
                 //color White*16
                 //color WarmLightColor
                 color rgb <14, 255, 20>/255*FogLightAmp
                 spotlight
                 point_at Origin
                 radius 30
                 falloff 45
                 //tightness 10
                 #if (HiQ)
                    area_light <0,0.75,0>, <0,0,0.75>, 3,3
                    adaptive NAdapt
                    jitter
                 #end
                 }
        #if (RenderIso | MakeMask)
            //#include "iso-4.pov"
            #declare isoColorGlass = pigment {
                color rgbft <1.0, 1.0, 1.0 0.0 0.0>
                }
            #declare IsoSurfGlass = object { Iso
                texture { finish { isoFinish } pigment { isoColorGlass } }
                }
            object {
                IsoSurfGlass
                #if (!MakeMask)
                    no_reflection
                    no_image
                #end
                //interior { ior 1.5 }
                Center_Trans(Molecule, x+y+z)
                translate -1.25*z
                rotate -30*z
                rotate AtomTheta*y
                rotate AtomPhi*z
                }
        #end
        #if (MakeMask & RenderCrystal)
            object {
                Molecule
                no_shadow
                Center_Trans(Molecule, x+y+z)
                translate -1.25*z
                //rotate (-20+clock*20)*z
                rotate -30*z
                rotate AtomTheta*y
                rotate AtomPhi*z
                }
        #end
    #end
#end
