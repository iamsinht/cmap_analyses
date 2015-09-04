function [scoreds] = compute_cmap_score(ds1, ds2, varargin)

pnames = {'metric', ...
    'es_tail', ...
    'gset_size'};
dflts = {'wtcs', ...
    'both', ...
    50};
args = parse_args(pnames, dflts, varargin{:});


if ~isequal(ds1.rid, ds2.rid)
    idx = match_vectors(ds1.rid, ds2.rid);
    ds2 = gctsubset(ds2, 'rsubset', idx);
end

ds1r = rank_score_mat(ds1);
ds2r = rank_score_mat(ds2);

upidx1 = cell(numel(ds1.cid), 1);
dnidx1 = cell(numel(ds1.cid), 1);

for k = 1:numel(ds1.cid)
  upidx1{k} = find(ds1r.mat(:,k) <= args.gset_size);
  dnidx1{k} = find(ds1r.mat(:,k) > size(ds1.rid) - args.gset_size);   % Use >, not >=
end

[scoreds, leadf] = cmap_score_core(upidx1, dnidx1, ds2r, numel(ds1.rid), 1, ds2, args.es_tail);

end
