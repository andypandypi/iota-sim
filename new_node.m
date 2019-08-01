function Node = new_node(alpha, beta, alphaAIMD, betaAIMD, lambda, tsa)
Node = struct('alpha', alpha, 'beta', beta, 'alphaAIMD', alphaAIMD, 'betaAIMD', betaAIMD, 'lambda', lambda, 'tsa', tsa);