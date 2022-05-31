function [means, f] = meanVarPlot(labels, values)
%MEANVARPLOT Summary of this function goes here
%   Detailed explanation goes here

narginchk(2,2)
if(~isequal(size(labels), size(values)))
    error("labels and values have different size!");
end
if nargout ~= 0
    f = figure;
end

width = 0.125;
values = reshape(values, 1, []);
labels = reshape(labels, 1, []);

uLab = unique(labels);
N = numel(uLab);

means = nan(1, N);
stds = nan(1, N);
for i = 1:N
    means(i) = mean(values(labels == uLab(i)));
    stds(i) = std(values(labels == uLab(i)));
end

maxPlt = max(means + stds);
minPlt = min(means - stds);
range = maxPlt - minPlt;

linePlot = plot(means, 'LineStyle', 'none', 'Marker', 's', 'Color', 'b');
hold(linePlot.Parent, 'on')
for i = 1:N
    linePlot = plot(linePlot.Parent, [i i], [-stds(i), stds(i)] + means(i), '-b');
    linePlot = plot(linePlot.Parent, [-0.5,0.5]*width + i, [-stds(i), -stds(i)] + means(i), '-b');
    linePlot = plot(linePlot.Parent, [-0.5,0.5]*width + i, [stds(i), stds(i)] + means(i), '-b');
end
linePlot.Parent.XTick = 1:N;
linePlot.Parent.XTickLabel = uLab;
linePlot.Parent.XLabel.String = "Bins";
linePlot.Parent.YLabel.String = "Values";
axis([0.5, numel(means) + 0.5, minPlt - 0.1 * range, maxPlt + 0.1 * range]);
hold(linePlot.Parent, 'off')
end

