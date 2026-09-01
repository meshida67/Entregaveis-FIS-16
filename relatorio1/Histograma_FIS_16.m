clear;
clc;
close all;

arquivos = {'dados_cb.txt', 'dados_cm.txt'};

%Limites dos gráficos
graf_min = 11.3;
graf_max = 12.1;

%Distribuição gaussiana
function y = norm(x, n, sigma, data, binwidth)
    y = normpdf(x, n, sigma) * length(data) * binwidth;
end

%Função nula
function y = nulo(x)
    y = 0 * x;
end

%Plotando os histrogramas
for i = 1:length(arquivos)

    data = readmatrix(arquivos{i}, 'NumHeaderLines', 1);
    
    n_exp = mean(data);
    sigma_expec = std(data);

    f = figure;
    f.Color = 'w';
    f.Name = arquivos{i};

    n = length(data);
    k = ceil(1 + log2(n));

    h = histogram(data, k);

    y_hist(i,:) = h.Values;
    x_hist(i,:) = (h.BinEdges(1:(end - 1)) + h.BinEdges(2:end)) * 0.5;

    err(i,:) = - y_hist(i,:) + norm(x_hist(i,:), n_exp, sigma_expec, data, h.BinWidth);

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

    tx = xlabel('\it{10T} (s)');
    ty = ylabel('Frequência');
    tx.FontSize = 16;
    ty.FontSize = 16;
end

%Calculandos os coefs de determinação
for i = 1:2
    r2(i) = sum(err(i,:) .^ 2) / sum((y_hist(i,:) - mean(y_hist(i,:))).^2);
    disp(r2(i));
end

%Plotando os desvios
ferr = figure;
tiledlayout(1,2);

for i = 1:2
    nexttile
    hold on
    box on

    p = plot(x_hist(i, :), err(i, :), 'b.', MarkerSize=17);
    plot(x, nulo(x), '--');
    legend('Desvios', 'Desvio nulo', fontsize = 13);
    xlabel('$10T$ (s)', Interpreter='latex', FontSize=16);
    ylabel('$f_{Gauss}-f_{hist}$', Interpreter='latex', FontSize=16);
    ylim([-6 6]);
end

