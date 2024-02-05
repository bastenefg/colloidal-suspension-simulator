# A colloidal suspension simulator in MATLAB

This MATLAB implementation outputs a statistically accurate random walk simulation, visually consistent with what can be expected from observing colloids in suspension in a viscous fluid under a microscope. The results can be saved as .tiff stacks for postprocessing (trackpy, ...). To run the code, download the contents of the repository, place them all in the same folder, and run random_walker.m in MATLAB.

The parameters the user can change from the GUI are 

1. Time interval between frames (tau)
2. Temperature (T)
3. Fluid viscosity (mu) 
4. Particle diameter (a)
5. Number of particles (Npart)
6. Number of iterations (iter)

Other more advanced parameters (mm-per-pixel ratio, spatial domain, file save format, etc.) can be accessed in the code directly.
