clear;
clc;
close all;

%Fotodiodo
arquivo = 'dados.txt';

%Limites dos gráficos
graf_min = 1.188;
graf_max = 1.194;

%Distribuição gaussiana
function y = norm(x, n, sigma, data, binwidth)
y = normpdf(x, n, sigma) * length(data) * binwidth;
end

%Função nula
function y = nulo(x)
y = 0 * x;
end

data = readmatrix(arquivo);

n_exp = mean(data);
sigma_expec = std(data);

f = figure;
f.Color = 'w';
f.Name = arquivo;

n = length(data);
k = ceil(1 + log2(n));

h = histogram(data, k);

y_hist = h.Values;
x_hist = (h.BinEdges(1:(end - 1)) + h.BinEdges(2:end)) * 0.5;

err = - y_hist + norm(x_hist, n_exp, sigma_expec, data, h.BinWidth);

hold on;

x = linspace(graf_min, graf_max, 200);

g = plot(x, norm(x, n_exp, sigma_expec, data, h.BinWidth), ...
    'r', 'LineWidth', 2.5);

legend([h g], {'Dados experimentais', 'Distribuição Gaussiana'}, ...
    'FontSize', 16, 'Location', 'northeast');

axis([graf_min graf_max 0 35]);

ax = gca;

ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;

ax.XMinorTick = 'on';
ax.YMinorTick = 'on';

ax.LineWidth = 1.5;

tx = xlabel('\it{10T} (s)');
ty = ylabel('Frequência');

tx.FontSize = 20;
ty.FontSize = 20;

title('Fotodiodo', ...
    'FontSize', 20, 'FontWeight', 'bold');

ferr = figure;

nexttile
hold on
box on

p = plot(x_hist, err, 'b.', 'MarkerSize', 22);

p0 = plot(x, nulo(x), '--', 'LineWidth', 2.5);

lgd = legend([p p0], 'Desvios', 'Desvio nulo');
lgd.FontSize = 16;

xlabel('$10T$ (s)', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('$f_{Gauss}-f_{hist}$', 'Interpreter', 'latex', 'FontSize', 20);

title('Fotodiodo', ...
    'FontSize', 20, 'FontWeight', 'bold');

ylim([-10 10]);
xlim([1.189 1.194]);

% Aparência dos eixos
ax = gca;
ax.FontSize = 18;
ax.LineWidth = 1.5;
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';

r2 = sum(err(:) .^ 2) / sum((y_hist(:) - mean(y_hist(:))) .^ 2);
fprintf("%s: %f\n", arquivo, r2);