%% Generate SVD, use to generate LDA threshold to discriminate between
%% dogs and cats.
function [result, w, U, S, V, threshold] = dc_trainer(dog0, cat0, feature)
  nd = length(dog0(1,:));
  nc = length(cat0(1,:));

  [U,S,V] = svd([double(dog0),double(cat0)],0); % reduced SVD

  animals = S*V';
  U = U(:,1:feature);
  dogs = animals(1:feature,1:nd);
  cats = animals(1:feature,nd+1:nd+nc);

  md = mean(dogs, 2);
  mc = mean(cats, 2);

  Sw = 0 % within class variances
  for i = 1:nd
    Sw = Sw + (dogs(:, i) - md) * (dogs(:, i) - md)';
  end
  for i = 1:nc
    Sw = Sw + (cats(:, i) - mc) * (cats(:, i) - mc)';
  end

  Sb = (md - mc) * (md - mc)'; % between class

  % linear discriminant analysis
  [V2,D] = eig(Sb,Sw);
  [lambda,ind] = max(abs(diag(D)));
  w = V2(:,ind);
  w = w/norm(w,2);

  vdog = w' * dogs;
  vcat = w' * cats;
  result = [vdog,vcat];
  if mean(vdog) > mean(vcat)
    w = -w;
    vdog = -vdog;
    vcat = -vcat;
  end
  % dog < threshold < cat

  sortdog = sort(vdog);
  sortcat = sort(vcat);

  t1 = length(sortdog);
  t2 = 1;

  while sortdog(t1) > sortcat(t2)
    t1 = t1-1;
    t2 = t2+1;
  end

  threshold = (sortdog(t1) + sortcat(t2))/2;

  figure('name', 'LDA Stats for Dogs vs Cats')
  subplot(1,2,1)
  hist(sortdog);
  hold on, plot([threshold threshold],[0 20],'r')
  set(gca,'Xlim',[-10 10],'Ylim',[0 20],'Fontsize',[14])
  title('Dog Stats')
  subplot(1,2,2)
  %hist(sortcat,'r'); hold on, plot([threshold threshold],[0 20],'r')
  set(gca,'Xlim',[-10 10],'Ylim',[0 20],'Fontsize',[14])
  title('Cat Stats')

end
