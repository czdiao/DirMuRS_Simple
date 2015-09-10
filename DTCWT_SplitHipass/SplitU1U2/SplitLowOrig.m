function [ u1, u2 ] = SplitLowOrig
%SPLITLOWORIG Summary of this function goes here
%   Detailed explanation goes here


u1_filter = [-0.60681876962335599886786626353146e0 -0.49991154192621583718062920651918e0 0.10690722769714197302003653746564e0];
u1_start_pt = -1;
u2_filter = [-0.25470239962557002238379596440787e0 0.49059520074885961634677871315419e0 -0.25470239962557036126943406144510e0];
u2_start_pt = -1;

u1 = filter1d(u1_filter, u1_start_pt);
u2 = filter1d(u2_filter, u2_start_pt);



end

