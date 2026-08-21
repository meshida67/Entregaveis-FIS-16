import numpy as np
import matplotlib.pyplot as plt

dados = np.loadtxt("dados.txt")

media = np.mean(dados)
sigma = np.std(dados, ddof = 0)
print(media)
print (sigma)

plt.hist(dados, color = 'lightgreen', ec = 'black', bins = 10)
plt.title(f"Histograma")
plt.xlabel("Tempo (s)")
plt.ylabel("Frequencia")
plt.show()

arq.close()
