%
x1 = [0:0.01:0.5];
x2 = [0.5:0.01:1];
y1 = x1 .* (1 - x1);
y2 = x2 .* (1 - x2);
F = figure;
A = axes;
hold on;
axis([0 1 0 0.3]);
P = plot(x1,y1,'r');
P = plot(x2,y2,'b');
P = plot([0.5 1],[0.25 0.25],'g');
set(A,'XTick',[0.5],'XTickLabel',[],'YTick',[]);
print(F,'-depsc','Fig5');