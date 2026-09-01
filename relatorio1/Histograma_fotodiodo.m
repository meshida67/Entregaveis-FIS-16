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
    'r', 'LineWidth', 1.5);

legend([h g], {'Dados experimentais', 'Distribuição Gaussiana'}, ...
    'FontSize', 13, 'Location', 'best');

axis([graf_min graf_max 0 35]);

ax = gca;
ax.XAxis.FontSize = 14;
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
ax.YAxis.FontSize = 14;

tx = xlabel('\it{T} (s)');
ty = ylabel('Frequência');
tx.FontSize = 16;
ty.FontSize = 16;

ferr = figure;

nexttile
hold on
box on

p = plot(x_hist, err, 'b.', MarkerSize=17);
plot(x, nulo(x), '--');
legend('Desvios', 'Desvio nulo', fontsize = 13);
xlabel('$10T$ (s)', Interpreter='latex', FontSize=16);
ylabel('$f_{Gauss}-f_{hist}$', Interpreter='latex', FontSize=16);
ylim([-10 10]);
xlim([1.189, 1.194]);