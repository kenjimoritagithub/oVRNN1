function simseed = setrandoms(simseed)

s = RandStream.create('mt19937ar','seed',simseed);
[v d] = version;
if str2num(d(end-3:end)) < 2013
    RandStream.setDefaultStream(s);
else
    RandStream.setGlobalStream(s);
end
