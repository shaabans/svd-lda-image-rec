svd-lda-image-rec
=================

A simple example of image recognition using singular value decomposition and linear discriminant analysis, based on examples from the excellent Computational Methods for Data Analysis course on Coursera taught by Nathan Kutz.

Usage
-----
Grab a copy of [GNU Octave](http://octave.sourceforge.net/) (or switch to the Matlab branch if you're using Matlab rather than Octave) and the [image package](http://octave.sourceforge.net/image/), run Octave in this directory, and run main.m by simply typing `main` in Octave.

This will spit out a handful of graphs and images illustrating some interesting stuff. It will also print the success rate that indicates how well things went on the test data set (which should start out at 81.25%).

Have a look at the code to see what's going on and let me know how you improve it with pull requests!

Basic Idea
----------

This is a rough sketch of what's going on:

1. Load training data consisting of 80 dogs and 80 cats. Each consists of a 64x64 black and white image packed into one 4096x80 matrix for dogs and one for cats. One of the figures shows the first 9 dogs. These images are heavily processed - they're perfect face shots.
2. Grab image edges, which we'll use for training. Another image shows how this looks on the first 9 dogs. Playing with the edge detection methods in dc_edges.m will have a big effect on the results.
3. Generate the singular value decomposition for a matrix that includes _both sets of data_. We end up with "eigenfaces" (shown in one of the figures) in the U matrix that are the basis columns with which any individual image can be generated, weights of each basis column in the S matrix (we only use the first 20 features ... you can see why in the figure that shows the strengths of each feature), and the "mix" of basis vectors in U required to generate each animal in V.
4. Use linear discriminant analysis to project the results and come up with a cat/dog threshold.  Refer to the figure showing the LDA stats ... the red line is the threshold, one side is cats, the other is dogs.
5. Load test data (can't use training data to test, that would make us think we were way more accurate than we really are).
6. Generate the same LDA projection and test against the threshold we calculated earlier.
7. Calculate success rate ... around 81% with the settings provided here.
