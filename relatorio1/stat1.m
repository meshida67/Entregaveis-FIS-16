clear;
clc;
close all;

g0 = 9.786;

% OBS: Esta função assume que o número de graus
% de liberdade é suficientemente grande.
function [p, z] = teste_hipotese(a, b, err_a, err_b)
    err = sqrt(err_a^2 + err_b^2);
    z = abs(a - b) / err;
    p = 1 - erf(z / sqrt(2));
end

arquivo    = 'dados.txt';
err_fd     = 1e-4;
err_vid    = 2 * sqrt(2) / 240; % TODO: Isso está correto?
num_frames = 287;
len_fio    = 35e-2;
err_fio    = 5e-4;

data = readmatrix(arquivo);

per_fd     = mean(data);
err_per_fd = sqrt((std(data)/sqrt(length(data))) ^ 2 + err_fd^2);

fprintf("Fotodiodo: T = (%.5f ± %.5f) s.\n", per_fd, err_per_fd);

g_fd     = len_fio * (2 * pi / per_fd)^2;
err_g_fd = sqrt((2 * pi / per_fd)^4 * err_fio^2 ...
          + (64 * len_fio^2 * pi^4 / per_fd^6) * err_per_fd^2);

fprintf("Fotodiodo: g = (%.3f ± %.3f) m/s^2.\n\n", g_fd, err_g_fd);

per_tr   = num_frames / 240; % FPS = 240.
g_tr     = len_fio * (2 * pi / per_tr)^2; 
err_g_tr = sqrt((2 * pi / per_tr)^4 * err_fio^2 ...
    + (64 * len_fio^2 * pi^4 / per_tr^6) * err_vid^2);

fprintf("Tracker: T = (%.3f ± %.3f) s.\n", per_tr, err_vid);
fprintf("Tracker: g = (%.2f ± %.2f) m/s^2.\n", g_tr, err_g_tr);

% Testes de hipótese

fprintf('\n\n');

[p03, z03] = teste_hipotese(g_tr, g0, err_g_tr, 0);
fprintf("Teste de hipótese (Tracker vs valor verdadeiro):        ");
fprintf("z = %.2f, α = %.3f.\n", z03, p03);

[p04, z04] = teste_hipotese(g_fd, g0, err_g_fd, 0);
fprintf("Teste de hipótese (Fotodiodo vs valor verdadeiro):      ");
fprintf("z = %.2f, α = %.3f.\n", z04, p04);

[p34, z34] = teste_hipotese(g_tr, g_fd, err_g_tr, err_g_fd);
fprintf("Teste de hipótese (Fotodiodo vs tracker):               ");
fprintf("z = %.2f, α = %.3f.\n", z34, p34);

g1     = 10.03;
g2     = 10.06;
err_g1 = 0.15;
err_g2 = 0.15;

[p13, z13] = teste_hipotese(g_tr, g1, err_g_tr, err_g1);
fprintf("Teste de hipótese (Tracker vs cronômetro de mão):       ");
fprintf("z = %.2f, α = %.3f.\n", z13, p13);

[p14, z14] = teste_hipotese(g_fd, g1, err_g_fd, err_g1);
fprintf("Teste de hipótese (Fotodiodo vs cronômetro de mão):     ");
fprintf("z = %.2f, α = %.3f.\n", z14, p14);

[p23, z23] = teste_hipotese(g_tr, g2, err_g_tr, err_g2);
fprintf("Teste de hipótese (Tracker vs cronômetro de bancada):   ");
fprintf("z = %.2f, α = %.3f.\n", z23, p23);

[p24, z24] = teste_hipotese(g_fd, g2, err_g_fd, err_g2);
fprintf("Teste de hipótese (Fotodiodo vs cronômetro de bancada): ");
fprintf("z = %.2f, α = %.3f.\n", z24, p24);