# yuv.yazi

Yazi plugin for viewing YUV-files

Works by extracting dimensions from filename, like "FourPeople_1280x720_30.yuv" or looking for specif strings like "1080p" in the name.

## Install the plugin:

```sh
ya pack -a figgis/yuv
```

Create `~/.config/yazi/yazi.toml` and add:

```toml
[plugin]
  previewers = [
    { name = "*.yuv", run = "yuv" },
  ]
  prepend_preloaders = [
  	{ name = "*.yuv", run = "yuv" },
  ]
```
