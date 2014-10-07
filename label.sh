#!/bin/bash

inpref=$1
if [ -z "$inpref" ]
then
  echo "error: give the input image prefix"
  exit
fi

times=(1 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 11000 12000 13000 14000 15000 16000 17000 18000 19000 20000 21000 22000 23000 24000 25000 26000 27000 28000 29000 30000 31000 32000 33000 34000 35000 36000 37000 38000 39000 40000 41000 42000 43000 44000 45000 46000 47000 48000 49000 50000 51000 52000 53000 54000 55000 56000 57000 58000 59000 60000 61000 62000 63000 64000 65000 66000 67000 68000 69000 70000 71000 72000 73000 74000 75000 76000 77000 78000 79000 80000 81000 82000 83000 84000 85000 86000 87000 88000 89000 90000 91000 92000 93000 94000 95000 96000 97000 98000 99000 100000 101000 102000 103000 104000 105000 106000 107000 108000 109000 110000 111000 112000 113000 114000 115000 116000 117000 118000 119000 120000 121000 132000 137000 138000 139000 140000 141000 142000 143000 144000 145000 146000 147000 148000 149000 150000 151000 152000 153000 154000 155000 156000 157000 158000 159000 160000 161000 162000 163000 164000)

for clock in `seq 0 1150`
do
  # set the camera angle and data time based on
  # the clock variable to move through the
  # phases of animation
  if ((${clock} <= 100))
  then
    # the first 100 steps show the Earth spinning
    cam_clock=0;
    # no data
    data_time=-1;
  fi

  if (((${clock} > 100) & (${clock} <= 500)))
  then
    # archimedian orbit
    cam_clock=`echo ${clock} - 100 | bc`;
    # data advances 1:3
    data_time=`echo "(${clock} - 400)/3" | bc`;
  fi

  if (((${clock} > 500) & (${clock} <= 700)))
  then
    # archimedian orbit
    cam_clock=`echo ${clock} - 100 | bc`;
    # data advances 1:3
    data_time=`echo "(${clock} - 400)/3" | bc`;
  fi

  if (((${clock} > 700) & (${clock} <= 760)))
  then
    # camera stopped
    cam_clock=600;
    # data advance 1:3
    data_time=`echo "(${clock}-400)/3" | bc`;
  fi

  if (((${clock} > 760) & (${clock} <= 960)))
  then
    # circular orbit
    cam_clock=`echo "${clock} - 160" | bc`;
    # data stopped
    data_time=120;
  fi

  if (((${clock} > 960) & (${clock} <= 1050)))
  then
    # camera stopped
    cam_clock=800;
    # data advances 1:3
    data_time=`echo "(${clock} - 600)/3" | bc`;
  fi

  if (((${clock} > 1050) & (${clock} <= 1450)))
  then
    # circular orbit
    cam_clock=`echo "${clock} - 250" | bc`;
    # data stopped
    data_time=150;
  fi

  if ((${clock} > 1450))
  then
    # camera stopped
    cam_clock=1200;
    # data stopped
    data_time=150;
  fi

  if ((${data_time} < 0))
  then
    data_time=0
  fi

  k=`echo  ${times[${data_time}]}/1000 | bc`
  s=`printf "% 3sK:%-4s" ${k} "${clock}"`
  n=`printf %04.f ${clock}`

  echo "\"$s\""
  sq-annotate.sh ${inpref}-${n}.png anno/${inpref}-${n}.png "${s}" 1280 1040 0 32 w "01 Digitall" && \
  sq-overlay.sh anno/${inpref}-${n}.png ../nersc-logo-small.png anno/${inpref}-${n}.png 13 999 &

  pid=$!

  q=`echo ${clock}%10 | bc`
  if [ "${q}" -eq "0" ]
  then
      wait ${pid}
  fi

done
