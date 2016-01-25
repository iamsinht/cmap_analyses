function res = apply_metric(ds1, ds2, varargin)

params = {'metric', ...
    'dataname', ...
    'outdir'};
dflts = {'', ...
    '', ...
    '/cmap/projects/metric_analysis/results'};
args = parse_args(params, dflts, varargin{:});


validate_data(ds1, ds2, args);


switch lower(args.metric)
  case 'spearman'
    t = apply_spearman(ds1, ds2, args);
  case 'pearson'
    t = apply_pearson(ds1, ds2, args);
  case 'wtcslm'
    t = apply_wtcslm(ds1, ds2, args);
  case 'unflattened_wtcslm'
    t = apply_unflattened_wtcslm(ds1, ds2, args);
  otherwise
    error('Invalid metric parameter: specify which metric to use');
end

res.mat = t;
res.cid = ds1.cid;
res.rid = ds2.cid;
res.cdesc = ds1.cdesc;
res.chd = ds1.chd;

end


function t = apply_spearman(ds1, ds2, args)
  t = fastcorr(ds1.mat, ds2.mat, 'type', 'Spearman');
end

function t = apply_pearson(ds1, ds2, args)
  t = fastcorr(ds1.mat, ds2.mat, 'type', 'Pearson');
end

function t = apply_wtcslm(ds1, ds2, args)
  sds = compute_cmap_score(ds1, ds2, 'metric', 'wtcs', 'es_tail', 'both', 'gset_size', 50);
  t = sds(:,:,3);
end

function t = apply_unflattened_wtcslm(ds1, ds2, args)
  sds = compute_cmap_score(ds1, ds2, 'metric', 'wtcs', 'es_tail', 'both', 'gset_size', 50);
  t = (sds(:,:,1) - sds(:,:,2))/2;
end

