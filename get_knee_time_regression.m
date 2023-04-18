function knee_time_regression = get_knee_time_regression()

% Data from Gao et al
data = [0.8928571428571423, 4.424778761061944
1.7857142857142865, 5.13274336283186
2.8571428571428577, 5.486725663716811
4.107142857142858, 6.548672566371678
5.357142857142858, 7.61061946902656
6.785714285714288, 8.318584070796462
8.035714285714288, 9.026548672566378
9.285714285714288, 9.734513274336294
10.357142857142858, 10.442477876106196
11.607142857142858, 10.796460176991161
12.678571428571427, 10.796460176991161
13.571428571428573, 11.150442477876112
14.642857142857142, 11.504424778761063
15.714285714285712, 11.504424778761063
16.96428571428571, 11.504424778761063
18.035714285714285, 11.150442477876112
18.92857142857143, 10.796460176991161
20, 10.088495575221245
21.071428571428573, 10.088495575221245
22.142857142857142, 9.734513274336294
23.03571428571429, 9.380530973451329
23.928571428571427, 8.672566371681427
25.000000000000004, 7.964601769911511
25.71428571428571, 7.61061946902656
26.78571428571428, 6.9026548672566435
27.85714285714285, 5.840707964601776
29.28571428571428, 5.13274336283186
30.71428571428571, 4.424778761061944
31.78571428571428, 3.716814159292042
33.03571428571429, 3.008849557522126
34.64285714285714, 2.654867256637175
36.42857142857143, 1.9469026548672588
37.85714285714285, 1.2389380530973426
38.92857142857143, 0.8849557522123916
40, 0.8849557522123916
41.07142857142857, 0.5309734513274265
42.14285714285714, 0.5309734513274265
43.21428571428571, 0.5309734513274265
44.46428571428571, 0.8849557522123916
45.71428571428571, 1.2389380530973426
46.96428571428571, 1.5929203539823078
48.21428571428572, 1.9469026548672588
49.28571428571429, 3.008849557522126
50.53571428571429, 3.716814159292042
51.78571428571428, 4.424778761061944
53.03571428571428, 6.194690265486727
54.10714285714285, 7.964601769911511
55.35714285714286, 9.380530973451329
56.42857142857143, 11.150442477876112
57.5, 12.920353982300895
58.749999999999986, 15.04424778761063
59.64285714285714, 16.460176991150448
60.53571428571428, 18.230088495575217
61.78571428571428, 20.35398230088495
62.85714285714285, 22.83185840707965
63.928571428571416, 25.309734513274336
65.17857142857142, 28.49557522123895
66.07142857142856, 30.619469026548686
66.96428571428571, 33.451327433628336
68.2142857142857, 36.28318584070797
69.10714285714285, 39.11504424778761
70.35714285714286, 41.59292035398231
71.42857142857143, 43.36283185840709
72.32142857142857, 44.77876106194691
73.57142857142857, 45.840707964601776
74.82142857142857, 45.840707964601776
76.07142857142856, 45.486725663716825
77.5, 44.42477876106196
78.57142857142857, 43.008849557522126
79.64285714285714, 41.94690265486726
80.71428571428571, 40.53097345132744
81.78571428571428, 39.11504424778761
82.5, 36.99115044247789
83.2142857142857, 35.57522123893807
84.10714285714285, 33.80530973451329
84.99999999999999, 31.327433628318587
86.07142857142856, 29.203539823008853
86.78571428571428, 27.07964601769912
87.67857142857142, 24.955752212389385
88.57142857142857, 22.4778761061947
89.64285714285714, 20
90.89285714285714, 17.876106194690266
91.78571428571428, 15.04424778761063
92.85714285714285, 12.920353982300895
94.10714285714285, 11.150442477876112
95.35714285714285, 8.672566371681427
96.78571428571428, 6.548672566371678
98.2142857142857, 5.13274336283186
99.64285714285714, 3.716814159292042
100.89285714285714, 2.3008849557522097];

time = (data(:,1)-60)./40; % Normalize time

knee_time_regression = polyfit(time,data(:,2),9);

% Plot unfitted data and regression
figure(2);
scatter(time, data(:,2), '.', 'r');
hold on
plot(time, polyval(knee_time_regression,time), 'b');
title("Knee Angle vs. Time");
xlabel("Time (s)");
ylabel("Knee angle in degrees");
legend("Unfitted data", "Polynomial fit");


end
