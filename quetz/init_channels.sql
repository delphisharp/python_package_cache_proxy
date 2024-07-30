delete from  main.channels;

insert into main.channels (name, description, private, mirror_channel_url, mirror_mode, timestamp_mirror_sync, size, size_limit, ttl, channel_metadata)
values  ('cloud', null, 0, 'https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud', 'proxy', 0, 0, null, 36000, '{"includelist": null, "excludelist": null, "proxylist": null}');

insert into main.channels (name, description, private, mirror_channel_url, mirror_mode, timestamp_mirror_sync, size, size_limit, ttl, channel_metadata)
values  ('pkgs', null, 0, 'https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs', 'proxy', 0, 0, null, 36000, '{"includelist": null, "excludelist": null, "proxylist": null}');
