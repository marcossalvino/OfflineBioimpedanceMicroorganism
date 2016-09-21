clear all;
close all;
clc;

  function approx_root = bisect ( a, b )
% bisect finds an approximate root of the function cosy using bisection
fa = a - 0.2*sin(a) - 0.5;
fb = b - 0.2*sin(b) - 0.5;
while ( abs ( b - a ) > 0.000001 )
c = ( a + b ) / 2;
approx_root = c;
fc = c - 0.2*sin(c) - 0.5;
% What follows is just a nice way to print out a little table. It does not add to
% the algorithm itself, it only makes it easier to see what is going on at runtime.
%
[ a, c, b;
fa, fc, fb ]
if ( sign(fb) * sign(fc) <= 0 )
a = c;
fa = fc;
else
b = c;
fb = fc;
end
end