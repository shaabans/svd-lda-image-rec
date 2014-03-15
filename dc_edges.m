%% Detect edges. Initially using Sobel with a threshold of
%% 240, but try varing these to see how it affects results.
function dcEdges = dc_edges(dcfile)
  [m, n] = size(dcfile); %4096 x 80
  nw = 64 * 64;
  for i = 1:n
    X = double(reshape(dcfile(:, i), 64, 64));
    dcEdges(:, i) = reshape(edge(X, 'Sobel', 25) .* 256, nw, 1);
  end
end
