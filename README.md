# yuv.yazi

Yazi plugin for viewing YUV- and y4m-files. Defaults to 4:2:0 subsampling for YUV.

Works by extracting dimensions from filename, like "FourPeople_1280x720_30.yuv" or looking for specif strings like "1080p" in the name.
y4m handles this autimatically bot hfor dimensions and format/subsampling. 

## Install the plugin:

```sh
ya pkg add figgis/yuv
```

Create `~/.config/yazi/yazi.toml` and add:

```toml
[plugin]
  prepend_previewers = [
    { name = "*.yuv", run = "yuv" },
  ]
  prepend_preloaders = [
  	{ name = "*.yuv", run = "yuv" },
  ]
```
