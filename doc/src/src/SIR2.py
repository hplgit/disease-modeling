# Time unit: 1 h
beta = 10./(40*8*24)
nu = 3./(15*24)
print 'beta:', beta, 'nu:', nu
gamma = 1./(24*50)   # loss of immunity: 50 days

beta /= 4
dt = 0.1             # 6 min
D = 300              # simulate for D days
N = int(D*24/dt)     # corresponding no of hours

from numpy import zeros, linspace
t = linspace(0, N*dt, N+1)
S = zeros(N+1)
I = zeros(N+1)
R = zeros(N+1)

# Initial condition
S[0] = 50
I[0] = 1
R[0] = 0

# Step equations forward in time
for n in range(N):
    S[n+1] = S[n] - dt*beta*S[n]*I[n] + dt*gamma*R[n]
    I[n+1] = I[n] + dt*beta*S[n]*I[n] - dt*nu*I[n]
    R[n+1] = R[n] + dt*nu*I[n] - dt*gamma*R[n]

from matplotlib.pyplot import plot, savefig, legend, xlabel, show
plot(t, S, 'k-', t, I, 'b-', t, R, 'r-')
legend(['S', 'I', 'R'], loc='lower right')
xlabel('hours')
savefig('tmp.pdf'); savefig('tmp.png')

print S[:4], I[:4], R[:4]
show()
