# Probability Theory II
## Final Project:

The goal is to estimate parameters related to fish settlement. 

Labelled "settlers from the black lagoon" we define a toy problem that models fish settlement on a 1-dimensional ocean floor. 

Using "true value" parameters, we then generate data that simulates fish settlement according to our model. Then, we use Bayes' theorem to develop a posterior for the desired parameters from our simulated data. We implement a Metropolis-Hastings to approximate the resulting posterior distributions of the "unknown" parameters in the model. We repeat this process for different markers on the ocean floor, and decide which arrangement of markers gives us the best estimate of the true mean of our model.

<div style="display: flex; flex-wrap: wrap;">
    <div style="width: 50%;">
        <img src="https://raw.githubusercontent.com/louisnass/louisnass.github.io/master/MathModelCoralEcology/BayesianEstimation/Uniform.jpeg" alt="Contract" width="300">
        <p>Uniform markers</p>
    </div>
    <div style="width: 50%;">
        <img src="https://raw.githubusercontent.com/louisnass/louisnass.github.io/master/MathModelCoralEcology/BayesianEstimation/Clustered.jpeg" alt="Expand" width="300">
        <p>Clustered markers</p>
    </div>
</div>

Here is my [presentation](https://github.com/louisnass/louisnass.github.io/blob/master/MathModelCoralEcology/BayesianEstimation/Prob_II_Final.pdf).
