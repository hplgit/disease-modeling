# Discontinuous p(t) coeff
import matplotlib.pyplot as plt
import numpy as np
x = np.arange(0, 25, 1)
x[5] = 6
x[16] = 15
y = np.zeros(x.size)
y[6:16] = 0.05
axis = [x[0], x[-1], -0.01, 0.08]
plt.plot(x, y)
plt.axis(axis)
plt.xlabel('t')
plt.ylabel('p(t)')
plt.savefig('tmp.png')
plt.savefig('tmp.pdf')
plt.show()
