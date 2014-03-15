clear all; close all;

%% If using octave uncomment the following.
%% Be sure to install the image package first by typing the
%% following within Octave:
%% pkg install -forge image
%pkg load image;

load 'images/dog_data';
load 'images/cat_data';

dogEdges = dc_edges(dog);
catEdges = dc_edges(cat);

%% Train based on the number of SVD features specified below
features = 20; % 1 < feature < 80
[result, w, U, S, V, threshold] = dc_trainer(dogEdges, catEdges, features);

%% Some interesting plots, comment out once you've gotten sick of
%% seeing them as you experiment.
figure('name', '1st 9 Dogs');
for j = 1:9
  subplot(3,3,j);
  dog1 = reshape(dog(:,j), 64, 64);
  imshow(uint8(dog1));
end

figure('name', '1st 9 Dog Edges');
for j = 1:9
  subplot(3,3,j);
  dog1 = double(reshape(dogEdges(:,j), 64, 64));
  imshow(uint8(dog1));
end

figure('name', '1st 4 "Eigenfaces"');
for j = 1:4
  subplot(2,2,j)
  ut1 = reshape(U(:,j),64,64);
  ut2 = ut1(64:-1:1,:);
  pcolor(ut2)
  colormap('gray');
  set(gca,'Xtick',[],'Ytick',[])
end

figure('name', 'Principal Component Strengths');
subplot(2,1,1)
plot(diag(S),'ko','Linewidth',[2])
set(gca,'Fontsize',[14],'Xlim',[0 80])
subplot(2,1,2)
semilogy(diag(S),'ko','Linewidth',[2])
set(gca,'Fontsize',[14],'Xlim',[0 80])

%% Load test data and test drive
load 'images/dc_test_set.mat'

figure('name', 'Test Set')
for j=1:16
  subplot(4,4,j)
  test = reshape(testSet(:,j),64,64);
  imshow(uint8(test))
end

testEdges = dc_edges(testSet); % wavelet transformation
testMat = U' * testEdges; % SVD projection
pval = w' * testMat; % LDA projection

%cat = 1, dog = 0
resultVector = (pval > threshold)

disp('Number of mistakes');
errNum = sum(abs(resultVector - hiddenLabels))

disp('Rate of success');
sucRate = 1 - errNum / length(resultVector)
