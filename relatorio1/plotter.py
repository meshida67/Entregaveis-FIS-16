import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

dados = np.loadtxt("dados.txt")

mu = np.mean(dados)
std = np.std(dados, ddof = 0)
print(mu)
print(std)

x_range = np.linspace(dados.min(), dados.max(), 100)
ajuste = stats.norm.pdf(x_range, mu, std)

counts, bins_edges, _ = plt.hist(dados, bins=7, alpha=0.6, color='skyblue', 
                                 edgecolor='black', label='Histograma dos Dados')
bin_width = bins_edges[1] - bins_edges[0]
ajuste = ajuste * len(dados) * bin_width

plt.plot(x_range, ajuste, 'r-', linewidth = 2, label = f'Ajuste Normal (μ = {mu:.2f}, σ = {std:.2f})')
plt.hist(dados, bins = 7, density = False,    alpha = 0.6, color = 'skyblue', 
         edgecolor = 'black', label = 'Histograma dos Dados')
plt.title(f"Histograma")
plt.xlabel("Tempo (s)")
plt.ylabel("Frequencia")
plt.grid(axis = 'y', alpha = 0.5)
plt.show()

arq.close()
