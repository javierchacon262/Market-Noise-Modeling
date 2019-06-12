disp('Request historical S&P 500 price and plot Close, High and Low');
initDate = '10-May-2009';
endDate = '10-May-2019';
symbol = '^GSPC';
interval = '1d';
gspc = getMData(symbol, initDate, endDate, interval);
%gspcts = timeseries(gspc.Close, datestr(gspc(:,1).Date));
%gspcts.DataInfo.Units = 'USD';
%gspcts.Name = symbol;
y = gspc.Close';
s = size(y, 2);
x = 1:s;
[b, a] = leastS(x, y);
ys = a*x + b;
yn = y - ys;
figure(1)
subplot(2, 5, 1)
scatter(x, y);
hold on;
plot(x, ys, 'b--')
scatter(x, yn)
legend({'Close Price', 'Trend', 'Noise'});
title('S&P500 10 Years')
subplot(2, 5, 6)
hist(yn, s)
title('Noise Histogram:')
disp('Sample mean of the signal:')
mean(y)
disp('Sample variance of the noise:')
var(yn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcuation of the sample mean of the signal in short periods and the
%sample variance of the noise in the same short periods:
%
%taking into account only 2500 of the 2517 days in the period analysed for
%simplicity, i'm going to divide the data into periods of 10 days.
s2 = 2500;
days = 5;
y2 = y(1:s2);
y3 = yn(1:s2);
y2m = [];
y2v = [];
y2mad = [];
y2iqr = [];
for i = 1:s2/days
    i1 = ((i - 1) * days) + 1;
    i2 = i1 + days - 1;
    y2m = [y2m, mean(y2(i1:i2))];
    y2v = [y2v, var(y3(i1:i2))];
    y2mad = [y2mad, mad(y3(i1:i2))];
    y2iqr = [y2iqr, iqr(y3(i1:i2))];
end
xvar = 1:(s2/days);
ytr = a*xvar + b;
subplot(2, 5, 2)
plot(xvar, y2m)
title('Sample mean for little periods:')
xlabel('periods')
ylabel('sample mean')
subplot(2, 5, 7)
plot(xvar, y2v)
title('Sample variance for little periods:')
xlabel('periods')
ylabel('sample variance')
subplot(2, 5, 3)
plot(xvar, y2mad)
title('Sample mean absolute deviation LP:')
xlabel('periods')
ylabel('mad')
subplot(2, 5, 8)
plot(xvar, y2iqr)
title('Sample interquartile range LP:')
xlabel('periods')
ylabel('iqr')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot of the sample variance of the noise after detrending versus the
%sample mean of the signal
subplot(2, 5, 4)
plot(ytr, y2v)
%title('Sample variance vs. Sample mean')
title('Sample variance vs. Trend')
%xlabel('Sample mean')
xlabel('Trend')
ylabel('Sample variance')
subplot(2, 5, 9)
plot(ytr, y2mad)
%title('Sample mad vs. Sample mean')
title('Sample mad vs. Trend')
%xlabel('Sample mean')
xlabel('Trend')
ylabel('Sample mad')
subplot(2, 5, 5)
plot(ytr, y2iqr)
%title('Sample iqr vs. Sample mean')
title('Sample iqr vs. Trend')
%xlabel('Sample mean')
xlabel('Trend')
ylabel('Sample iqr')
subplot(2, 5, 10)
scatter(y2mad, y2iqr)
title('Sample iqr vs. Sample mad')
xlabel('Sample mad')
ylabel('Sample iqr')