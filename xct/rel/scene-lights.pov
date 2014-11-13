#declare HiQ = true;
#declare NAdapt = 6;

#declare IsoLightColor = rgb <14/255, 255/255, 20/255>;
//#declare IsoLightColor = rgb <1,1,1>;
#declare LightAt = <15.6,0,69>;

#declare InteriorLight0 = light_source {
    LightAt
    color <1,0,0>*1.0
}

#declare AxialLightDim = 0.5;
#declare AxialLight0 = light_source {
    <15.6,0,-10>
    color IsoLightColor*AxialLightDim
    parallel
    point_at LightAt
}
#declare AxialLight1 = light_source {
    <15.6,0,146>
    color IsoLightColor*AxialLightDim
    parallel
    point_at LightAt
}


#declare DownLightR = 40;
#declare DownLightPhi = Phi + pi/2.0;
#declare DownLightPos = <DownLightR*sin(Theta)*cos(DownLightPhi), DownLightR*sin(Theta)*sin(DownLightPhi), DownLightR*cos(Theta)> + Center;
#declare DownLightDim = 0.95;
#declare DownLight0 = light_source {
    DownLightPos
    color IsoLightColor*DownLightDim
    //parallel
    //point_at LightAt
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
}

#declare UpLight0 = light_source {
    -1*DownLightPos
    color IsoLightColor*DownLightDim
    //parallel
    //point_at LightAt
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
}



#declare CamLight0 = light_source {
    CamPos
    color IsoLightColor*0.75
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
    //parallel
    //point_at CamAt
}
#declare CamLight1 = light_source {
    CamPos
    color IsoLightColor*1.0
    //color <1,1,1>*0.5
    parallel
    point_at CamAt
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
}
#declare CamLight2 = light_source {
    -1*CamPos
    color IsoLightColor*1.0
    //parallel
    //point_at CamAt
}
#declare CamLight3 = light_source {
    CamPos
    color <254,223,0,>/255.0*0.125
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
    //parallel
    //point_at CamAt
}




#declare CrystalLightColor = <1,1,1>;
#declare AxialLight00 = light_source {
    <15.6,0,-10>
    color CrystalLightColor*.30
    //parallel
    //point_at LightAt
}
#declare AxialLight11 = light_source {
    <15.6,0,146>
    color CrystalLightColor*0.30
    //parallel
    //point_at LightAt
}

#declare CamLight00 = light_source {
    CamPos
    color <1,1,1>*0.95
    //parallel
    //point_at CamAt
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
}
#declare CamLight11 = light_source {
    CamPos
    //color <254,223,0,>/255.0*0.5
    color <1,1,1>*0.25
    parallel
    point_at CamAt
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
}
#declare CamLight33 = light_source {
    CamPos
    color <254,223,0,>/255.0*0.125
    //parallel
    //point_at CamAt
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
}

#declare DownLight00 = light_source {
   DownLightPos
    color CrystalLightColor*0.35
    parallel
    point_at LightAt
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
}

#declare UpLight00 = light_source {
   -1*DownLightPos
    //<15.6,-40,69>
    color CrystalLightColor*0.35
    parallel
    point_at LightAt
#if (HiQ)
    area_light <0,5,0>, <0,0,5>, 3,3
    adaptive NAdapt
    jitter
#end
}


/*
#declare PV_Light_1 = light_source {
	<-26.244181, -0.687544, 70.008053>
	color <1.000000, 1.000000, 1.000000>*0.23
	parallel
	point_at <112.776841, 1.600235, 70.008053>
}

#declare PV_Light_2 = light_source {
	<-26.244181, -0.687544, 70.008053>
	color <0.999800, 0.999800, 0.999800>*0.250000
	parallel
	point_at <112.776841, 1.600235, 70.008053>
}

#declare PV_Light_3 = light_source {
	<0.111619, 0.766044, 0.633022>
	color <1.000000, 0.972320, 0.902220>*0.750000
	parallel
	point_at <0.000000, 0.000000, 0.000000>
}

#declare PV_Light_4 = light_source {
	<-0.044943, -0.965926, 0.254887>
	color <0.908240, 0.933140, 1.000000>*0.250000
	parallel
	point_at <0.000000, 0.000000, 0.000000>
}

#declare PV_Light_5 = light_source {
	<0.939693, 0.000000, -0.342020>
	color <0.999800, 0.999800, 0.999800>*0.214286
	parallel
	point_at <0.000000, 0.000000, 0.000000>
}

#declare PV_Light_6 = light_source {
	<-0.939693, 0.000000, -0.342020>
	color <0.999800, 0.999800, 0.999800>*0.214286
	parallel
	point_at <0.000000, 0.000000, 0.000000>
}
*/
