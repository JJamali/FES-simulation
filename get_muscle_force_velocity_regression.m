function [force_velocity_regression] = get_muscle_force_velocity_regression()
% 1D regression model with Gaussian basis functions.

% Input Parameters
% data(:,1): samples of an independent variable
% data(:,2): corresponding samples of a dependent variable

data = [-0.9438202247191011, 0
-0.9157303370786517, 0.006557377049180468
-0.8932584269662922, 0.013114754098360493
-0.8707865168539326, 0.019672131147541183
-0.853932584269663, 0.022950819672131084
-0.8202247191011236, 0.029508196721311553
-0.7865168539325843, 0.039344262295082144
-0.7640449438202248, 0.04590163934426239
-0.7303370786516855, 0.05245901639344286
-0.7078651685393259, 0.06229508196721323
-0.6825842696629214, 0.07049180327868876
-0.651685393258427, 0.07868852459016407
-0.6264044943820224, 0.09180327868852456
-0.6011235955056181, 0.10491803278688527
-0.5786516853932585, 0.11475409836065564
-0.5449438202247191, 0.1311475409836067
-0.5280898876404495, 0.14098360655737707
-0.5, 0.1573770491803279
-0.4887640449438203, 0.17049180327868863
-0.4662921348314607, 0.18688524590163946
-0.4438202247191012, 0.20655737704918042
-0.4325842696629215, 0.21967213114754114
-0.4101123595505618, 0.23606557377049198
-0.3876404494382024, 0.2524590163934426
-0.3707865168539326, 0.2655737704918033
-0.353932584269663, 0.2885245901639346
-0.3314606741573034, 0.30819672131147535
-0.3202247191011238, 0.32131147540983607
-0.303370786516854, 0.34098360655737725
-0.2865168539325844, 0.360655737704918
-0.26404494382022503, 0.3770491803278688
-0.24719101123595522, 0.3967213114754098
-0.2359550561797754, 0.41967213114754087
-0.2191011235955056, 0.4426229508196722
-0.20786516853932602, 0.46229508196721314
-0.19101123595505642, 0.4819672131147541
-0.1741573033707866, 0.5016393442622953
-0.1629213483146068, 0.5180327868852459
-0.15168539325842723, 0.5377049180327869
-0.1460674157303372, 0.5540983606557377
-0.1348314606741574, 0.577049180327869
-0.11797752808988782, 0.5967213114754097
-0.11235955056179803, 0.6131147540983606
-0.10112359550561822, 0.639344262295082
-0.09550561797752821, 0.6557377049180328
-0.08426966292134841, 0.6754098360655738
-0.08426966292134841, 0.6885245901639345
-0.07865168539325862, 0.7081967213114753
-0.061797752808989026, 0.7278688524590164
-0.056179775280899014, 0.7540983606557379
-0.05056179775280922, 0.7737704918032788
-0.04775280898876422, 0.8
-0.03932584269662942, 0.8262295081967215
-0.03370786516853963, 0.8491803278688524
-0.02528089887640461, 0.8721311475409834
-0.016853932584269815, 0.8983606557377048
-0.014044943820224809, 0.9262295081967212
-0.005617977528090012, 0.957377049180328
-2.220446049250313e-16, 0.9836065573770492
-2.220446049250313e-16, 1.0098360655737704
0.005617977528089568, 1.039344262295082
0.008426966292134574, 1.0737704918032787
0.01123595505617958, 1.1016393442622952
0.028089887640449174, 1.1311475409836067
0.039325842696628976, 1.160655737704918
0.050561797752809, 1.1868852459016392
0.07303370786516838, 1.2131147540983607
0.09550561797752777, 1.2295081967213115
0.12359550561797739, 1.2426229508196722
0.15168539325842678, 1.2524590163934426
0.17415730337078617, 1.262295081967213
0.2078651685393258, 1.2721311475409836
0.23595505617977497, 1.2852459016393443
0.2780898876404494, 1.2934426229508196
0.3146067415730336, 1.3016393442622949
0.35393258426966256, 1.3081967213114754
0.387640449438202, 1.3163934426229509
0.42415730337078617, 1.3229508196721311
0.4606741573033706, 1.3278688524590163
0.49438202247191, 1.3344262295081966
0.5337078651685392, 1.3377049180327867
0.5730337078651682, 1.3442622950819672
0.6123595505617974, 1.3508196721311474
0.646067415730337, 1.3540983606557377
0.6797752808988762, 1.360655737704918
0.7134831460674154, 1.3672131147540982
0.7528089887640446, 1.3721311475409834
0.7921348314606738, 1.3786885245901639
0.831460674157303, 1.383606557377049
0.8707865168539322, 1.3885245901639343
0.9101123595505614, 1.3967213114754098
0.9494382022471906, 1.4
0.985955056179775, 1.401639344262295
1.0224719101123594, 1.4032786885245903
1.0617977528089886, 1.4049180327868853
1.1011235955056178, 1.4065573770491804];

velocity = data(:,1);
force = data(:,2);

% Ridge Regression
% NOTE: this is different than TASK 2 of Question 1, follow the instruction
% for TASK 2
%fun = @(x, mu, sigma) 1./(1+exp(-(x-mu)./sigma));
%X = [];
%%%for i = -1:0.2:-0.1
 %   X = [X fun(velocity, i, 0.15)];
%end
%force_velocity_regression = ridge(force, X, 1, 0);
%end
   force_velocity_regression = polyfit(velocity,force,9); 

   figure(5);
   subplot(1,2,1);
   plot(velocity,force);
   title("Unfitted force-velocity");
   subplot(1,2,2);
   plot(velocity,polyval(force_velocity_regression,velocity));
   title("Fitted force-velocity")

end
% fv curve