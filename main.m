clc;
clear;
close all;

boiler = Boiler(460, 20, 4186, 50, 8000, 310, 310, 0.08, 1);
pipe = Pipe(385, 8920, 4186, 980, 310, 310, 0.08, 100, 0.1, 390, 0.0125, 0.015, 10);
radiator = Radiator(880, 35, 4186, 5, 310, 310, 0.08, 10, 5);

% time %
dt = 60;
day = 1;
t_start = 1;
t_end = 24 * 3600;
t_array = (t_start:dt:t_end);
h_array = (t_start:dt:t_end)/3600;

radiator.c_ti(dt)
radiator.c_to(dt)
radiator.c_te()
radiator.c_r(dt)